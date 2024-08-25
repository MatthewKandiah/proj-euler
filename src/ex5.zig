const std = @import("std");

const MAX = 20;

pub fn main() void {
    var finished = false;
    var candidate: usize = 2;
    outer: while (!finished) {
        for (2..MAX + 1) |i| {
            if (candidate % i != 0) {
                candidate += 1;
                continue :outer;
            }
        }
        finished = true;
    }
    std.debug.print("{}\n", .{candidate});
}
