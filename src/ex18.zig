const std = @import("std");

const MAX_SIZE = 1_000;
const ROW_COUNT = 15;
const INPUT_PATH = "src/ex18_input.txt";

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const result = try getOptimalTrianglePathValue(allocator, ROW_COUNT, INPUT_PATH, MAX_SIZE);
    std.debug.print("{}\n", .{result});
}

pub fn getOptimalTrianglePathValue(allocator: std.mem.Allocator, row_count: usize, input_path: []const u8, max_buf_size: usize) !usize {
    var triangle_values = try getInputValues(allocator, row_count, input_path, max_buf_size);
    defer allocator.free(triangle_values);

    // counting rows 1-indexed
    var row_index: usize = row_count;
    while (row_index > 1) : (row_index -= 1) {
        // counting elements within a row 0-indexed
        var right_element_index: usize = row_index - 1;

        while (right_element_index > 0) : (right_element_index -= 1) {
            const right_element_backing_array_index = getTriangleNumber(row_index - 1) + right_element_index;
            const left_element = triangle_values[right_element_backing_array_index - 1];
            const right_element = triangle_values[right_element_backing_array_index];
            const larger_element = @max(left_element, right_element);
            const element_to_increase_backing_array_index = right_element_backing_array_index - row_index;
            triangle_values[element_to_increase_backing_array_index] += larger_element;
        }
    }
    return triangle_values[0];
}

fn getInputValues(allocator: std.mem.Allocator, row_count: usize, input_path: []const u8, max_buf_size: usize) ![]usize {
    const input_file = try std.fs.cwd().openFile(input_path, .{});
    defer input_file.close();

    const in_stream = input_file.reader();
    var triangle_values = try allocator.alloc(usize, getTriangleNumber(row_count));
    var count: usize = 0;
    while (try in_stream.readUntilDelimiterOrEofAlloc(allocator, '\n', max_buf_size)) |line| {
        defer allocator.free(line);
        var it = std.mem.split(u8, line, " ");
        while (it.next()) |x| {
            const num = (x[0] - '0') * 10 + x[1] - '0';
            triangle_values[count] = num;
            count += 1;
        }
    }
    return triangle_values;
}

fn getTriangleNumber(n: usize) usize {
    std.debug.assert(n != 0);
    var sum: usize = 0;
    for (1..n + 1) |i| {
        sum += i;
    }
    return sum;
}
