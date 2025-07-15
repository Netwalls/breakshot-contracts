// use starknet::{ContractAddress, get_caller_address};
// use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};
// use dojo_starter::model::player_model::{Player, PlayerImpl};

// #[dojo::contract]
// pub mod Players {
//     use super::{Player, PlayerImpl, get_caller_address};

//     #[storage]
//     struct Storage {
//         world: IWorldDispatcher,
//     }

//     #[constructor]
//     fn constructor(ref self: ContractState, world: IWorldDispatcher) {
//         self.world.write(world);
//     }

//     #[external(v0)]
//     fn create_player(ref self: ContractState, leaderboard_position: u64, xp: u256, elo_rating: u256, games_won: u64, games_lost: u64, nft_coins_available: u256, level: u32) {
//         let world = self.world.read();
//         let player_addr = get_caller_address();
//         let player = PlayerImpl::new(player_addr, leaderboard_position, xp, elo_rating, games_won, games_lost, nft_coins_available, level);
//         set!(world, (player));
//     }

//     #[external(v0)]
//     fn delete_player(ref self: ContractState) {
//         let world = self.world.read();
//         let player_addr = get_caller_address();
//         let mut player = get!(world, player_addr, (Player));
//         assert(player.contract_address == player_addr, 'Invalid player');
//         set!(world, (Player { contract_address: player_addr, leaderboard_position: 0, xp: 0, elo_rating: 0, games_won: 0, games_lost: 0, nft_coins_available: 0, level: 0 }));
//     }
// }

// #[cfg(test)]
// mod tests {
//     use super::{Players};
//     use starknet::{contract_address_const, testing::set_caller_address};
//     use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};
//     use dojo::test_utils::{spawn_test_world, deploy_contract};

//     #[test]
//     #[available_gas(2000000)]
//     fn test_create_player() {
//         let world = spawn_test_world(array![get_model_selector::<Player>()].span());
//         let contract_address = deploy_contract(Players::TEST_CLASS_HASH, array![world.contract_address.into()].span());
//         let caller = contract_address_const::<'player_1'>();
//         set_caller_address(caller);

//         let mut players = get_world_contract!(world, contract_address, Players);
//         players.create_player(1_u64, 100_u256, 1500_u256, 5_u64, 2_u64, 10_u256, 1_u32);

//         let player = get!(world, caller, (Player));
//         assert(player.contract_address == caller, 'Contract address mismatch');
//         assert(player.leaderboard_position == 1_u64, 'Leaderboard position mismatch');
//         assert(player.xp == 100_u256, 'XP mismatch');
//         assert(player.elo_rating == 1500_u256, 'Elo rating mismatch');
//         assert(player.games_won == 5_u64, 'Games won mismatch');
//         assert(player.games_lost == 2_u64, 'Games lost mismatch');
//         assert(player.nft_coins_available == 10_u256, 'NFT coins mismatch');
//         assert(player.level == 1_u32, 'Level mismatch');
//     }

//     #[test]
//     #[available_gas(2000000)]
//     fn test_delete_player() {
//         let world = spawn_test_world(array![get_model_selector::<Player>()].span());
//         let contract_address = deploy_contract(Players::TEST_CLASS_HASH, array![world.contract_address.into()].span());
//         let caller = contract_address_const::<'player_1'>();
//         set_caller_address(caller);

//         let mut players = get_world_contract!(world, contract_address, Players);
//         players.create_player(1_u64, 100_u256, 1500_u256, 5_u64, 2_u64, 10_u256, 1_u32);
//         players.delete_player();

//         let player = get!(world, caller, (Player));
//         assert(player.leaderboard_position == 0, 'Leaderboard should be 0');
//         assert(player.xp == 0_u256, 'XP should be 0');
//         assert(player.elo_rating == 0_u256, 'Elo should be 0');
//         assert(player.games_won == 0_u64, 'Games won should be 0');
//         assert(player.games_lost == 0_u64, 'Games lost should be 0');
//         assert(player.nft_coins_available == 0_u256, 'NFT coins should be 0');
//         assert(player.level == 0_u32, 'Level should be 0');
//     }
// }