use core::byte_array::ByteArrayTrait;

#[derive(Drop, Serde, IntrospectPacked, Debug)]
pub enum SnookerRarity {
    Basic,
    Common,
    Uncommon,
    Rare,
    VeryRare,
    Epic,
    Unique,
}

#[generate_trait]
pub impl SnookerRarityImpl of SnookerRarityTrait {
    fn is_rare(self: @SnookerRarity) -> bool {
        match self {
            SnookerRarity::Rare | SnookerRarity::VeryRare | SnookerRarity::Epic | SnookerRarity::Unique => true,
            _ => false,
        }
    }
}

pub impl SnookerRarityDisplay of core::fmt::Display<SnookerRarity> {
    fn fmt(self: @SnookerRarity, ref f: core::fmt::Formatter) -> Result<(), core::fmt::Error> {
        let s = match self {
            SnookerRarity::Basic => "Basic",
            SnookerRarity::Common => "Common",
            SnookerRarity::Uncommon => "Uncommon",
            SnookerRarity::Rare => "Rare",
            SnookerRarity::VeryRare => "Very Rare",
            SnookerRarity::Epic => "Epic",
            SnookerRarity::Unique => "Unique",
        };
        f.buffer.append(@s);
        Result::Ok(())
    }
}