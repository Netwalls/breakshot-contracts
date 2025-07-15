use starknet::ContractAddress;

#[derive(Copy, Drop, Serde, Debug)]
#[dojo::model]
pub struct Player {
    #[key]
    pub contract_address: ContractAddress,
    pub leaderboard_position: u64,
    pub xp: u256,
    pub elo_rating: u256,
    pub games_won: u64,
    pub games_lost: u64,
    pub nft_coins_available: u256,
    pub level: u32,
    pub tournaments_won: u64, // New field
}

pub trait PlayerTrait {
    fn new(
        contract_address: ContractAddress,
        leaderboard_position: u64,
        xp: u256,
        elo_rating: u256,
        games_won: u64,
        games_lost: u64,
        nft_coins_available: u256,
        level: u32,
        tournaments_won: u64, // Added parameter
    ) -> Player;
}

impl PlayerImpl of PlayerTrait {
    fn new(
        contract_address: ContractAddress,
        leaderboard_position: u64,
        xp: u256,
        elo_rating: u256,
        games_won: u64,
        games_lost: u64,
        nft_coins_available: u256,
        level: u32,
        tournaments_won: u64, // Added parameter
    ) -> Player {
        Player {
            contract_address,
            leaderboard_position,
            xp,
            elo_rating,
            games_won,
            games_lost,
            nft_coins_available,
            level,
            tournaments_won, // Initialize new field
        }
    }
}

#[cfg(test)]
mod tests {
    use super::{PlayerImpl};
    use starknet::contract_address::contract_address_const;

    #[test]
    #[available_gas(999999)]
    fn test_player_creation() {
        let contract_address = contract_address_const::<'player_1'>();
        let leaderboard_position = 1_u64;
        let xp = 100_u256;
        let elo_rating = 1500_u256;
        let games_won = 5_u64;
        let games_lost = 2_u64;
        let nft_coins_available = 10_u256;
        let level = 1_u32;
        let tournaments_won = 1_u64; // Added

        let player = PlayerImpl::new(
            contract_address,
            leaderboard_position,
            xp,
            elo_rating,
            games_won,
            games_lost,
            nft_coins_available,
            level,
            tournaments_won,
        );

        assert(player.contract_address == contract_address, 'Contract address mismatch');
        assert(player.leaderboard_position == leaderboard_position, 'Leaderboard position mismatch');
        assert(player.xp == xp, 'XP mismatch');
        assert(player.elo_rating == elo_rating, 'Elo rating mismatch');
        assert(player.games_won == games_won, 'Games won mismatch');
        assert(player.games_lost == games_lost, 'Games lost mismatch');
        assert(player.nft_coins_available == nft_coins_available, 'NFT coins mismatch');
        assert(player.level == level, 'Level mismatch');
        assert(player.tournaments_won == tournaments_won, 'Tournaments won mismatch'); // Added
    }

    #[test]
    #[available_gas(999999)]
    fn test_player_with_zero_values() {
        let contract_address = contract_address_const::<'player_1'>();
        let player = PlayerImpl::new(
            contract_address, 0_u64, 0_u256, 0_u256, 0_u64, 0_u64, 0_u256, 0_u32, 0_u64,
        );

        assert(player.contract_address == contract_address, 'Contract address mismatch');
        assert(player.leaderboard_position == 0_u64, 'Incorrect leaderboard position');
        assert(player.xp == 0_u256, 'XP should be 0');
        assert(player.elo_rating == 0_u256, 'Elo rating should be 0');
        assert(player.games_won == 0_u64, 'Games won should be 0');
        assert(player.games_lost == 0_u64, 'Games lost should be 0');
        assert(player.nft_coins_available == 0_u256, 'NFT coins should be 0');
        assert(player.level == 0_u32, 'Level should be 0');
        assert(player.tournaments_won == 0_u64, 'Tournaments won should be 0'); // Added
    }

    #[test]
    #[available_gas(999999)]
    fn test_player_with_max_values() {
        let contract_address = contract_address_const::<'player_1'>();
        let max_u64 = 18446744073709551615_u64;
        let max_u256 = 340282366920938463463374607431768211455_u256;
        let max_u32 = 4294967295_u32;

        let player = PlayerImpl::new(
            contract_address, max_u64, max_u256, max_u256, max_u64, max_u64, max_u256, max_u32, max_u64,
        );

        assert(player.contract_address == contract_address, 'Contract address mismatch');
        assert(player.leaderboard_position == max_u64, 'Incorrect leaderboard position');
        assert(player.xp == max_u256, 'XP should be max');
        assert(player.elo_rating == max_u256, 'Elo rating should be max');
        assert(player.games_won == max_u64, 'Games won should be max');
        assert(player.games_lost == max_u64, 'Games lost should be max');
        assert(player.nft_coins_available == max_u256, 'NFT coins should be max');
        assert(player.level == max_u32, 'Level should be max');
        assert(player.tournaments_won == max_u64, 'Tournaments won should be max'); // Added
    }
}