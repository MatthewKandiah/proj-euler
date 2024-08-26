const std = @import("std");
const util = @import("util.zig");

const target = 2_000_000;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    var primes = std.ArrayList(usize).init(allocator);
    try primes.append(2);
    try primes.append(3);

    while (true) {
        try util.append_next_prime(&primes);
        if (primes.getLast() > target) {
            _ = primes.pop();
            break;
        }
    }

    var sum: usize = 0;
    for (primes.items) |prime| {
        sum += prime;
    }

    std.debug.print("{}\n", .{sum});
}
