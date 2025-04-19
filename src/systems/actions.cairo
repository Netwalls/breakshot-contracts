use dojo_starter::models::{Direction, Position};

// define the interface
#[starknet::interface]
pub trait IActions<T> {
    fn register(ref self: T, username: felt252, is_anonymous: bool);
    fn create_match(ref self: T, opponent: ContractAddress, stake_amount: u256) -> u256;
    fn end_match(ref self: T, match_id: u256, winner: ContractAddress);
    fn mint_nft(ref self: T, asset_type: AssetType, rarity: Rarity) -> u256;
    fn lease_nft(ref self: T, asset_id: u256, leasee: ContractAddress);
    fn submit_proposal(ref self: T, proposal_id: u256);
    fn vote_proposal(ref self: T, proposal_id: u256, vote_for: bool);
}

// dojo decorator
#[dojo::contract]
pub mod actions {
    use dojo::event::EventStorage;
    use dojo::model::ModelStorage;
    use dojo_starter::models::{Moves, Vec2};
    use starknet::{ContractAddress, get_caller_address};
    use super::{Direction, IActions, Position, next_position};
}
