use dojo_starter::interfaces::ISnooknet::ISnooknet;
use dojo_starter::model::game_model::{Game, GameTrait, GameState, GameCounter};

// dojo decorator
#[dojo::contract]
pub mod Snooknet {
    use super::{ISnooknet, Game, GameTrait, GameCounter, GameState};
    use starknet::{
        ContractAddress, get_caller_address, get_block_timestamp, contract_address_const,
    };
    use dojo::model::{ModelStorage};
    use dojo::event::EventStorage;


    #[derive(Copy, Drop, Serde)]
    #[dojo::event]
    pub struct GameCreated {
        #[key]
        pub game_id: u256,
        pub timestamp: u64,
    }

    #[derive(Copy, Drop, Serde)]
    #[dojo::event]
    pub struct GameEnded {
        #[key]
        pub game_id: u256,
        pub timestamp: u64,
    }

    #[derive(Copy, Drop, Serde)]
    #[dojo::event]
    pub struct Winner {
        #[key]
        pub game_id: u256,
        pub winner: ContractAddress,
    }


    #[abi(embed_v0)]
    impl SnooknetImpl of ISnooknet<ContractState> {
        fn create_new_game_id(ref self: ContractState) -> u256 {
            let mut world = self.world_default();
            let mut game_counter: GameCounter = world.read_model('v0');
            let new_val = game_counter.current_val + 1;
            game_counter.current_val = new_val;
            world.write_model(@game_counter);
            new_val
        }
        fn create_match(
            ref self: ContractState, opponent: ContractAddress, stake_amount: u256,
        ) -> u256 {
            let mut world = self.world_default();
            let game_id = self.create_new_game_id();
            let timestamp = get_block_timestamp();
            let player_1 = get_caller_address();
            let player_2 = opponent;

            // Create a new game
            let mut new_game: Game = GameTrait::new(
                game_id,
                player_1,
                player_2,
                player_1,
                red_balls_remaining: 13,
                state: GameState::NotStarted,
                winner: contract_address_const::<0x0>(),
                created_at: timestamp,
                updated_at: timestamp,
                stake_amount: stake_amount,
            );

            world.write_model(@new_game);

            world.emit_event(@GameCreated { game_id, timestamp });

            game_id
        }

        fn end_match(ref self: ContractState, game_id: u256, winner: ContractAddress) {
            let mut world = self.world_default();
            let mut game: Game = world.read_model(game_id);
            let caller = get_caller_address();

            let timestamp = get_block_timestamp();
            assert((caller == game.player1) || (caller == game.player2), 'Not a Player');
            game.winner = winner;
            game.state = GameState::Finished;
            game.updated_at = get_block_timestamp();

            world.write_model(@game);
            world.emit_event(@Winner { game_id, winner });
            world.emit_event(@GameEnded { game_id, timestamp });
        }
        fn retrieve_game(ref self: ContractState, game_id: u256) -> Game {
            // Get default world
            let mut world = self.world_default();
            //get the game state
            let game: Game = world.read_model(game_id);
            game
        }
    }

    #[generate_trait]
    impl InternalImpl of InternalTrait {
        // Use the default namespace "dojo_starter".
        // This function is handy since the ByteArray can't be const.
        fn world_default(self: @ContractState) -> dojo::world::WorldStorage {
            self.world(@"Snooknet")
        }
    }
}

