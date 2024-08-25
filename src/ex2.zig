const std = @import("std");

pub fn main() void {
    var fib1: usize = 1;
    var fib2: usize = 2;
    var sum: usize = 0;
    while (fib2 < 4_000_000) {
        if (fib2 % 2 == 0) {
            sum += fib2;
        }
        const temp: usize = fib1 + fib2;
        fib1 = fib2;
        fib2 = temp;
    }
    std.debug.print("{}\n", .{sum});
}
