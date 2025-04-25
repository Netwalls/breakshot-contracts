#[cfg(test)]
mod tests {
    use dojo_cairo_test::WorldStorageTestTrait;
    use dojo::model::{ModelStorage, ModelStorageTest};
    use dojo::world::WorldStorageTrait;
    use dojo_cairo_test::{
        spawn_test_world, NamespaceDef, TestResource, ContractDefTrait, ContractDef,
    };

    use dojo_starter::systems::Snooknet::{Snooknet};
    use dojo_starter::interfaces::ISnooknet::{ISnooknetDispatcher, ISnooknetDispatcherTrait};

    use dojo_starter::model::game_model::{Game, m_Game, GameState, GameCounter, m_GameCounter};
    use starknet::{testing, get_caller_address, contract_address_const};

    fn namespace_def() -> NamespaceDef {
        let ndef = NamespaceDef {
            namespace: "Snooknet",
            resources: [
                TestResource::Model(m_GameCounter::TEST_CLASS_HASH),
                TestResource::Model(m_Game::TEST_CLASS_HASH),
                TestResource::Event(Snooknet::e_GameCreated::TEST_CLASS_HASH),
                TestResource::Event(Snooknet::e_Winner::TEST_CLASS_HASH),
                TestResource::Event(Snooknet::e_GameEnded::TEST_CLASS_HASH),
                TestResource::Contract(Snooknet::TEST_CLASS_HASH),
            ]
                .span(),
        };

        ndef
    }

    fn contract_defs() -> Span<ContractDef> {
        [
            ContractDefTrait::new(@"Snooknet", @"Snooknet")
                .with_writer_of([dojo::utils::bytearray_hash(@"Snooknet")].span())
        ]
            .span()
    }


    #[test]
    fn test_create_game() {
        let caller_1 = contract_address_const::<'aji'>();
        let player_1 = contract_address_const::<'player'>();

        let ndef = namespace_def();
        let mut world = spawn_test_world([ndef].span());
        world.sync_perms_and_inits(contract_defs());

        let (contract_address, _) = world.dns(@"Snooknet").unwrap();
        let actions_system = ISnooknetDispatcher { contract_address };

        testing::set_contract_address(caller_1);

        let game_id = actions_system.create_match(player_1, 400);
        assert(game_id == 1, 'Wrong game id');
        println!("game_id: {}", game_id);
    }

    #[test]
    fn test_create_game_two_games() {
        let caller_1 = contract_address_const::<'aji'>();
        let player_1 = contract_address_const::<'player'>();
        let player = contract_address_const::<'playeriw'>();
        let opponent = contract_address_const::<'opponent'>();

        let ndef = namespace_def();
        let mut world = spawn_test_world([ndef].span());
        world.sync_perms_and_inits(contract_defs());

        let (contract_address, _) = world.dns(@"Snooknet").unwrap();
        let actions_system = ISnooknetDispatcher { contract_address };

        testing::set_contract_address(caller_1);

        let game_id = actions_system.create_match(player_1, 400);

        testing::set_contract_address(player);
        let game_id_1 = actions_system.create_match(opponent, 1000);
        assert(game_id_1 == 2, 'Wrong game id');
        println!("game_id: {}", game_id);
    }

    #[test]
    fn test_end_game() {
        let caller_1 = contract_address_const::<'aji'>();
        let player_1 = contract_address_const::<'player'>();

        let ndef = namespace_def();
        let mut world = spawn_test_world([ndef].span());
        world.sync_perms_and_inits(contract_defs());

        let (contract_address, _) = world.dns(@"Snooknet").unwrap();
        let actions_system = ISnooknetDispatcher { contract_address };

        testing::set_contract_address(caller_1);
        let game_id = actions_system.create_match(player_1, 400);

        testing::set_contract_address(caller_1);
        actions_system.end_match(game_id, caller_1);

        testing::set_contract_address(caller_1);
        let game = actions_system.retrieve_game(game_id);

        assert(game.winner == caller_1, 'Winner not set correctly');
        assert(game.state == GameState::Finished, 'Game not ended');
    }

    #[test]
    #[should_panic]
    fn test_non_participant_end_game() {
        let caller_1 = contract_address_const::<'aji'>();
        let player_1 = contract_address_const::<'player'>();
        let player = contract_address_const::<'pla'>();

        let ndef = namespace_def();
        let mut world = spawn_test_world([ndef].span());
        world.sync_perms_and_inits(contract_defs());

        let (contract_address, _) = world.dns(@"Snooknet").unwrap();
        let actions_system = ISnooknetDispatcher { contract_address };

        testing::set_contract_address(caller_1);
        let game_id = actions_system.create_match(player_1, 400);

        testing::set_contract_address(player);
        actions_system.end_match(game_id, caller_1);

        testing::set_contract_address(caller_1);
        let game = actions_system.retrieve_game(game_id);

        assert(game.winner == caller_1, 'Winner not set correctly');
        assert(game.state == GameState::Finished, 'Game not ended');
    }
}
