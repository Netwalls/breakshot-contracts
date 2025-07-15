
// use starknet::{ContractAddress, get_caller_address};

// #[starknet::interface]
// pub trait IERC20<T> {
//     fn name(self: @T) -> felt252;
//     fn symbol(self: @T) -> felt252;
//     fn decimals(self: @T) -> u8;
//     fn totalSupply(self: @T) -> u256;
//     fn balanceOf(self: @T, account: ContractAddress) -> u256;
//     fn allowance(self: @T, owner: ContractAddress, spender: ContractAddress) -> u256;
//     fn transfer(ref self: T, recipient: ContractAddress, amount: u256) -> bool;
//     fn transferFrom(ref self: T, sender: ContractAddress, recipient: ContractAddress, amount: u256) -> bool;
//     fn approve(ref self: T, spender: ContractAddress, amount: u256) -> bool;
// }

// #[starknet::contract]
// pub mod MockERC20 {
//     use starknet::{ContractAddress, get_caller_address};
//     use super::IERC20;

//     #[storage]
//     struct Storage {
//         name: felt252,
//         symbol: felt252,
//         decimals: u8,
//         total_supply: u256,
//         balances: LegacyMap<ContractAddress, u256>,
//         allowances: LegacyMap<(ContractAddress, ContractAddress), u256>,
//     }

//     #[event]
//     #[derive(Drop, starknet::Event)]
//     enum Event {
//         Transfer: Transfer,
//         Approval: Approval,
//     }

//     #[derive(Drop, starknet::Event)]
//     struct Transfer {
//         from: ContractAddress,
//         to: ContractAddress,
//         value: u256,
//     }

//     #[derive(Drop, starknet::Event)]
//     struct Approval {
//         owner: ContractAddress,
//         spender: ContractAddress,
//         value: u256,
//     }

//     #[constructor]
//     fn constructor(ref self: ContractState) {
//         self.name.write('StarkToken');
//         self.symbol.write('STRK');
//         self.decimals.write(18);
//         let initial_supply = 1000000 * 10_u256.pow(18); // 1,000,000 STRK
//         let caller = get_caller_address();
//         self.total_supply.write(initial_supply);
//         self.balances.write(caller, initial_supply);
//         self.emit(Transfer { from: starknet::contract_address_const::<0>(), to: caller, value: initial_supply });
//     }

//     #[abi(embed_v0)]
//     impl ERC20Impl of IERC20<ContractState> {
//         fn name(self: @ContractState) -> felt252 {
//             self.name.read()
//         }

//         fn symbol(self: @ContractState) -> felt252 {
//             self.symbol.read()
//         }

//         fn decimals(self: @ContractState) -> u8 {
//             self.decimals.read()
//         }

//         fn totalSupply(self: @ContractState) -> u256 {
//             self.total_supply.read()
//         }

//         fn balanceOf(self: @ContractState, account: ContractAddress) -> u256 {
//             self.balances.read(account)
//         }

//         fn allowance(self: @ContractState, owner: ContractAddress, spender: ContractAddress) -> u256 {
//             self.allowances.read((owner, spender))
//         }

//         fn transfer(ref self: ContractState, recipient: ContractAddress, amount: u256) -> bool {
//             let sender = get_caller_address();
//             self._transfer(sender, recipient, amount);
//             true
//         }

//         fn transferFrom(ref self: ContractState, sender: ContractAddress, recipient: ContractAddress, amount: u256) -> bool {
//             let caller = get_caller_address();
//             let allowance = self.allowances.read((sender, caller));
//             assert(allowance >= amount, 'Insufficient allowance');
//             self._transfer(sender, recipient, amount);
//             self.allowances.write((sender, caller), allowance - amount);
//             self.emit(Approval { owner: sender, spender: caller, value: allowance - amount });
//             true
//         }

//         fn approve(ref self: ContractState, spender: ContractAddress, amount: u256) -> bool {
//             let owner = get_caller_address();
//             self.allowances.write((owner, spender), amount);
//             self.emit(Approval { owner, spender, value: amount });
//             true
//         }
//     }

//     #[generate_trait]
//     impl InternalImpl of InternalTrait {
//         fn _transfer(ref self: ContractState, sender: ContractAddress, recipient: ContractAddress, amount: u256) {
//             assert(sender != starknet::contract_address_const::<0>(), 'Transfer from zero address');
//             assert(recipient != starknet::contract_address_const::<0>(), 'Transfer to zero address');
//             let sender_balance = self.balances.read(sender);
//             assert(sender_balance >= amount, 'Insufficient balance');
//             self.balances.write(sender, sender_balance - amount);
//             self.balances.write(recipient, self.balances.read(recipient) + amount);
//             self.emit(Transfer { from: sender, to: recipient, value: amount });
//         }
//     }
// }