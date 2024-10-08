const std = @import("std");
const util = @import("util.zig");

const target = 600851475143;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    var primes = std.ArrayList(usize).init(allocator);
    try primes.append(2);
    try primes.append(3);
    while (std.math.pow(usize, primes.getLast(), 2) < target) {
        try util.append_next_prime(&primes);
    }

    for (0..primes.items.len) |i| {
        const index = primes.items.len - 1 - i;
        if (target % primes.items[index] == 0) {
            std.debug.print("{}\n", .{primes.items[index]});
            break;
        }
    }
}
