use starknet::{ContractAddress, get_caller_address, get_block_timestamp, contract_address_const};

use dojo::model::{ModelStorage};
use dojo::event::EventStorage;


use dojo_starter::interfaces::ISnooknet::ISnooknet;
use dojo_starter::model::game_model::{
    Game, GameTrait, GameState, GameCounter, MatchStatus, BallState, GameIndex,GameScore
};
use dojo_starter::model::tournament_model::{
    Tournament as TournamentModel, TournamentTrait, TournamentStatus, TournamentReward,
    TournamentCounter,
};
use dojo_starter::model::player_model::{Player, PlayerTrait};
use dojo_starter::errors::errors::{SnooknetError};

// dojo decorator
#[dojo::contract]
pub mod Snooknet {
    use super::*;

    #[derive(Copy, Drop, Serde)]
    #[dojo::event]
    pub struct PlayerCreated {
        #[key]
        pub player: ContractAddress,
        pub timestamp: u64,
    }

    #[derive(Copy, Drop, Serde)]
    #[dojo::event]
    pub struct GameCreated {
        #[key]
        pub game_id: u256,
        pub timestamp: u64,
    }

    #[derive(Copy, Drop, Serde)]
    #[dojo::event]
    pub struct GameEnded {
        #[key]
        pub game_id: u256,
        pub timestamp: u64,
    }

    #[derive(Copy, Drop, Serde)]
    #[dojo::event]
    pub struct Winner {
        #[key]
        pub game_id: u256,
        pub winner: ContractAddress,
    }

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

    #[dojo::event]
    #[derive(Copy, Drop, Serde)]
    pub struct TournamentJoined {
        #[key]
        tournament_id: u256,
        player: ContractAddress,
    }

    #[dojo::event]
    #[derive(Copy, Drop, Serde)]
    pub struct TournamentEnded {
        #[key]
        tournament_id: u256,
        end_date: u64,
    }


    #[abi(embed_v0)]
    impl SnooknetImpl of ISnooknet<ContractState> {
        fn create_player(ref self: ContractState) {
            let mut world = self.world_default();

            let caller: ContractAddress = get_caller_address();

            let new_player: Player = PlayerTrait::new(caller, 0, 0, 0, 0, 0, 0, 1);

            world.write_model(@new_player);

            world.emit_event(@PlayerCreated { player: caller, timestamp: get_block_timestamp() });
        }


        fn create_new_game_id(ref self: ContractState) -> u256 {
            let mut world = self.world_default();
            let mut game_counter: GameCounter = world.read_model('v0');
            let new_val = game_counter.current_val + 1;
            game_counter.current_val = new_val;
            world.write_model(@game_counter);
            new_val
        }

        fn create_match(
            ref self: ContractState, opponent: ContractAddress, stake_amount: u256,
        ) -> u256 {
            let mut world = self.world_default();
            let game_id = self.create_new_game_id();
            let timestamp = get_block_timestamp();
            let player_1 = get_caller_address();

            assert(player_1 != opponent, SnooknetError::PlayersCannotBeSame.into());
            assert(stake_amount > 0, SnooknetError::StakeMustBePositive.into());

            let mut new_game: Game = GameTrait::new(game_id, player_1, opponent, stake_amount);

            new_game.current_turn = player_1;
            new_game.red_balls_remaining = 15;
            new_game.state = GameState::NotStarted;
            new_game.winner = contract_address_const::<0x0>();

            world.write_model(@new_game);

            // Index by player1
            let index1 = GameIndex { player: player_1, game_id, created_at: timestamp };
            world.write_model(@index1);

            // Index by player2
            let index2 = GameIndex { player: opponent, game_id, created_at: timestamp };
            world.write_model(@index2);

            world.emit_event(@GameCreated { game_id, timestamp });
            game_id
        }

        fn retrieve_game(ref self: ContractState, game_id: u256) -> Game {
            // Get default world
            let mut world = self.world_default();
            //get the game state
            let game: Game = world.read_model(game_id);
            game
        }

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

            let caller = get_caller_address();

            // Create new tournament
            let mut new_tournament: TournamentModel = TournamentTrait::new(
                tournament_id, name, caller, max_players, start_date, end_date, rewards,
            );

            world.write_model(@new_tournament);

            world
                .emit_event(
                    @TournamentCreated {
                        tournament_id, name, organizer: caller, start_date, end_date,
                    },
                );

            tournament_id
        }

        fn join_tournament(ref self: ContractState, tournament_id: u256) {
            // Get the caller's address
            let caller = get_caller_address();

            let mut world = self.world_default();
            let mut tournament: TournamentModel = world.read_model(tournament_id);

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

            // Update tournament with new players array
            tournament.current_players += 1;

            // Store updated tournament
            world.write_model(@tournament);

            // Emit event
            world.emit_event(@TournamentJoined { tournament_id, player: caller });
        }

        fn end_tournament(ref self: ContractState, tournament_id: u256) {
            let mut world = self.world_default();
            let mut tournament: TournamentModel = world.read_model(tournament_id);

            // Check if tournament is in progress
            assert(
                tournament.status == TournamentStatus::Pending
                    || tournament.status == TournamentStatus::Active,
                SnooknetError::TournamentNotInProgress.into(),
            );

            // Update tournament status and timestamp
            tournament.status = TournamentStatus::Ended;
            tournament.end_date = get_block_timestamp();

            // Store updated tournament
            world.write_model(@tournament);

            world.emit_event(@TournamentEnded { tournament_id, end_date: tournament.end_date });
        }

        fn start_match(ref self: ContractState, game_id: u256) -> bool {
            let mut world = self.world_default();
            let mut game: Game = world.read_model(game_id);
            let caller = get_caller_address();

            assert(
                caller == game.player1 || caller == game.player2, SnooknetError::NotAPlayer.into(),
            );
            assert(game.state == GameState::NotStarted, SnooknetError::GameAlreadyStarted.into());

            let start_time = get_block_timestamp();
            game.state = GameState::InProgress;
            game.match_status = MatchStatus::Ongoing;
            game.current_turn = game.player1;
            game.start_time = start_time;
            game.updated_at = start_time;

            world.write_model(@game);
            true
        }

        fn pause_match(ref self: ContractState, game_id: u256) -> bool {
            let mut world = self.world_default();
            let mut game: Game = world.read_model(game_id);
            let caller = get_caller_address();

            assert(caller == game.player1 || caller == game.player2, 'Not a player');
            assert(game.state == GameState::InProgress, SnooknetError::GameNotInProgress.into());
            assert(game.match_status == MatchStatus::Ongoing, SnooknetError::GameNotOngoing.into());

            game.match_status = MatchStatus::Paused;
            game.updated_at = get_block_timestamp();

            world.write_model(@game);
            true
        }

        fn end_match(ref self: ContractState, game_id: u256, winner: ContractAddress) {
            let mut world = self.world_default();
            let mut game: Game = world.read_model(game_id);
            let caller = get_caller_address();

            assert(
                caller == game.player1 || caller == game.player2, SnooknetError::NotAPlayer.into(),
            );
            assert(game.state == GameState::InProgress, SnooknetError::GameNotInProgress.into());
            assert(
                caller == winner || (game.player1 == winner || game.player2 == winner),
                SnooknetError::InvalidWinner.into(),
            );

            let timestamp = get_block_timestamp();
            game.winner = winner;
            game.state = GameState::Finished;
            game.match_status = MatchStatus::Ended;
            game.updated_at = timestamp;

            world.write_model(@game);
            world.emit_event(@Winner { game_id, winner });
            world.emit_event(@GameEnded { game_id, timestamp });
        }

        // fn pot_ball(ref self: ContractState, game_id: u256, ball_type: felt252, is_cue_foul: bool) {
        //     let mut world = self.world_default();
        //     let mut game: Game = world.read_model(game_id);
        //     let mut score: GameScore = world.read_model(game_id);
        //     let caller = get_caller_address();

        //     assert(caller == game.current_turn, SnooknetError::NotAPlayer.into());
        //     assert(game.state == GameState::InProgress, SnooknetError::GameNotInProgress.into());

        //     let timestamp = get_block_timestamp();
        //     let mut points = 0;

        //     if is_cue_foul {
        //         game.cue_ball_fouled = true;
        //         let opponent = if game.current_turn == game.player1 { game.player2 } else { game.player1 };
        //         if opponent == game.player1 {
        //             score.player1_score += 4; // Minimum foul penalty
        //         } else {
        //             score.player2_score += 4;
        //         }
        //         score.last_foul = timestamp;
        //     } else if ball_type == "red" && game.red_balls_remaining > 0 {
        //         game.red_balls_remaining -= 1;
        //         points = 1;
        //     } else if game.red_balls_remaining == 0 {
        //         let yellow_state = world.read_model::<BallState>((game_id, "yellow"));
        //         let green_state = world.read_model::<BallState>((game_id, "green"));
        //         let brown_state = world.read_model::<BallState>((game_id, "brown"));
        //         let blue_state = world.read_model::<BallState>((game_id, "blue"));
        //         let pink_state = world.read_model::<BallState>((game_id, "pink"));
        //         let black_state = world.read_model::<BallState>((game_id, "black"));

        //         if ball_type == "yellow" && !yellow_state.is_potted {
        //             points = 2;
        //         } else if ball_type == "green" && !green_state.is_potted {
        //             points = 3;
        //         } else if ball_type == "brown" && !brown_state.is_potted {
        //             points = 4;
        //         } else if ball_type == "blue" && !blue_state.is_potted {
        //             points = 5;
        //         } else if ball_type == "pink" && !pink_state.is_potted {
        //             points = 6;
        //         } else if ball_type == "black" && !black_state.is_potted {
        //             points = 7;
        //         } else {
        //             assert(false, SnooknetError::InvalidBallType.into());
        //         }
        //         let mut ball = BallState { game_id, ball_type, is_potted: true, last_updated: timestamp };
        //         world.write_model(@ball);
        //     } else {
        //         assert(false, SnooknetError::InvalidBallType.into());
        //     }

        //     if points > 0 {
        //         if game.current_turn == game.player1 {
        //             score.player1_score += points;
        //         } else {
        //             score.player2_score += points;
        //         }
        //     }

        //     game.updated_at = timestamp;
        //     world.write_model(@game);
        //     world.write_model(@score);

        //     if points == 0 || is_cue_foul {
        //         game.current_turn = if game.current_turn == game.player1 { game.player2 } else { game.player1 };
        //         world.write_model(@game);
        //     }

        //     if game.red_balls_remaining == 0 &&
        //        yellow_state.is_potted &&
        //        green_state.is_potted &&
        //        brown_state.is_potted &&
        //        blue_state.is_potted &&
        //        pink_state.is_potted &&
        //        black_state.is_potted {
        //         game.state = GameState::Finished;
        //         game.winner = if score.player1_score > score.player2_score { game.player1 } else { game.player2 };
        //         world.write_model(@game);
        //         world.emit_event(@GameEnded { game_id, timestamp });
        //     }
        // }

    }

    #[generate_trait]
    impl InternalImpl of InternalTrait {
        // Use the default namespace "dojo_starter".
        // This function is handy since the ByteArray can't be const.
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



