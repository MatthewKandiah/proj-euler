const std = @import("std");

const num_spaces = 40;
const dice_sides = 6;
const convergence_tolerance = 0.001;

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

    const Self = @This();

    fn nextRail(self: Self) Self {
        return switch (self) {
            .r4, .ch3, .h1, .t2, .h2, .go, .a1, .cc1, .a2, .t1 => .r1,
            .r1, .b1, .ch1, .b2, .b3, .jail, .c1, .u1, .c2, .c3 => .r2,
            .r2, .d1, .cc2, .d2, .d3, .fp, .e1, .ch2, .e2, .e3 => .r3,
            .r3, .f1, .f2, .u2, .f3, .g2j, .g1, .g2, .cc3, .g3 => .r4,
        };
    }

    fn nextUtility(self: Self) Self {
        return switch (self) {
            .u1, .c2, .c3, .r2, .d1, .cc2, .d2, .d3, .fp, .e1, .ch2, .e2, .e3, .r3, .f1, .f2 => .u2,
            .u2, .f3, .g2j, .g1, .g2, .cc3, .g3, .r4, .ch3, .h1, .t2, .h2, .go, .a1, .cc1, .a2, .t1, .r1, .b1, .ch1, .b2, .b3, .jail, .c1 => .u1,
        };
    }
};

const MonopolyContext = struct {
    num_visits: [num_spaces]u32,
    current_space: BoardSpace,
    doubles_rolled: u32,
    rng: *std.rand.Xoshiro256,
    community_cards_drawn: usize,
    chance_cards_drawn: usize,
    community_cards: [16]u32,
    chance_cards: [16]u32,

    const Self = @This();

    fn init(rng: *std.rand.Xoshiro256) Self {
        var num_visits: [num_spaces]u32 = .{0} ** num_spaces;
        num_visits[0] = 1;
        return Self{
            .num_visits = num_visits,
            .current_space = .go,
            .doubles_rolled = 0,
            .rng = rng,
            .community_cards_drawn = 0,
            .chance_cards_drawn = 0,
            .community_cards = .{ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
            .chance_cards = .{ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
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
        self.goToSpace(switch (self.community_cards[self.community_cards_drawn]) {
            0 => .go,
            1 => .jail,
            2...15 => space,
            else => unreachable,
        });
        self.community_cards_drawn += 1;
        self.community_cards_drawn %= 16;
    }

    fn handleChance(self: *Self, space: BoardSpace) void {
        self.goToSpace(switch (self.chance_cards[self.chance_cards_drawn]) {
            0 => .go,
            1 => .jail,
            2 => .c1,
            3 => .e3,
            4 => .h2,
            5 => .r1,
            6, 7 => space.nextRail(),
            8 => space.nextUtility(),
            9 => @enumFromInt(@intFromEnum(space) - 3),
            10...15 => space,
            else => unreachable,
        });
        self.chance_cards_drawn += 1;
        self.chance_cards_drawn %= 16;
    }

    fn goToSpace(self: *Self, space: BoardSpace) void {
        self.current_space = space;
        self.num_visits[@intFromEnum(space)] += 1;
    }

    fn rollDice(self: *Self, sides: u32) u32 {
        return @intCast(self.rng.next() % sides + 1);
    }

    fn getSpaceProbabilities(self: Self, count: u32) [num_spaces]f32 {
        var result: [num_spaces]f32 = undefined;
        for (0..num_spaces) |i| {
            result[i] = @as(f32, @floatFromInt(self.num_visits[i])) / @as(f32, @floatFromInt(count));
        }
        return result;
    }

    fn shuffle_decks(self: *Self) void {
        var temp: u32 = undefined;
        // shuffle community deck
        for (0..16) |i| {
            const shuf = self.rng.next() % 16;
            temp = self.community_cards[shuf];
            self.community_cards[shuf] = self.community_cards[i];
            self.community_cards[i] = temp;
        }
        // shuffle chance deck
        for (0..16) |i| {
            const shuf = self.rng.next() % 16;
            temp = self.chance_cards[shuf];
            self.chance_cards[shuf] = self.chance_cards[i];
            self.chance_cards[i] = temp;
        }
    }
};

pub fn main() void {
    var rng = std.rand.DefaultPrng.init(42);
    var context = MonopolyContext.init(&rng);
    context.shuffle_decks();

    var finished = false;
    var count: u32 = 0;
    const runs_between_checks = 1_000_000;
    var space_probabilities: [num_spaces]f32 = .{0} ** num_spaces;
    while (!finished) : (count += 1) {
        const roll1 = context.rollDice(dice_sides);
        const roll2 = context.rollDice(dice_sides);
        context.move(roll1, roll2);
        if (count > 0 and count % runs_between_checks == 0) {
            const next_space_probabilities = context.getSpaceProbabilities(count);
            if (probabilitiesConverged(next_space_probabilities, space_probabilities, convergence_tolerance)) {
                finished = true;
            } else {
                space_probabilities = next_space_probabilities;
            }
        }
    }

    var biggest_index: usize = 0;
    var second_biggest_index: usize = 0;
    var third_biggest_index: usize = 0;

    for (0..space_probabilities.len) |i| {
        if (space_probabilities[i] > space_probabilities[biggest_index]) {
            third_biggest_index = second_biggest_index;
            second_biggest_index = biggest_index;
            biggest_index = i;
        } else if (space_probabilities[i] > space_probabilities[second_biggest_index]) {
            third_biggest_index = second_biggest_index;
            second_biggest_index = i;
        } else if (space_probabilities[i] > space_probabilities[third_biggest_index]) {
            third_biggest_index = i;
        }
    }

    std.debug.print("{}, {}, {}\n", .{ biggest_index, second_biggest_index, third_biggest_index }); // 6-sided, expecting 10, 24, 00
}

pub fn probabilitiesConverged(probs1: [num_spaces]f32, probs2: [num_spaces]f32, tolerance: f32) bool {
    for (probs1, probs2) |x, y| {
        if (@abs(x - y) > tolerance) {
            return false;
        }
    }
    return true;
}
