use dojo_starter::model::game_model::{Game};
use dojo_starter::model::new_tourn_models::TournamentReward;

use starknet::{ContractAddress};

#[starknet::interface]
pub trait ITournaments<T> {
    fn create_tournament(
        ref self: T,
        name: felt252,
        max_players: u8,
        start_date: u64,
        end_date: u64,
        rewards: Array<TournamentReward>
    ) -> u256;
    fn register_player(ref self: T, tournament_id: u256);
    fn start_tournament(ref self: T, tournament_id: u256, end_date: u64);
    fn end_tournament(ref self: T, tournament_id: u256);
    fn cancel_tournament(ref self: T, tournament_id: u256);
    fn is_player_registered(self: @T, tournament_id: u256, player: ContractAddress) -> bool;
        fn update_player_stats(
        ref self: T,
        tournament_id: u256,
        player: ContractAddress,
        xp_delta: u256,
        elo_delta: u256,
        won: bool,
        lost: bool,
        nft_coins_delta: u256,
        level_delta: u32,
        tournament_won: bool
    );
    fn update_match_stats(
        ref self: T,
        tournament_id: u256,
        player: ContractAddress,
        won: bool,
        xp_delta: u256,
        elo_delta: u256
    );
}