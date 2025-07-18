use starknet::{ContractAddress, get_caller_address, get_block_timestamp};
use dojo::model::{ModelStorage};
use dojo::event::EventStorage;
use dojo_starter::model::new_tourn_models::{
    Tournament, TournamentTrait, TournamentStatus, TournamentReward, TournamentCounter,
};
use dojo_starter::types::tournament_types::SnookerTournament;
use dojo_starter::errors::errors::SnooknetError;
use dojo_starter::interfaces::ITournaments::ITournaments;
use dojo_starter::model::player_model::Player;

#[dojo::contract]
pub mod TournamentContract {
    use super::*;

    #[dojo::event]
    #[derive(Copy, Drop, Serde)]
    pub struct TournamentCreated {
        #[key]
        tournament_id: u256,
        name: felt252,
        organizer: ContractAddress,
        start_date: u64,
        end_date: u64,
    }

    #[derive(Copy, Drop, Serde)]
    #[dojo::event]
    pub struct TournamentJoined {
        #[key]
        tournament_id: u256,
        player: ContractAddress,
    }

    #[derive(Copy, Drop, Serde)]
    #[dojo::event]
    pub struct TournamentStarted {
        #[key]
        tournament_id: u256,
        start_date: u64,
    }

    #[derive(Copy, Drop, Serde)]
    #[dojo::event]
    pub struct TournamentEnded {
        #[key]
        tournament_id: u256,
        end_date: u64,
    }

    #[derive(Copy, Drop, Serde)]
    #[dojo::event]
    pub struct TournamentCanceled {
        #[key]
        tournament_id: u256,
        timestamp: u64,
    }

    #[derive(Copy, Drop, Serde)]
    #[dojo::event]
    pub struct PlayerStatsUpdated {
        #[key]
        player: ContractAddress,
        tournament_id: u256,
        xp: u256,
        elo_rating: u256,
        games_won: u64,
        games_lost: u64,
        nft_coins_available: u256,
        level: u32,
        tournaments_won: u64,
        timestamp: u64,
    }

    #[derive(Copy, Drop, Serde)]
    #[dojo::event]
    pub struct MatchStatsUpdated {
        #[key]
        player: ContractAddress,
        tournament_id: u256,
        xp: u256,
        elo_rating: u256,
        games_won: u64,
        games_lost: u64,
        timestamp: u64,
    }

    #[abi(embed_v0)]
    impl TournamentsImpl of super::ITournaments<ContractState> {
        fn create_tournament(
            ref self: ContractState,
            name: felt252,
            max_players: u8,
            start_date: u64,
            end_date: u64,
            rewards: Array<TournamentReward>,
        ) -> u256 {
            let mut world = self.world_default();
            let tournament_id = self.create_new_tournament_id();

            // Validate input parameters
            assert(max_players > 1, SnooknetError::MaxPlayersLessThanTwo.into());
            assert(start_date < end_date, SnooknetError::InvalidStartDate.into());

            let organizer = get_caller_address();
            let tournament_type =
                SnookerTournament::Default; // Default type since not provided in interface

            // Create new tournament
            let new_tournament: Tournament = TournamentTrait::new(
                tournament_id,
                name,
                tournament_type,
                organizer,
                max_players,
                start_date,
                end_date,
                rewards,
            );

            world.write_model(@new_tournament);

            world
                .emit_event(
                    @TournamentCreated { tournament_id, name, organizer, start_date, end_date },
                );

            tournament_id
        }

        fn register_player(ref self: ContractState, tournament_id: u256) {
            let mut world = self.world_default();
            let mut tournament: Tournament = world.read_model(tournament_id);
            let caller = get_caller_address();

            // Check if tournament is open for joining
            assert(
                tournament.status == TournamentStatus::Pending,
                SnooknetError::TournamentNotOpen.into(),
            );

            // Check if tournament is full
            assert(
                tournament.current_players < tournament.max_players,
                SnooknetError::TournamentIsFull.into(),
            );

            // Check if player is already registered
            assert(
                !self.is_player_registered(tournament_id, caller),
                SnooknetError::PlayerAlreadyRegistered.into(),
            );

            // Update tournament with new player
            tournament.players.append(caller);
            tournament.current_players += 1;

            world.write_model(@tournament);

            world.emit_event(@TournamentJoined { tournament_id, player: caller });
        }

        fn start_tournament(ref self: ContractState, tournament_id: u256, end_date: u64) {
            let mut world = self.world_default();
            let mut tournament: Tournament = world.read_model(tournament_id);
            let caller = get_caller_address();

            // Check if caller is the organizer
            assert(caller == tournament.organizer, SnooknetError::NotTournamentOrganizer.into());

            // Check if tournament is pending
            assert(
                tournament.status == TournamentStatus::Pending,
                SnooknetError::TournamentNotPending.into(),
            );

            // Check if end_date is valid
            assert(end_date > get_block_timestamp(), SnooknetError::InvalidEndDate.into());

            // Update tournament status and timestamps
            tournament.status = TournamentStatus::Active;
            tournament.start_date = get_block_timestamp();
            tournament.end_date = end_date;

            world.write_model(@tournament);

            world
                .emit_event(
                    @TournamentStarted { tournament_id, start_date: tournament.start_date },
                );
        }

        fn end_tournament(ref self: ContractState, tournament_id: u256) {
            let mut world = self.world_default();
            let mut tournament: Tournament = world.read_model(tournament_id);
            let caller = get_caller_address();

            // Check if caller is the organizer
            assert(caller == tournament.organizer, SnooknetError::NotTournamentOrganizer.into());

            // Check if tournament is in progress
            assert(
                tournament.status == TournamentStatus::Active,
                SnooknetError::TournamentNotInProgress.into(),
            );

            // Update tournament status and timestamp
            tournament.status = TournamentStatus::Ended;
            tournament.end_date = get_block_timestamp();

            world.write_model(@tournament);

            world.emit_event(@TournamentEnded { tournament_id, end_date: tournament.end_date });
        }

        fn cancel_tournament(ref self: ContractState, tournament_id: u256) {
            let mut world = self.world_default();
            let mut tournament: Tournament = world.read_model(tournament_id);
            let caller = get_caller_address();

            // Check if caller is the organizer
            assert(caller == tournament.organizer, SnooknetError::NotTournamentOrganizer.into());

            // Check if tournament is pending
            assert(
                tournament.status == TournamentStatus::Pending,
                SnooknetError::TournamentNotPending.into(),
            );

            // Update tournament status
            tournament.status = TournamentStatus::Ended; // Treat cancellation as ended

            world.write_model(@tournament);

            world
                .emit_event(
                    @TournamentCanceled { tournament_id, timestamp: get_block_timestamp() },
                );
        }

        fn is_player_registered(
            self: @ContractState, tournament_id: u256, player: ContractAddress,
        ) -> bool {
            let world = self.world_default();
            let tournament: Tournament = world.read_model(tournament_id);
            let mut i = 0;
            let len = ArrayTrait::len(@tournament.players);
            while i < len {
                if *tournament.players.at(i) == player {
                    true;
                }
                i += 1;
            };
            false
        }
        fn update_player_stats(
            ref self: ContractState,
            tournament_id: u256,
            player: ContractAddress,
            xp_delta: u256,
            elo_delta: u256,
            won: bool,
            lost: bool,
            nft_coins_delta: u256,
            level_delta: u32,
            tournament_won: bool,
        ) {
            let mut world = self.world_default();
            let tournament: Tournament = world.read_model(tournament_id);
            let caller = get_caller_address();

            // Validate caller is the tournament organizer
            assert(caller == tournament.organizer, SnooknetError::NotTournamentOrganizer.into());

            // Validate tournament is active or ended
            assert(
                tournament.status == TournamentStatus::Active
                    || tournament.status == TournamentStatus::Ended,
                SnooknetError::TournamentNotInProgressOrEnded.into(),
            );

            // Validate player is registered in the tournament
            assert(
                self.is_player_registered(tournament_id, player),
                SnooknetError::PlayerNotRegistered.into(),
            );

            // Read player model
            let mut player_data: Player = world.read_model(player);

            // Update stats
            player_data.xp += xp_delta;
            player_data.elo_rating += elo_delta;
            if won {
                player_data.games_won += 1;
            }
            if lost {
                player_data.games_lost += 1;
            }
            player_data.nft_coins_available += nft_coins_delta;
            player_data.level += level_delta;
            if tournament_won {
                player_data.tournaments_won += 1;
            }

            // Update leaderboard position (simplified: set to 0, actual logic may vary)
            player_data.leaderboard_position = 0;

            // Store updated player
            world.write_model(@player_data);

            // Emit event
            world
                .emit_event(
                    @PlayerStatsUpdated {
                        player,
                        tournament_id,
                        xp: player_data.xp,
                        elo_rating: player_data.elo_rating,
                        games_won: player_data.games_won,
                        games_lost: player_data.games_lost,
                        nft_coins_available: player_data.nft_coins_available,
                        level: player_data.level,
                        tournaments_won: player_data.tournaments_won,
                        timestamp: get_block_timestamp(),
                    },
                );
        }

        fn update_match_stats(
            ref self: ContractState,
            tournament_id: u256,
            player: ContractAddress,
            won: bool,
            xp_delta: u256,
            elo_delta: u256,
        ) {
            let mut world = self.world_default();
            let tournament: Tournament = world.read_model(tournament_id);
            let caller = get_caller_address();

            // Validate caller is the tournament organizer
            assert(caller == tournament.organizer, SnooknetError::NotTournamentOrganizer.into());

            // Validate tournament is active
            assert(
                tournament.status == TournamentStatus::Active,
                SnooknetError::TournamentNotInProgress.into(),
            );

            // Validate player is registered in the tournament
            assert(
                self.is_player_registered(tournament_id, player),
                SnooknetError::PlayerNotRegistered.into(),
            );

            // Read player model
            let mut player_data: Player = world.read_model(player);

            // Update stats
            if won {
                player_data.games_won += 1;
            } else {
                player_data.games_lost += 1;
            }
            player_data.xp += xp_delta;
            player_data.elo_rating += elo_delta;

            // Update leaderboard position (simplified: set to 0, actual logic may vary)
            player_data.leaderboard_position = 0;

            // Store updated player
            world.write_model(@player_data);

            // Emit event
            world
                .emit_event(
                    @MatchStatsUpdated {
                        player,
                        tournament_id,
                        xp: player_data.xp,
                        elo_rating: player_data.elo_rating,
                        games_won: player_data.games_won,
                        games_lost: player_data.games_lost,
                        timestamp: get_block_timestamp(),
                    },
                );
        }
    }

    #[generate_trait]
    impl InternalImpl of InternalTrait {
        fn world_default(self: @ContractState) -> dojo::world::WorldStorage {
            self.world(@"Snooknet")
        }

        fn create_new_tournament_id(ref self: ContractState) -> u256 {
            let mut world = self.world_default();
            let mut tournament_counter: TournamentCounter = world.read_model('v0');
            let new_val = tournament_counter.current_val + 1;
            tournament_counter.current_val = new_val;
            world.write_model(@tournament_counter);
            new_val
        }
    }
}
