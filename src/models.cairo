use starknet::{ContractAddress};

// ===== Ball Models =====

#[derive(Copy, Drop, Serde, Debug, PartialEq)]
pub enum BallColor {
    Red,
    Yellow,
    Green,
    Brown,
    Blue,
    Pink,
    Black,
    White, // Cue ball
}

impl BallColorValue of Into<BallColor, u8> {
    fn into(self: BallColor) -> u8 {
        match self {
            BallColor::Red => 1,
            BallColor::Yellow => 2,
            BallColor::Green => 3,
            BallColor::Brown => 4,
            BallColor::Blue => 5,
            BallColor::Pink => 6,
            BallColor::Black => 7,
            BallColor::White => 0,
        }
    }
}

impl BallColorPoints of Into<BallColor, u8> {
    fn into(self: BallColor) -> u8 {
        match self {
            BallColor::Red => 1,
            BallColor::Yellow => 2,
            BallColor::Green => 3,
            BallColor::Brown => 4,
            BallColor::Blue => 5,
            BallColor::Pink => 6,
            BallColor::Black => 7,
            BallColor::White => 0,
        }
    }
}

#[derive(Copy, Drop, Serde, Debug)]
#[dojo::model]
pub struct Ball {
    #[key]
    pub game_id: u32,
    #[key]
    pub id: u8,
    pub color: BallColor,
    pub position: Vec2,
    pub in_play: bool,
}

// ===== Player Models =====

#[derive(Copy, Drop, Serde, Debug)]
#[dojo::model]
pub struct Player {
    #[key]
    pub game_id: u32,
    #[key]
    pub address: ContractAddress,
    pub score: u32,
    pub fouls: u8,
    pub is_turn: bool,
}

// ===== Game State Models =====

#[derive(Copy, Drop, Serde, Debug)]
pub enum GameState {
    NotStarted,
    InProgress,
    Finished,
}

impl GameStateIntoFelt252 of Into<GameState, felt252> {
    fn into(self: GameState) -> felt252 {
        match self {
            GameState::NotStarted => 0,
            GameState::InProgress => 1,
            GameState::Finished => 2,
        }
    }
}

#[derive(Copy, Drop, Serde, Debug)]
#[dojo::model]
pub struct Game {
    #[key]
    pub id: u32,
    pub player1: ContractAddress,
    pub player2: ContractAddress,
    pub current_turn: ContractAddress,
    pub red_balls_remaining: u8,
    pub state: GameState,
    pub winner: Option<ContractAddress>,
    pub created_at: u64,
    pub updated_at: u64,
}

// ===== Shot Models =====

#[derive(Copy, Drop, Serde, Debug)]
#[dojo::model]
pub struct CuePosition {
    #[key]
    pub game_id: u32,
    #[key]
    pub player: ContractAddress,
    pub position: Vec2,
    pub direction: Vec2,
    pub power: u8,
}

#[derive(Copy, Drop, Serde, Debug)]
#[dojo::model]
pub struct Shot {
    #[key]
    pub game_id: u32,
    #[key]
    pub shot_number: u32,
    pub player: ContractAddress,
    pub cue_position: Vec2,
    pub direction: Vec2,
    pub power: u8,
    pub points_scored: u8,
    pub foul: bool,
    pub foul_points: u8,
    pub timestamp: u64,
}

// ===== Movement and Direction Models =====

#[derive(Serde, Copy, Drop, Debug, PartialEq)]
pub enum Direction {
    Left,
    Right,
    Up,
    Down,
}

impl DirectionIntoFelt252 of Into<Direction, felt252> {
    fn into(self: Direction) -> felt252 {
        match self {
            Direction::Left => 1,
            Direction::Right => 2,
            Direction::Up => 3,
            Direction::Down => 4,
        }
    }
}

impl OptionDirectionIntoFelt252 of Into<Option<Direction>, felt252> {
    fn into(self: Option<Direction>) -> felt252 {
        match self {
            Option::None => 0,
            Option::Some(d) => d.into(),
        }
    }
}

#[derive(Copy, Drop, Serde, IntrospectPacked, Debug)]
pub struct Vec2 {
    pub x: u32,
    pub y: u32,
}

#[generate_trait]
impl Vec2Impl of Vec2Trait {
    fn is_zero(self: Vec2) -> bool {
        self.x == 0 && self.y == 0
    }

    fn is_equal(self: Vec2, b: Vec2) -> bool {
        self.x == b.x && self.y == b.y
    }
    
    fn distance(self: Vec2, other: Vec2) -> u32 {
        // Simple manhattan distance calculation
        let x_diff = if self.x > other.x { self.x - other.x } else { other.x - self.x };
        let y_diff = if self.y > other.y { self.y - other.y } else { other.y - self.y };
        x_diff + y_diff
    }
}

// ===== Table Configuration =====

#[derive(Copy, Drop, Serde, Debug)]
#[dojo::model]
pub struct TableConfig {
    #[key]
    pub game_id: u32,
    pub width: u32,  // Standard snooker table dimensions
    pub height: u32, // (scaled to appropriate units)
    pub pocket_positions: Array<Vec2>, // Positions of the 6 pockets
}

// ===== Tests =====

#[cfg(test)]
mod tests {
    use super::{Vec2, Vec2Trait, BallColor};

    #[test]
    fn test_vec_is_zero() {
        assert(Vec2Trait::is_zero(Vec2 { x: 0, y: 0 }), 'not zero');
        assert(!Vec2Trait::is_zero(Vec2 { x: 1, y: 0 }), 'should not be zero');
    }

    #[test]
    fn test_vec_is_equal() {
        let position = Vec2 { x: 420, y: 0 };
        assert(position.is_equal(Vec2 { x: 420, y: 0 }), 'not equal');
        assert(!position.is_equal(Vec2 { x: 421, y: 0 }), 'should not be equal');
    }
    
    #[test]
    fn test_ball_colors() {
        assert(BallColor::Red.into() == 1_u8, 'wrong red value');
        assert(BallColor::Black.into() == 7_u8, 'wrong black value');
    }
}