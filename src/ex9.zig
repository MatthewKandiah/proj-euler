const std = @import("std");

const target = 1000;

pub fn main() void {
    var a: usize = 1;
    var b: usize = 1;
    while (true) {
        const maybe_c = pythag(a, b);
        if (maybe_c) |c| {
            if (a + b + c == 1000) {
                std.debug.print("{}\n", .{a * b * c});
                break;
            }
        }
        if (b + 1 > target) {
            a += 1;
            b = a;
        } else {
            b += 1;
        }
    }
}

fn square(x: usize) usize {
    return std.math.pow(usize, x, 2);
}

fn pythag(a: usize, b: usize) ?usize {
    const c_squared = square(a) + square(b);
    const maybe_c = std.math.sqrt(c_squared);
    if (square(maybe_c) == c_squared) {
        return maybe_c;
    } else {
        return null;
    }
}
