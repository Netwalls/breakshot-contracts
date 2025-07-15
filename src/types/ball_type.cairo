#[derive(Copy, Drop, Serde, Debug, PartialEq)]
pub enum SnookerBall {
    Red,
    Yellow,
    Green,
    Brown,
    Blue,
    Pink,
    Black,
    Undefined,
}

impl IntoSnookerBallFelt252 of Into<SnookerBall, felt252> {
    fn into(self: SnookerBall) -> felt252 {
        match self {
            SnookerBall::Red => 'Red',
            SnookerBall::Yellow => 'Yellow',
            SnookerBall::Green => 'Green',
            SnookerBall::Brown => 'Brown',
            SnookerBall::Blue => 'Blue',
            SnookerBall::Pink => 'Pink',
            SnookerBall::Black => 'Black',
            SnookerBall::Undefined => 'Undefined',
        }
    }
}

impl IntoSnookerBallU8 of Into<SnookerBall, u8> {
    fn into(self: SnookerBall) -> u8 {
        match self {
            SnookerBall::Red => 0,
            SnookerBall::Yellow => 1,
            SnookerBall::Green => 2,
            SnookerBall::Brown => 3,
            SnookerBall::Blue => 4,
            SnookerBall::Pink => 5,
            SnookerBall::Black => 6,
            SnookerBall::Undefined => 7,
        }
    }
}

impl IntoU8SnookerBall of Into<u8, SnookerBall> {
    fn into(self: u8) -> SnookerBall {
        match self {
            0 => SnookerBall::Red,
            1 => SnookerBall::Yellow,
            2 => SnookerBall::Green,
            3 => SnookerBall::Brown,
            4 => SnookerBall::Blue,
            5 => SnookerBall::Pink,
            6 => SnookerBall::Black,
            7 => SnookerBall::Undefined,
            _ => SnookerBall::Undefined,
        }
    }
}