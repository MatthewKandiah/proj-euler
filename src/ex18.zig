const std = @import("std");

const MAX_SIZE = 1_000;
const ROW_COUNT = 15;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    const input_file = try std.fs.cwd().openFile("src/ex18_input.txt", .{});
    defer input_file.close();

    const in_stream = input_file.reader();
    var triangle_values = try allocator.alloc(usize, getTriangleNumber(ROW_COUNT));
    var count: usize = 0;
    while (try in_stream.readUntilDelimiterOrEofAlloc(allocator, '\n', MAX_SIZE)) |line| {
        var it = std.mem.split(u8, line, " ");
        while (it.next()) |x| {
            const num = (x[0] - '0') * 10 + x[1] - '0';
            triangle_values[count] = num;
            count += 1;
        }
    }
    for (triangle_values) |x| {
        std.debug.print("{}\n", .{x});
    }
}

fn getTriangleNumber(n: usize) usize {
    std.debug.assert(n != 0);
    var sum: usize = 0;
    for (1..n + 1) |i| {
        sum += i;
    }
    return sum;
}
