use dojo_starter::model::game_model::{Game};


use starknet::{ContractAddress};

// define the interface
#[starknet::interface]
pub trait ISnooknet<T> {
    // fn register(ref self: T, username: felt252, is_anonymous: bool);
    fn create_match(ref self: T, opponent: ContractAddress, stake_amount: u256) -> u256;
    fn create_new_game_id(ref self: T) -> u256;
    fn end_match(ref self: T, game_id: u256, winner: ContractAddress);
    fn retrieve_game(ref self: T, game_id: u256) -> Game;
    // fn mint_nft(ref self: T, asset_type: AssetType, rarity: Rarity) -> u256;
// fn lease_nft(ref self: T, asset_id: u256, leasee: ContractAddress);
// fn submit_proposal(ref self: T, proposal_id: u256);
// fn vote_proposal(ref self: T, proposal_id: u256, vote_for: bool);
}
