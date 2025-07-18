// Mock Task module for demonstration (replace with actual import if available)

// Import the Task and TaskTrait (adjust path based on your project structure)
use dojo_starter::types::task::{Task, TaskTrait};

// Into trait import
use core::traits::Into;

#[derive(Copy, Drop, Serde, Debug, Introspect, PartialEq)]
pub enum SnookerAchievement {
    FirstPot,
    BreakMaster,
    CenturyMaker,
    MaximumBreak,
    LegendShot,
    None,
}

#[generate_trait]
pub impl SnookerAchievementImpl of SnookerAchievementTrait {
    #[inline]
    fn identifier(self: SnookerAchievement) -> felt252 {
        match self {
            SnookerAchievement::None => '',
            SnookerAchievement::FirstPot => 'first pot',
            SnookerAchievement::BreakMaster => 'break master',
            SnookerAchievement::CenturyMaker => 'century maker',
            SnookerAchievement::MaximumBreak => 'maximum break',
            SnookerAchievement::LegendShot => 'legend shot',
        }
    }

    #[inline]
    fn hidden(self: SnookerAchievement) -> bool {
        match self {
            SnookerAchievement::None => true,
            _ => false,
        }
    }

    #[inline]
    fn index(self: SnookerAchievement) -> u8 {
        match self {
            SnookerAchievement::None => 0,
            SnookerAchievement::FirstPot => 1,
            SnookerAchievement::BreakMaster => 2,
            SnookerAchievement::CenturyMaker => 3,
            SnookerAchievement::MaximumBreak => 4,
            SnookerAchievement::LegendShot => 5,
        }
    }

    #[inline]
    fn points(self: SnookerAchievement) -> u8 {
        match self {
            SnookerAchievement::None => 0,
            SnookerAchievement::FirstPot => 10,
            SnookerAchievement::BreakMaster => 25,
            SnookerAchievement::CenturyMaker => 50,
            SnookerAchievement::MaximumBreak => 100,
            SnookerAchievement::LegendShot => 200,
        }
    }

    #[inline]
    fn group(self: SnookerAchievement) -> felt252 {
        match self {
            SnookerAchievement::None => '',
            SnookerAchievement::FirstPot => 'Snooker Star',
            SnookerAchievement::BreakMaster => 'Snooker Star',
            SnookerAchievement::CenturyMaker => 'Snooker Star',
            SnookerAchievement::MaximumBreak => 'Snooker Star',
            SnookerAchievement::LegendShot => 'Snooker Star',
        }
    }

    #[inline]
    fn icon(self: SnookerAchievement) -> felt252 {
        match self {
            SnookerAchievement::None => '',
            SnookerAchievement::FirstPot => 'fa-bullseye',
            SnookerAchievement::BreakMaster => 'fa-star',
            SnookerAchievement::CenturyMaker => 'fa-trophy',
            SnookerAchievement::MaximumBreak => 'fa-crown',
            SnookerAchievement::LegendShot => 'fa-diamond',
        }
    }

    #[inline]
    fn title(self: SnookerAchievement) -> felt252 {
        match self {
            SnookerAchievement::None => '',
            SnookerAchievement::FirstPot => 'First Pot',
            SnookerAchievement::BreakMaster => 'Break Master',
            SnookerAchievement::CenturyMaker => 'Century Maker',
            SnookerAchievement::MaximumBreak => 'Maximum Break',
            SnookerAchievement::LegendShot => 'Legend Shot',
        }
    }

    #[inline]
    fn description(self: SnookerAchievement) -> ByteArray {
        match self {
            SnookerAchievement::None => "",
            SnookerAchievement::FirstPot => "You've potted your first ball, a snooker beginner.",
            SnookerAchievement::BreakMaster => "You've scored a break of 50+, a rising talent.",
            SnookerAchievement::CenturyMaker => "You've made a century break, a true pro.",
            SnookerAchievement::MaximumBreak => "You've achieved a 147 break, a rare feat.",
            SnookerAchievement::LegendShot => "You've won 10 frames with a century, legendary.",
        }
    }

    #[inline]
    fn tasks(self: SnookerAchievement) -> Span<Task> {
        match self {
            SnookerAchievement::None => array![].span(), // Explicitly empty array
            SnookerAchievement::FirstPot => array![
                TaskTrait::new('First Pot', 1, "Pot a ball in a game"),
            ]
                .span(),
            SnookerAchievement::BreakMaster => array![
                TaskTrait::new('Break Master', 1, "Score a break of 50+"),
            ]
                .span(),
            SnookerAchievement::CenturyMaker => array![
                TaskTrait::new('Century Maker', 1, "Score a century break"),
            ]
                .span(),
            SnookerAchievement::MaximumBreak => array![
                TaskTrait::new('Maximum Break', 1, "Score a 147 break"),
            ]
                .span(),
            SnookerAchievement::LegendShot => array![
                TaskTrait::new('Legend Shot', 10, "Win 10 frames with a century"),
            ]
                .span(),
        }
    }

    #[inline]
    fn start(self: SnookerAchievement) -> ByteArray {
        ""
    }

    #[inline]
    fn end(self: SnookerAchievement) -> ByteArray {
        ""
    }

    #[inline]
    fn data(self: SnookerAchievement) -> ByteArray {
        ""
    }
}

pub impl IntoSnookerAchievementU8 of Into<SnookerAchievement, u8> {
    #[inline]
    fn into(self: SnookerAchievement) -> u8 {
        match self {
            SnookerAchievement::None => 0,
            SnookerAchievement::FirstPot => 1,
            SnookerAchievement::BreakMaster => 2,
            SnookerAchievement::CenturyMaker => 3,
            SnookerAchievement::MaximumBreak => 4,
            SnookerAchievement::LegendShot => 5,
        }
    }
}

pub impl IntoU8SnookerAchievement of Into<u8, SnookerAchievement> {
    #[inline]
    fn into(self: u8) -> SnookerAchievement {
        match self {
            0 => SnookerAchievement::None,
            1 => SnookerAchievement::FirstPot,
            2 => SnookerAchievement::BreakMaster,
            3 => SnookerAchievement::CenturyMaker,
            4 => SnookerAchievement::MaximumBreak,
            5 => SnookerAchievement::LegendShot,
            _ => SnookerAchievement::None,
        }
    }
}
