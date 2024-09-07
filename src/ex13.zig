const std = @import("std");

pub fn main() !void {
    var input_file = try std.fs.cwd().openFile("src/ex13_input.txt", .{});
    defer input_file.close();

    var in_stream = input_file.reader();

    // reads 50 digits and a delimiter
    var read_buf: [51]u8 = undefined;
    var sum: usize = 0;
    while (try in_stream.readUntilDelimiterOrEof(&read_buf, '\n')) |line| {
        // if you add 50 one-digit numbers, the max possible result is 450
        // so to get the correct first 10 digits of the sum, we only need to add the first 12 digits of each number, the less significant figures are inconsequential noise
        const leading_digits = try std.fmt.parseInt(usize, line[0..12], 10);
        sum += leading_digits;
    }
    var result_buf: [14]u8 = .{'0'} ** 14;
    const result = try std.fmt.bufPrint(&result_buf, "{}", .{sum});
    std.debug.print("{s}\n", .{result[0..10]});
}
