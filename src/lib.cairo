pub mod systems {
    pub mod Snooknet;
    // pub mod player;
    pub mod tournament;
    // pub mod snooker;
}

pub mod model {
    pub mod game_model;
    pub mod player_model;
    // pub mod tournament_model;
    pub mod new_tourn_models;
}

pub mod interfaces {
    pub mod ISnooknet;
    pub mod ITournaments;
}

// pub mod tests {
//     mod test_world;
// }

pub mod errors {
    pub mod errors;
}
pub mod types {
    pub mod ball_type;
    pub mod game_and_player_types;
    pub mod rarity;
    pub mod skill_type;
    pub mod tournament_types;
    pub mod task;
}

pub mod achievements {
    pub mod achievement;
}

// pub mod tokens {
//     pub mod mock_erc20;
// }
