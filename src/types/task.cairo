
        use starknet::ContractAddress;

        #[derive( Drop, Serde, Debug, Introspect, PartialEq)]
        pub struct Task {
            pub name: felt252,
            pub target: u32,
            pub description: ByteArray,
        }

        #[generate_trait]
        pub impl TaskImpl of TaskTrait {
            #[inline]
            fn new(name: felt252, target: u32, description: ByteArray) -> Task {
                Task { name, target, description }
            }
        }
