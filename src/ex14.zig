const std = @import("std");

pub fn main() void {
    var longest_chain_length: usize = 0;
    var longest_chain_n: usize = 0;

    for (1..1_000_000) |n| {
        const chain_length = getCollatzChainLength(n);
        if (chain_length > longest_chain_length) {
            longest_chain_length = chain_length;
            longest_chain_n = n;
        }
    }
    std.debug.print("{}\n", .{longest_chain_n});
}

fn getNextCollatz(n: usize) usize {
    if (n % 2 == 0) {
        return n / 2;
    } else {
        return 3 * n + 1;
    }
}

fn getCollatzChainLength(start: usize) usize {
    std.debug.assert(start > 0);
    var n: usize = start;
    var count: usize = 1;
    while (true) {
        n = getNextCollatz(n);
        count += 1;
        if (n == 1) {
            return count;
        }
    }
}
