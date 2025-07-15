use dojo_starter::model::game_model::{Game};
use dojo_starter::model::new_tourn_models::TournamentReward;

use starknet::{ContractAddress};

// define the interface
#[starknet::interface]
pub trait ISnooknet<T> {
    // fn register(ref self: T, username: felt252, is_anonymous: bool);
    fn create_player(ref self: T);
    fn create_match(ref self: T, opponent: ContractAddress, stake_amount: u256) -> u256;
    fn create_new_game_id(ref self: T) -> u256;
    fn end_match(ref self: T, game_id: u256, winner: ContractAddress);
    fn retrieve_game(ref self: T, game_id: u256) -> Game;

    
    fn join_tournament(ref self: T, tournament_id: u256);
    fn start_match(ref self: T, game_id: u256) -> bool;

    // Pause an ongoing match, updating its status
    fn pause_match(ref self: T, game_id: u256) -> bool;
            // fn pot_ball(ref self: T, game_id: u256, ball_type: felt252, is_cue_foul: bool);
    // End a match, setting the winner and finalizing the game
// fn mint_nft(ref self: T, asset_type: AssetType, rarity: Rarity) -> u256;
// fn lease_nft(ref self: T, asset_id: u256, leasee: ContractAddress);
// fn submit_proposal(ref self: T, proposal_id: u256);
// fn vote_proposal(ref self: T, proposal_id: u256, vote_for: bool);
}
