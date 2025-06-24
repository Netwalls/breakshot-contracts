// src/errors/error.cairo
#[derive(Copy, Drop, Serde)]
pub enum SnooknetError {
    // Player-related errors
    NotAPlayer,
    // Game-related errors
    PlayersCannotBeSame,
    StakeMustBePositive,
    GameAlreadyStarted,
    GameNotInProgress,
    GameNotOngoing,
    InvalidWinner,
    // Tournament-related errors
    MaxPlayersLessThanTwo,
    InvalidStartDate,
    TournamentNotOpen,
    TournamentIsFull,
    TournamentNotInProgress,
    InvalidBallType,
}

impl SnooknetErrorIntoFelt252 of Into<SnooknetError, felt252> {
    fn into(self: SnooknetError) -> felt252 {
        match self {
            SnooknetError::NotAPlayer => 'Not a player',
            SnooknetError::PlayersCannotBeSame => 'Players cannot be the same',
            SnooknetError::StakeMustBePositive => 'Stake must be positive',
            SnooknetError::GameAlreadyStarted => 'Game already started',
            SnooknetError::GameNotInProgress => 'Game not in progress',
            SnooknetError::GameNotOngoing => 'Game not ongoing',
            SnooknetError::InvalidWinner => 'Invalid winner',
            SnooknetError::MaxPlayersLessThanTwo => 'Max players less than 2',
            SnooknetError::InvalidStartDate => 'Invalid start date',
            SnooknetError::TournamentNotOpen => 'Tournament not open',
            SnooknetError::TournamentIsFull => 'Tournament is full',
            SnooknetError::TournamentNotInProgress => 'Tournament is not in progress',
            SnooknetError::InvalidBallType => 'Invalid ball type',
        }
    }
}
