const std = @import("std");

pub fn append_next_prime(primes: *std.ArrayList(usize)) !void {
    var candidate = primes.getLast() + 2;
    outer: while (true) : (candidate += 2) {
        for (primes.items) |prime| {
            if (candidate % prime == 0) {
                continue :outer;
            }
        }
        break;
    }
    try primes.append(candidate);
}
