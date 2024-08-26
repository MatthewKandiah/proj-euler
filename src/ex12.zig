const std = @import("std");

const target = 500;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var triangle_numbers = std.ArrayList(usize).init(allocator);
    try triangle_numbers.append(1);
    var biggest_result_so_far: usize = 1;
    var divisor_count: usize = 1;
    while (divisor_count <= target) {
        try appendNextTriangleNumber(&triangle_numbers);
        divisor_count = countDivisors(triangle_numbers.getLast());
        if (divisor_count > biggest_result_so_far) {
            biggest_result_so_far = divisor_count;
            std.debug.print("New best! {}. {} divisors\n", .{ triangle_numbers.getLast(), biggest_result_so_far });
        }
    }
    std.debug.print("{}\n", .{triangle_numbers.getLast()});
}

fn appendNextTriangleNumber(triangle_numbers: *std.ArrayList(usize)) !void {
    try triangle_numbers.append(triangle_numbers.getLast() + triangle_numbers.items.len + 1);
}

fn countDivisors(n: usize) usize {
    std.debug.assert(n != 0);
    if (n == 1) return 1;
    var result: usize = 2; // 1 and n are always divisors
    var candidate: usize = 2;
    var smallest_non_one_divisor: usize = 0;
    while (true) : (candidate += 1) {
        if (n % candidate == 0) {
            if (n != candidate) {
                result += 1;
            }
            if (smallest_non_one_divisor == 0) {
                smallest_non_one_divisor = candidate;
            }
        }
        if (smallest_non_one_divisor != 0 and n / candidate < smallest_non_one_divisor) {
            return result;
        }
    }
}
