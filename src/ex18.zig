const std = @import("std");

const MAX_SIZE = 1_000;
const ROW_COUNT = 15;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var triangle_values = try getInputValues(allocator);
    defer allocator.free(triangle_values);

    // counting rows 1-indexed
    var row_index: usize = ROW_COUNT;
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
    std.debug.print("{}\n", .{triangle_values[0]});
}

fn getInputValues(allocator: std.mem.Allocator) ![]usize {
    const input_file = try std.fs.cwd().openFile("src/ex18_input.txt", .{});
    defer input_file.close();

    const in_stream = input_file.reader();
    var triangle_values = try allocator.alloc(usize, getTriangleNumber(ROW_COUNT));
    var count: usize = 0;
    while (try in_stream.readUntilDelimiterOrEofAlloc(allocator, '\n', MAX_SIZE)) |line| {
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
