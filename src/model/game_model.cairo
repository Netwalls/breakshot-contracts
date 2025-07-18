use starknet::{ContractAddress, contract_address_const};
use starknet::get_block_timestamp;

// Keeps track of the number of games
#[derive(Serde, Copy, Drop, Introspect, PartialEq)]
#[dojo::model]
pub struct GameCounter {
    #[key]
    pub id: felt252,
    pub current_val: u256,
}

// Game state enum
#[derive(Copy, Drop, Serde, Debug, Introspect, PartialEq)]
pub enum GameState {
    NotStarted,
    InProgress,
    Finished,
}

// Match status enum
#[derive(Serde, Copy, Drop, Introspect, PartialEq, Debug)]
pub enum MatchStatus {
    Pending, // Waiting for players to join
    Ongoing, // Game is active
    Paused,
    Ended // Game has concluded
}

#[derive(Copy, Drop, Serde, Debug)]
#[dojo::model]
pub struct BallState {
    #[key]
    pub game_id: u256,
    #[key]
    pub ball_type: felt252, // e.g., "red", "yellow", "green", "brown", "blue", "pink", "black"
    pub is_potted: bool,
    pub last_updated: u64,
}


#[derive(Serde, Copy, Drop, Introspect, PartialEq)]
#[dojo::model]
pub struct GameIndex {
    #[key]
    pub player: ContractAddress,
    #[key]
    pub game_id: u256,
    pub created_at: u64,
}

#[derive(Serde, Copy, Drop, Introspect, PartialEq)]
#[dojo::model]
pub struct GameScore {
    #[key]
    pub game_id: u256,
    pub player1_score: u32,
    pub player2_score: u32,
    pub last_foul: u64, // Timestamp of last foul
}

// Game model
#[derive(Copy, Drop, Serde, Debug)]
#[dojo::model]
pub struct Game {
    #[key]
    pub id: u256,
    pub tournament_id: u256,
    pub player1: ContractAddress,
    pub player2: ContractAddress,
    pub current_turn: ContractAddress,
    pub red_balls_remaining: u8,
    pub state: GameState,
    pub match_status: MatchStatus, // Added to track game lifecycle
    pub winner: ContractAddress,
    pub created_at: u64,
    pub updated_at: u64,
    pub start_time: u64,
    pub stake_amount: u256,
    pub cue_ball_fouled: bool,
}

pub trait GameTrait {
    // Create and return a new game with default snooker setup
    fn new(
        id: u256,
        tournament_id: u256,
        player1: ContractAddress,
        player2: ContractAddress,
        stake_amount: u256,
    ) -> Game;
}

impl GameImpl of GameTrait {
    fn new(
        id: u256,
        tournament_id: u256,
        player1: ContractAddress,
        player2: ContractAddress,
        stake_amount: u256,
    ) -> Game {
        let zero_address = contract_address_const::<0x0>();
        let current_time = get_block_timestamp();
        Game {
            id,
            tournament_id,
            player1,
            player2,
            current_turn: zero_address.into(), // To be set by game logic
            red_balls_remaining: 15, // Default to 15 red balls in snooker
            state: GameState::NotStarted,
            match_status: MatchStatus::Pending, // Reflects waiting for start
            winner: zero_address.into(),
            created_at: current_time,
            updated_at: current_time,
            start_time: 0,
            stake_amount,
            cue_ball_fouled: false,
        }
    }
}
