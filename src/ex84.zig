const std = @import("std");

const num_spaces = 39;
const dice_sides = 6;

const BoardSpace = enum(usize) {
    go = 0,
    a1,
    cc1,
    a2,
    t1,
    r1,
    b1,
    ch1,
    b2,
    b3,
    jail,
    c1,
    u1,
    c2,
    c3,
    r2,
    d1,
    cc2,
    d2,
    d3,
    fp,
    e1,
    ch2,
    e2,
    e3,
    r3,
    f1,
    f2,
    u2,
    f3,
    g2j,
    g1,
    g2,
    cc3,
    g3,
    r4,
    ch3,
    h1,
    t2,
    h2,
};

const MonopolyContext = struct {
    num_visits: [num_spaces]u32,
    current_space: BoardSpace,
    doubles_rolled: u32,

    const Self = @This();

    fn init() Self {
        var num_visits: [num_spaces]u32 = .{0} ** num_spaces;
        num_visits[0] = 1;
        return Self{
            .num_visits = num_visits,
            .current_space = .go,
            .doubles_rolled = 0,
        };
    }

    fn move(self: *Self, roll1: usize, roll2: usize) void {
        if (roll1 == roll2) {
            self.doubles_rolled += 1;
            if (self.doubles_rolled == 3) {
                self.doubles_rolled = 0;
                self.goToSpace(.jail);
                return;
            }
        }

        const initial_result: BoardSpace = @enumFromInt((@intFromEnum(self.current_space) + roll1 + roll2) % num_spaces);
        switch (initial_result) {
            .g2j => self.goToSpace(.jail),
            .cc1, .cc2, .cc3 => |space| self.handleCommunityChest(space),
            .ch1, .ch2, .ch3 => |space| self.handleChance(space),
            .go, .a1, .a2, .t1, .r1, .b1, .b2, .b3, .jail, .c1, .u1, .c2, .c3, .r2, .d1, .d2, .d3, .fp, .e1, .e2, .e3, .r3, .f1, .f2, .u2, .f3, .g1, .g2, .g3, .r4, .h1, .t2, .h2 => |space| self.goToSpace(space),
        }
    }

    fn handleCommunityChest(self: *Self, space: BoardSpace) void {
        _ = self;
        _ = space;
    }

    fn handleChance(self: *Self, space: BoardSpace) void {
        _ = self;
        _ = space;
    }

    fn goToSpace(self: *Self, space: BoardSpace) void {
        self.current_space = space;
        self.num_visits[@intFromEnum(space)] += 1;
    }
};

pub fn main() void {
    var rng = std.rand.DefaultPrng.init(42);
    var context = MonopolyContext.init();

    var finished = false;
    while (!finished) {
        const roll1 = rollDice(&rng, dice_sides);
        const roll2 = rollDice(&rng, dice_sides);
        context.move(roll1, roll2);
        finished = true;
    }
}

fn rollDice(rng: *std.rand.Xoshiro256, sides: u32) u32 {
    return @intCast(rng.next() % sides);
}
