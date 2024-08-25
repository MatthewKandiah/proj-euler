const std = @import("std");

const target = 100;

pub fn main() void {
    std.debug.print("{}\n", .{squareOfSum(target) - sumOfSquares(target)});
}

fn sumOfSquares(max: usize) usize {
    var result: usize = 0;
    for (0..max + 1) |i| {
        result += std.math.pow(usize, i, 2);
    }
    return result;
}

fn squareOfSum(max: usize) usize {
    var sum: usize = 0;
    for (0..max + 1) |i| {
        sum += i;
    }
    return std.math.pow(usize, sum, 2);
}
