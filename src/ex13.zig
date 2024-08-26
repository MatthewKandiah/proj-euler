const std = @import("std");

pub fn main() !void {
    var input_file = try std.fs.cwd().openFile("src/ex13_input.txt", .{});
    defer input_file.close();

    var buf_reader = std.io.bufferedReader(input_file.reader());
    var in_stream = buf_reader.reader();

    var read_buf: [5000]u8 = undefined;
    while (try in_stream.readUntilDelimiterOrEof(&read_buf, '\n')) |line| {
        std.debug.print("{s}\n", .{line});
    }
}
