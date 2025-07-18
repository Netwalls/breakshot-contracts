use core::byte_array::ByteArrayTrait;

#[derive(Drop, Serde, Debug, Introspect, PartialEq, Copy)]
pub enum SnookerTournament {
    Local,
    National,
    International,
    Invitational,
    Ranking,
    Masters,
    WorldChampionship,
    Default,
}

#[generate_trait]
pub impl SnookerTournamentImpl of SnookerTournamentTrait {
    fn is_prestigious(self: @SnookerTournament) -> bool {
        match self {
            SnookerTournament::Ranking | SnookerTournament::Masters |
            SnookerTournament::WorldChampionship => true,
            _ => false,
        }
    }
}

pub impl SnookerTournamentDisplay of core::fmt::Display<SnookerTournament> {
    fn fmt(self: @SnookerTournament, ref f: core::fmt::Formatter) -> Result<(), core::fmt::Error> {
        let s = match self {
            SnookerTournament::Local => "Local",
            SnookerTournament::National => "National",
            SnookerTournament::International => "International",
            SnookerTournament::Invitational => "Invitational",
            SnookerTournament::Ranking => "Ranking",
            SnookerTournament::Masters => "Masters",
            SnookerTournament::WorldChampionship => "World Championship",
            SnookerTournament::Default => "Default",
        };
        f.buffer.append(@s);
        Result::Ok(())
    }
}
