const std = @import("std");
const ex18 = @import("ex18.zig");

const MAX_SIZE = 1_000;
const ROW_COUNT = 100;
const INPUT_PATH = "src/ex67_input.txt";

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const result = try ex18.getOptimalTrianglePathValue(allocator, ROW_COUNT, INPUT_PATH, MAX_SIZE);
    std.debug.print("{}\n", .{result});
}
