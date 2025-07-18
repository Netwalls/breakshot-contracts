#[derive(Copy, Drop, Serde, Debug, Introspect, PartialEq)]
pub enum SnookerGameStatus {
    Pending,
    InProgress,
    Completed,
    Cancelled,
}

pub impl IntoSnookerGameStatusFelt252 of Into<SnookerGameStatus, felt252> {
    #[inline(always)]
    fn into(self: SnookerGameStatus) -> felt252 {
        match self {
            SnookerGameStatus::Pending => 0,
            SnookerGameStatus::InProgress => 1,
            SnookerGameStatus::Completed => 2,
            SnookerGameStatus::Cancelled => 3,
        }
    }
}

pub impl IntoSnookerGameStatusU8 of Into<SnookerGameStatus, u8> {
    #[inline(always)]
    fn into(self: SnookerGameStatus) -> u8 {
        match self {
            SnookerGameStatus::Pending => 0,
            SnookerGameStatus::InProgress => 1,
            SnookerGameStatus::Completed => 2,
            SnookerGameStatus::Cancelled => 3,
        }
    }
}

pub impl IntoU8SnookerGameStatus of Into<u8, SnookerGameStatus> {
    #[inline(always)]
    fn into(self: u8) -> SnookerGameStatus {
        let game_status: u8 = self.into();
        match game_status {
            0 => SnookerGameStatus::Pending,
            1 => SnookerGameStatus::InProgress,
            2 => SnookerGameStatus::Completed,
            3 => SnookerGameStatus::Cancelled,
            _ => SnookerGameStatus::Cancelled,
        }
    }
}

pub impl SnookerGameStatusDisplay of core::fmt::Display<SnookerGameStatus> {
    fn fmt(self: @SnookerGameStatus, ref f: core::fmt::Formatter) -> Result<(), core::fmt::Error> {
        let s = match self {
            SnookerGameStatus::Pending => "Pending",
            SnookerGameStatus::InProgress => "In Progress",
            SnookerGameStatus::Completed => "Completed",
            SnookerGameStatus::Cancelled => "Cancelled",
        };
        f.buffer.append(@s);
        Result::Ok(())
    }
}

#[derive(Copy, Drop, Serde, Debug, Introspect, PartialEq)]
pub enum SnookerPlayerStatus {
    Ready,
    Playing,
    Disqualified,
    Inactive,
}

pub impl IntoSnookerPlayerStatusFelt252 of Into<SnookerPlayerStatus, felt252> {
    #[inline(always)]
    fn into(self: SnookerPlayerStatus) -> felt252 {
        match self {
            SnookerPlayerStatus::Ready => 0,
            SnookerPlayerStatus::Playing => 1,
            SnookerPlayerStatus::Disqualified => 2,
            SnookerPlayerStatus::Inactive => 3,
        }
    }
}

pub impl IntoSnookerPlayerStatusU8 of Into<SnookerPlayerStatus, u8> {
    #[inline(always)]
    fn into(self: SnookerPlayerStatus) -> u8 {
        match self {
            SnookerPlayerStatus::Ready => 0,
            SnookerPlayerStatus::Playing => 1,
            SnookerPlayerStatus::Disqualified => 2,
            SnookerPlayerStatus::Inactive => 3,
        }
    }
}

pub impl IntoU8SnookerPlayerStatus of Into<u8, SnookerPlayerStatus> {
    #[inline(always)]
    fn into(self: u8) -> SnookerPlayerStatus {
        let player_status: u8 = self.into();
        match player_status {
            0 => SnookerPlayerStatus::Ready,
            1 => SnookerPlayerStatus::Playing,
            2 => SnookerPlayerStatus::Disqualified,
            3 => SnookerPlayerStatus::Inactive,
            _ => SnookerPlayerStatus::Inactive,
        }
    }
}

pub impl SnookerPlayerStatusDisplay of core::fmt::Display<SnookerPlayerStatus> {
    fn fmt(
        self: @SnookerPlayerStatus, ref f: core::fmt::Formatter,
    ) -> Result<(), core::fmt::Error> {
        let s = match self {
            SnookerPlayerStatus::Ready => "Ready",
            SnookerPlayerStatus::Playing => "Playing",
            SnookerPlayerStatus::Disqualified => "Disqualified",
            SnookerPlayerStatus::Inactive => "Inactive",
        };
        f.buffer.append(@s);
        Result::Ok(())
    }
}

#[cfg(test)]
mod tests {
    use super::{SnookerGameStatus, SnookerPlayerStatus};

    #[test]
    fn test_into_game_status_pending() {
        let game_status = SnookerGameStatus::Pending;
        let game_status_felt252: felt252 = game_status.into();
        assert_eq!(game_status_felt252, 0);
    }

    #[test]
    fn test_into_game_status_in_progress() {
        let game_status = SnookerGameStatus::InProgress;
        let game_status_felt252: felt252 = game_status.into();
        assert_eq!(game_status_felt252, 1);
    }

    #[test]
    fn test_into_game_status_completed() {
        let game_status = SnookerGameStatus::Completed;
        let game_status_felt252: felt252 = game_status.into();
        assert_eq!(game_status_felt252, 2);
    }

    #[test]
    fn test_into_game_status_cancelled() {
        let game_status = SnookerGameStatus::Cancelled;
        let game_status_felt252: felt252 = game_status.into();
        assert_eq!(game_status_felt252, 3);
    }

    #[test]
    fn test_into_game_status_u8_pending() {
        let game_status = SnookerGameStatus::Pending;
        let game_status_u8: u8 = game_status.into();
        assert_eq!(game_status_u8, 0);
    }

    #[test]
    fn test_into_game_status_u8_in_progress() {
        let game_status = SnookerGameStatus::InProgress;
        let game_status_u8: u8 = game_status.into();
        assert_eq!(game_status_u8, 1);
    }

    #[test]
    fn test_into_game_status_u8_completed() {
        let game_status = SnookerGameStatus::Completed;
        let game_status_u8: u8 = game_status.into();
        assert_eq!(game_status_u8, 2);
    }

    #[test]
    fn test_into_game_status_u8_cancelled() {
        let game_status = SnookerGameStatus::Cancelled;
        let game_status_u8: u8 = game_status.into();
        assert_eq!(game_status_u8, 3);
    }

    #[test]
    fn test_into_game_status_from_u8_pending() {
        let game_status_u8: u8 = 0;
        let game_status: SnookerGameStatus = game_status_u8.into();
        assert_eq!(game_status, SnookerGameStatus::Pending);
    }

    #[test]
    fn test_into_game_status_from_u8_in_progress() {
        let game_status_u8: u8 = 1;
        let game_status: SnookerGameStatus = game_status_u8.into();
        assert_eq!(game_status, SnookerGameStatus::InProgress);
    }

    #[test]
    fn test_into_game_status_from_u8_completed() {
        let game_status_u8: u8 = 2;
        let game_status: SnookerGameStatus = game_status_u8.into();
        assert_eq!(game_status, SnookerGameStatus::Completed);
    }

    #[test]
    fn test_into_game_status_from_u8_cancelled() {
        let game_status_u8: u8 = 3;
        let game_status: SnookerGameStatus = game_status_u8.into();
        assert_eq!(game_status, SnookerGameStatus::Cancelled);
    }

    #[test]
    fn test_into_game_status_from_u8_invalid() {
        let game_status_u8: u8 = 4;
        let game_status: SnookerGameStatus = game_status_u8.into();
        assert_eq!(game_status, SnookerGameStatus::Cancelled);
    }

    #[test]
    fn test_into_game_status_from_u8_255_edge_case() {
        let game_status_u8: u8 = 255;
        let game_status: SnookerGameStatus = game_status_u8.into();
        assert_eq!(game_status, SnookerGameStatus::Cancelled);
    }

    #[test]
    fn test_into_player_status_ready() {
        let player_status = SnookerPlayerStatus::Ready;
        let player_status_felt252: felt252 = player_status.into();
        assert_eq!(player_status_felt252, 0);
    }

    #[test]
    fn test_into_player_status_playing() {
        let player_status = SnookerPlayerStatus::Playing;
        let player_status_felt252: felt252 = player_status.into();
        assert_eq!(player_status_felt252, 1);
    }

    #[test]
    fn test_into_player_status_disqualified() {
        let player_status = SnookerPlayerStatus::Disqualified;
        let player_status_felt252: felt252 = player_status.into();
        assert_eq!(player_status_felt252, 2);
    }

    #[test]
    fn test_into_player_status_inactive() {
        let player_status = SnookerPlayerStatus::Inactive;
        let player_status_felt252: felt252 = player_status.into();
        assert_eq!(player_status_felt252, 3);
    }

    #[test]
    fn test_into_player_status_u8_ready() {
        let player_status = SnookerPlayerStatus::Ready;
        let player_status_u8: u8 = player_status.into();
        assert_eq!(player_status_u8, 0);
    }

    #[test]
    fn test_into_player_status_u8_playing() {
        let player_status = SnookerPlayerStatus::Playing;
        let player_status_u8: u8 = player_status.into();
        assert_eq!(player_status_u8, 1);
    }

    #[test]
    fn test_into_player_status_u8_disqualified() {
        let player_status = SnookerPlayerStatus::Disqualified;
        let player_status_u8: u8 = player_status.into();
        assert_eq!(player_status_u8, 2);
    }

    #[test]
    fn test_into_player_status_u8_inactive() {
        let player_status = SnookerPlayerStatus::Inactive;
        let player_status_u8: u8 = player_status.into();
        assert_eq!(player_status_u8, 3);
    }

    #[test]
    fn test_into_player_status_from_u8_ready() {
        let player_status_u8: u8 = 0;
        let player_status: SnookerPlayerStatus = player_status_u8.into();
        assert_eq!(player_status, SnookerPlayerStatus::Ready);
    }

    #[test]
    fn test_into_player_status_from_u8_playing() {
        let player_status_u8: u8 = 1;
        let player_status: SnookerPlayerStatus = player_status_u8.into();
        assert_eq!(player_status, SnookerPlayerStatus::Playing);
    }

    #[test]
    fn test_into_player_status_from_u8_disqualified() {
        let player_status_u8: u8 = 2;
        let player_status: SnookerPlayerStatus = player_status_u8.into();
        assert_eq!(player_status, SnookerPlayerStatus::Disqualified);
    }

    #[test]
    fn test_into_player_status_from_u8_inactive() {
        let player_status_u8: u8 = 3;
        let player_status: SnookerPlayerStatus = player_status_u8.into();
        assert_eq!(player_status, SnookerPlayerStatus::Inactive);
    }

    #[test]
    fn test_into_player_status_from_u8_invalid() {
        let player_status_u8: u8 = 4;
        let player_status: SnookerPlayerStatus = player_status_u8.into();
        assert_eq!(player_status, SnookerPlayerStatus::Inactive);
    }

    #[test]
    fn test_into_player_status_from_u8_255_edge_case() {
        let player_status_u8: u8 = 255;
        let player_status: SnookerPlayerStatus = player_status_u8.into();
        assert_eq!(player_status, SnookerPlayerStatus::Inactive);
    }
}
