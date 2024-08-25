const std = @import("std");

const MAX = 999;

pub fn main() !void {
    var biggest_found: usize = 0;
    var buf: [6]usize = undefined;
    for (1..MAX + 1) |i| {
        for (i..MAX + 1) |j| {
            const product = i * j;
            if (isPalindrome(product, &buf) and product > biggest_found) {
                biggest_found = product;
            }
        }
    }
    std.debug.print("{}\n", .{biggest_found});
}

fn isPalindrome(num: usize, buf: [*]usize) bool {
    var x = num;
    var count: usize = 0;
    while (x > 0) {
        buf[count] = x % 10;
        x = x / 10;
        count += 1;
    }
    for (0..count) |idx| {
        const reverse_idx: usize = count - 1 - idx;
        if (buf[idx] != buf[reverse_idx]) {
            return false;
        }
    }
    return true;
}
