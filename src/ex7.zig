const std = @import("std");
const util = @import("util.zig");

const target = 10_001;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    var primes = std.ArrayList(usize).init(allocator);
    try primes.append(2);
    try primes.append(3);
    while (primes.items.len < target) {
        try util.append_next_prime(&primes);
    }
    std.debug.print("{}\n", .{primes.getLast()});
}
