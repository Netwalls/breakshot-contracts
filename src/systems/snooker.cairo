// use starknet::{ContractAddress, get_caller_address, get_block_timestamp, contract_address_const};
// use dojo::model::{ModelStorage};
// use dojo::event::EventStorage;
// use dojo_starter::model::new_tourn_models::{
//     Tournament, TournamentTrait, TournamentStatus, TournamentReward, TournamentCounter
// };
// use dojo_starter::types::tournament_types::SnookerTournament;
// use dojo_starter::errors::errors::SnooknetError;
// use dojo_starter::model::player_model::{Player, PlayerTrait};
// use dojo_starter::model::game_model::{Game, GameTrait, GameState, MatchStatus, GameCounter,
// GameIndex, GameScore, BallState};
// use dojo_starter::interfaces::ITournaments::ITournaments;
// use dojo_starter::interfaces::ISnooknet::ISnooknet;
// use dojo_starter::types::task::{Task, TaskTrait};
// use dojo_starter::achievements::achievement::{SnookerAchievement, SnookerAchievementTrait};

// // Mock TournamentReward (replace with actual if defined)
// #[derive(Copy, Drop, Serde, Debug)]
// pub struct TournamentReward {
//     pub amount: u256,
//     pub reward_type: felt252,
// }

// #[dojo::contract]
// pub mod Snooknet {
//     use super::*;
//     use array::ArrayTrait;

//     #[dojo::event]
//     #[derive(Copy, Drop, Serde)]
//     pub struct PlayerCreated {
//         #[key]
//         pub player: ContractAddress,
//         pub timestamp: u64,
//     }

//     #[dojo::event]
//     #[derive(Copy, Drop, Serde)]
//     pub struct MatchCreated {
//         #[key]
//         pub game_id: u256,
//         pub player1: ContractAddress,
//         pub player2: ContractAddress,
//         pub tournament_id: u256,
//         pub stake_amount: u256,
//         pub timestamp: u64,
//     }

//     #[dojo::event]
//     #[derive(Copy, Drop, Serde)]
//     pub struct MatchStarted {
//         #[key]
//         pub game_id: u256,
//         pub timestamp: u64,
//     }

//     #[dojo::event]
//     #[derive(Copy, Drop, Serde)]
//     pub struct MatchPaused {
//         #[key]
//         pub game_id: u256,
//         pub timestamp: u64,
//     }

//     #[dojo::event]
//     #[derive(Copy, Drop, Serde)]
//     pub struct MatchEnded {
//         #[key]
//         pub game_id: u256,
//         pub winner: ContractAddress,
//         pub timestamp: u64,
//     }

//     #[dojo::event]
//     #[derive(Copy, Drop, Serde)]
//     pub struct BallPotted {
//         #[key]
//         pub game_id: u256,
//         pub player: ContractAddress,
//         pub ball_type: felt252,
//         pub points: u32,
//         pub timestamp: u64,
//     }

//     #[dojo::event]
//     #[derive(Copy, Drop, Serde)]
//     pub struct AchievementUnlocked {
//         #[key]
//         pub player: ContractAddress,
//         pub achievement: SnookerAchievement,
//         pub timestamp: u64,
//     }

//     #[generate_trait]
//     impl InternalImpl of InternalTrait {
//         fn world_default(self: @ContractState) -> dojo::world::WorldStorage {
//             self.world(@"Snooknet")
//         }

//         fn create_new_game_id(ref self: ContractState) -> u256 {
//             let mut world = self.world_default();
//             let mut game_counter: GameCounter = world.read_model('v0');
//             let new_val = game_counter.current_val + 1;
//             game_counter.current_val = new_val;
//             world.write_model(@game_counter);
//             new_val
//         }

//         fn validate_player(self: @ContractState, player: ContractAddress) -> bool {
//             let world = self.world_default();
//             world.has_model(player)
//         }

//         fn validate_match_participant(self: @ContractState, game: @Game, caller: ContractAddress)
//         {
//             assert(
//                 *game.player1 == caller || *game.player2 == caller,
//                 SnooknetError::NotMatchParticipant.into()
//             );
//         }

//         fn check_achievements(ref self: ContractState, player: ContractAddress, game_id: u256,
//         break_score: u32) {
//             let mut world = self.world_default();
//             let mut player_data: Player = world.read_model(player);
//             let timestamp = get_block_timestamp();

//             // FirstPot: First game won
//             if player_data.games_won == 1 {
//                 world.emit_event(
//                     @AchievementUnlocked {
//                         player, achievement: SnookerAchievement::FirstPot, timestamp
//                     }
//                 );
//             }

//             // BreakMaster: Score a break of 50+
//             if break_score >= 50 {
//                 world.emit_event(
//                     @AchievementUnlocked {
//                         player, achievement: SnookerAchievement::BreakMaster, timestamp
//                     }
//                 );
//             }

//             // CenturyMaker: Score a century break
//             if break_score >= 100 {
//                 world.emit_event(
//                     @AchievementUnlocked {
//                         player, achievement: SnookerAchievement::CenturyMaker, timestamp
//                     }
//                 );
//             }
//         }
//     }

//     #[abi(embed_v0)]
//     impl SnooknetImpl of super::ISnooknet<ContractState> {
//         fn create_player(ref self: ContractState) {
//             let mut world = self.world_default();
//             let caller = get_caller_address();

//             // Check if player exists
//             assert(!self.validate_player(caller), SnooknetError::PlayerAlreadyRegistered.into());

//             let player = PlayerTrait::new(caller, 0, 0, 1500, 0, 0, 0, 1, 0);
//             world.write_model(@player);

//             world.emit_event(@PlayerCreated { player: caller, timestamp: get_block_timestamp()
//             });
//         }

//         fn create_match(ref self: ContractState, opponent: ContractAddress, stake_amount: u256)
//         -> u256 {
//             let mut world = self.world_default();
//             let caller = get_caller_address();
//             let timestamp = get_block_timestamp();

//             // Validate inputs
//             assert(caller != opponent, SnooknetError::InvalidOpponent.into());
//             assert(self.validate_player(caller), SnooknetError::PlayerNotRegistered.into());
//             assert(self.validate_player(opponent), SnooknetError::PlayerNotRegistered.into());
//             assert(stake_amount > 0, SnooknetError::StakeMustBePositive.into());

//             let game_id = self.create_new_game_id();
//             let game = GameTrait::new(game_id, 0, caller, opponent, stake_amount);

//             // Initialize game indices and score
//             let game_index1 = GameIndex { player: caller, game_id, created_at: timestamp };
//             let game_index2 = GameIndex { player: opponent, game_id, created_at: timestamp };
//             let game_score = GameScore { game_id, player1_score: 0, player2_score: 0, last_foul:
//             0 };

//             // Initialize ball states
//             let ball_types = array!["red", "yellow", "green", "brown", "blue", "pink", "black"];
//             let mut ball_states = ArrayTrait::new();
//             let mut i = 0;
//             while i < ball_types.len() {
//                 ball_states.append(BallState {
//                     game_id,
//                     ball_type: *ball_types.at(i),
//                     is_potted: false,
//                     last_updated: timestamp,
//                 });
//                 i += 1;
//             };

//             // Batch insert to reduce gas
//             world.write_model(@game);
//             world.write_model(@game_index1);
//             world.write_model(@game_index2);
//             world.write_model(@game_score);
//             for ball_state in ball_states {
//                 world.write_model(@ball_state);
//             };

//             world.emit_event(
//                 @MatchCreated {
//                     game_id,
//                     player1: caller,
//                     player2: opponent,
//                     tournament_id: 0,
//                     stake_amount,
//                     timestamp,
//                 }
//             );

//             game_id
//         }

//         fn create_new_game_id(ref self: ContractState) -> u256 {
//             self.InternalImpl_create_new_game_id()
//         }

//         fn start_match(ref self: ContractState, game_id: u256) -> bool {
//             let mut world = self.world_default();
//             let mut game: Game = world.read_model(game_id);
//             let caller = get_caller_address();

//             self.validate_match_participant(@game, caller);
//             assert(game.match_status == MatchStatus::Pending,
//             SnooknetError::MatchNotPending.into());

//             game.current_turn = game.player1;
//             game.match_status = MatchStatus::Ongoing;
//             game.state = GameState::InProgress;
//             game.start_time = get_block_timestamp();
//             game.updated_at = game.start_time;

//             world.write_model(@game);
//             world.emit_event(@MatchStarted { game_id, timestamp: game.start_time });

//             true
//         }

//         fn pause_match(ref self: ContractState, game_id: u256) -> bool {
//             let mut world = self.world_default();
//             let mut game: Game = world.read_model(game_id);
//             let caller = get_caller_address();

//             self.validate_match_participant(@game, caller);
//             assert(game.match_status == MatchStatus::Ongoing,
//             SnooknetError::MatchNotInProgress.into());

//             game.match_status = MatchStatus::Paused;
//             game.updated_at = get_block_timestamp();

//             world.write_model(@game);
//             world.emit_event(@MatchPaused { game_id, timestamp: game.updated_at });

//             true
//         }

//         fn end_match(ref self: ContractState, game_id: u256, winner: ContractAddress) {
//             let mut world = self.world_default();
//             let mut game: Game = world.read_model(game_id);
//             let caller = get_caller_address();
//             let timestamp = get_block_timestamp();

//             self.validate_match_participant(@game, caller);
//             assert(
//                 game.match_status == MatchStatus::Ongoing || game.match_status ==
//                 MatchStatus::Paused, SnooknetError::MatchNotInProgressOrPaused.into()
//             );
//             assert(
//                 winner == game.player1 || winner == game.player2,
//                 SnooknetError::InvalidWinner.into()
//             );

//             game.match_status = MatchStatus::Ended;
//             game.state = GameState::Finished;
//             game.winner = winner;
//             game.updated_at = timestamp;

//             // Update player stats
//             let winner_xp = 100_u256;
//             let loser_xp = 50_u256;
//             let winner_elo = 25_u256;
//             let loser_elo = 25_u256;

//             let mut winner_data: Player = world.read_model(winner);
//             winner_data.games_won += 1;
//             winner_data.xp += winner_xp;
//             winner_data.elo_rating += winner_elo;

//             let loser = if winner == game.player1 { game.player2 } else { game.player1 };
//             let mut loser_data: Player = world.read_model(loser);
//             loser_data.games_lost += 1;
//             loser_data.xp += loser_xp;
//             loser_data.elo_rating = if loser_data.elo_rating > loser_elo {
//                 loser_data.elo_rating - loser_elo
//             } else {
//                 0
//             };

//             // Check achievements based on game score
//             let game_score: GameScore = world.read_model(game_id);
//             let break_score = if winner == game.player1 { game_score.player1_score } else {
//             game_score.player2_score };
//             self.check_achievements(winner, game_id, break_score);

//             // Update tournament stats
//             if game.tournament_id != 0 {
//                 let tournament: Tournament = world.read_model(game.tournament_id);
//                 assert(tournament.status == TournamentStatus::Active,
//                 SnooknetError::TournamentNotInProgress.into());
//                 let mut tournament_contract = self.world_default();
//                 tournament_contract.execute_selector(
//                     @TournamentContract::update_match_stats,
//                     array![game.tournament_id, winner, 1, winner_xp, winner_elo].span()
//                 );
//                 tournament_contract.execute_selector(
//                     @TournamentContract::update_match_stats,
//                     array![game.tournament_id, loser, 0, loser_xp, loser_elo].span()
//                 );
//             }

//             world.write_model(@game);
//             world.write_model(@winner_data);
//             world.write_model(@loser_data);

//             world.emit_event(@MatchEnded { game_id, winner, timestamp });
//         }

//         fn retrieve_game(ref self: ContractState, game_id: u256) -> Game {
//             let world = self.world_default();
//             world.read_model(game_id)
//         }

//         fn join_tournament(ref self: ContractState, tournament_id: u256) {
//             let mut world = self.world_default();
//             let caller = get_caller_address();

//             assert(self.validate_player(caller), SnooknetError::PlayerNotRegistered.into());
//             let tournament: Tournament = world.read_model(tournament_id);
//             assert(tournament.status == TournamentStatus::Pending,
//             SnooknetError::TournamentNotOpen.into());
//             assert(tournament.current_players < tournament.max_players,
//             SnooknetError::TournamentIsFull.into());

//             let mut tournament_contract = self.world_default();
//             tournament_contract.execute_selector(
//                 @TournamentContract::register_player,
//                 array![tournament_id].span()
//             );
//         }}
//     }

// //         fn pot_ball(ref self: ContractState, game_id: u256, ball_type: felt252, is_cue_foul:
// bool) {
// //             let mut world = self.world_default();
// //             let mut game: Game = world.read_model(game_id);
// //             let mut score: GameScore = world.read_model(game_id);
// //             let caller = get_caller_address();
// //             let timestamp = get_block_timestamp();

// //             self.validate_match_participant(@game, caller);
// //             assert(caller == game.current_turn, SnooknetError::NotYourTurn.into());
// //             assert(game.match_status == MatchStatus::Ongoing,
// SnooknetError::MatchNotInProgress.into());

// //             let mut points = 0_u32;
// //             let mut ball_state: BallState = world.read_model((game_id, ball_type));

// //             if is_cue_foul {
// //                 game.cue_ball_fouled = true;
// //                 score.last_foul = timestamp;
// //                 let opponent = if caller == game.player1 { game.player2 } else { game.player1
// };
// //                 if opponent == game.player1 {
// //                     score.player1_score += 4; // Minimum foul penalty
// //                 } else {
// //                     score.player2_score += 4;
// //                 }
// //             } else {
// //                 assert(!ball_state.is_potted, SnooknetError::BallAlreadyPotted.into());
// //                 if ball_type == "red" && game.red_balls_remaining > 0 {
// //                     game.red_balls_remaining -= 1;
// //                     points = 1;
// //                 } else if game.red_balls_remaining == 0 {
// //                     points = match ball_type {
// //                         "yellow" => 2,
// //                         "green" => 3,
// //                         "brown" => 4,
// //                         "blue" => 5,
// //                         "pink" => 6,
// //                         "black" => 7,
// //                         _ => { assert(false, SnooknetError::InvalidBallType.into()); 0 }
// //                     };
// //                 } else {
// //                     assert(false, SnooknetError::InvalidBallType.into());
// //                 }
// //                 ball_state.is_potted = true;
// //                 ball_state.last_updated = timestamp;
// //             }

// //             if points > 0 {
// //                 if caller == game.player1 {
// //                     score.player1_score += points;
// //                 } else {
// //                     score.player2_score += points;
// //                 }
// //             }

// //             // Check if all balls are potted
// //             let all_potted = game.red_balls_remaining == 0 &&
// //                 world.read_model::<BallState>((game_id, "yellow")).is_potted &&
// //                 world.read_model::<BallState>((game_id, "green")).is_potted &&
// //                 world.read_model::<BallState>((game_id, "brown")).is_potted &&
// //                 world.read_model::<BallState>((game_id, "blue")).is_potted &&
// //                 world.read_model::<BallState>((game_id, "pink")).is_potted &&
// //                 world.read_model::<BallState>((game_id, "black")).is_potted;

// //             if all_potted {
// //                 game.match_status = MatchStatus::Ended;
// //                 game.state = GameState::Finished;
// //                 game.winner = if score.player1_score > score.player2_score {
// //                     game.player1
// //                 } else {
// //                     game.player2
// //                 };
// //                 self.check_achievements(game.winner, game_id, if game.winner == game.player1 {
// //                     score.player1_score
// //                 } else {
// //                     score.player2_score
// //                 });
// //             } else if points == 0 || is_cue_foul {
// //                 game.current_turn = if caller == game.player1 { game.player2 } else {
// game.player1 };
// //             }

// //             world.write_model(@game);
// //             world.write_model(@score);
// //             if !is_cue_foul {
// //                 world.write_model(@ball_state);
// //                 world.emit_event(@BallPotted { game_id, player: caller, ball_type, points,
// timestamp });
// //             }
// //         }
// //     }
// // }
