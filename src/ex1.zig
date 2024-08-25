const std = @import("std");

pub fn main() void {
    var sum: usize = 0;
    for (1..1000) |i| {
        if (i % 3 == 0 or i % 5 == 0) {
            sum += i;
        }
    }
    std.debug.print("{}\n", .{sum});
}
