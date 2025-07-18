use starknet::{ContractAddress, get_caller_address, get_block_timestamp, contract_address_const};
use dojo_starter::types::tournament_types::SnookerTournament;

#[derive(Serde, Copy, Drop, Introspect)]
#[dojo::model]
pub struct TournamentCounter {
    #[key]
    pub id: felt252,
    pub current_val: u256,
}

#[derive(Copy, Drop, Serde, Debug, Introspect, PartialEq)]
pub enum TournamentStatus {
    Pending,
    Active,
    Ended,
}

#[derive(Drop, Serde, Debug, Introspect)]
pub struct TournamentReward {
    pub position: u8,
    pub amount: u256,
    pub token_type: felt252,
}

#[derive(Drop, Serde, Debug)]
#[dojo::model]
pub struct Tournament {
    #[key]
    pub id: u256,
    pub name: felt252,
    pub organizer: ContractAddress,
    pub tournament_type: SnookerTournament,
    pub max_players: u8,
    pub current_players: u8,
    pub start_date: u64,
    pub end_date: u64,
    pub status: TournamentStatus,
    pub rewards: Array<TournamentReward>,
    pub players: Array<ContractAddress>,
}

pub trait TournamentTrait {
    fn new(
        id: u256,
        name: felt252,
        tournament_type: SnookerTournament,
        organizer: ContractAddress,
        max_players: u8,
        start_date: u64,
        end_date: u64,
        rewards: Array<TournamentReward>,
    ) -> Tournament;
}

impl TournamentImpl of TournamentTrait {
    fn new(
        id: u256,
        name: felt252,
        tournament_type: SnookerTournament,
        organizer: ContractAddress,
        max_players: u8,
        start_date: u64,
        end_date: u64,
        rewards: Array<TournamentReward>,
    ) -> Tournament {
        Tournament {
            id,
            name,
            tournament_type,
            organizer,
            max_players,
            current_players: 0,
            start_date,
            end_date,
            status: TournamentStatus::Pending,
            rewards,
            players: ArrayTrait::new(),
        }
    }
}


#[cfg(test)]
mod tests {
    use super::{TournamentImpl, TournamentStatus, TournamentReward, SnookerTournament};
    use starknet::contract_address::contract_address_const;

    #[test]
    #[available_gas(999999)]
    fn test_tournament_creation() {
        let id = 1_u256;
        let name = 'Test Tournament';
        let organizer = contract_address_const::<'organizer'>();
        let tournament_type = SnookerTournament::Ranking;
        let max_players = 8_u8;
        let start_date = 1000_u64;
        let end_date = 2000_u64;

        let mut rewards = ArrayTrait::new();
        rewards.append(TournamentReward { position: 1_u8, amount: 1000_u256, token_type: 'ETH' });
        rewards.append(TournamentReward { position: 2_u8, amount: 500_u256, token_type: 'ETH' });

        let tournament = TournamentImpl::new(
            id, name, tournament_type, organizer, max_players, start_date, end_date, rewards,
        );

        assert(tournament.id == id, 'ID mismatch');
        assert(tournament.name == name, 'Name mismatch');
        assert(tournament.organizer == organizer, 'Organizer mismatch');
        assert(tournament.max_players == max_players, 'Max players mismatch');
        assert(tournament.current_players == 0, 'Current players should be empty');
        assert(tournament.start_date == start_date, 'Start date mismatch');
        assert(tournament.end_date == end_date, 'End date mismatch');
        assert(tournament.status == TournamentStatus::Pending, 'Status should be Pending');
        assert(tournament.rewards.len() == 2, 'Rewards length mismatch');
        assert(tournament.tournament_type == tournament_type, 'Tournament type mismatch');
    }

    #[test]
    #[available_gas(999999)]
    fn test_tournament_with_empty_rewards() {
        let id = 2_u256;
        let name = 'Empty Rewards Tournament';
        let organizer = contract_address_const::<'organizer'>();
        let tournament_type = SnookerTournament::Local;
        let max_players = 4_u8;
        let start_date = 1000_u64;
        let end_date = 2000_u64;
        let rewards = ArrayTrait::new();

        let tournament = TournamentImpl::new(
            id, name, tournament_type, organizer, max_players, start_date, end_date, rewards,
        );

        assert(tournament.id == id, 'ID mismatch');
        assert(tournament.rewards.len() == 0, 'Rewards should be empty');
    }

    #[test]
    #[available_gas(999999)]
    fn test_tournament_with_max_values() {
        let id = 340282366920938463463374607431768211455_u256; // max u256
        let name = 'Max Values Tournament';
        let organizer = contract_address_const::<'organizer'>();
        let tournament_type = SnookerTournament::WorldChampionship;
        let max_players = 255_u8; // max u8
        let start_date = 18446744073709551615_u64; // max u64
        let end_date = 18446744073709551615_u64;
        let rewards = ArrayTrait::new();

        let tournament = TournamentImpl::new(
            id, name, tournament_type, organizer, max_players, start_date, end_date, rewards,
        );

        assert(tournament.id == id, 'ID mismatch');
        assert(tournament.max_players == max_players, 'Max players mismatch');
        assert(tournament.start_date == start_date, 'Start date mismatch');
        assert(tournament.end_date == end_date, 'End date mismatch');
    }
}
