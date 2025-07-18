#[derive(Copy, Drop, Serde, Introspect, Debug, PartialEq)]
pub enum SnookerShot {
    Pot,
    Safety,
    Cannon,
    Swerve,
    Stun,
    Screw,
    Topspin,
    Break,
    Default,
}

pub impl SnookerShotDisplay of core::fmt::Display<SnookerShot> {
    fn fmt(self: @SnookerShot, ref f: core::fmt::Formatter) -> Result<(), core::fmt::Error> {
        let s = match self {
            SnookerShot::Pot => "Pot",
            SnookerShot::Safety => "Safety",
            SnookerShot::Cannon => "Cannon",
            SnookerShot::Swerve => "Swerve",
            SnookerShot::Stun => "Stun",
            SnookerShot::Screw => "Screw",
            SnookerShot::Topspin => "Topspin",
            SnookerShot::Break => "Break",
            SnookerShot::Default => "Default",
        };
        f.buffer.append(@s);
        Result::Ok(())
    }
}
