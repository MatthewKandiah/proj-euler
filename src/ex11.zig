const std = @import("std");

pub fn main() !void {
    var input_file = try std.fs.cwd().openFile("src/ex11_input.txt", .{});
    defer input_file.close();

    var buf_reader = std.io.bufferedReader(input_file.reader());
    var in_stream = buf_reader.reader();

    var read_buf: [400]u8 = undefined;
    var grid: [400]usize = undefined;
    var count: usize = 0;
    while (try in_stream.readUntilDelimiterOrEof(&read_buf, '\n')) |line| {
        var it = std.mem.split(u8, line, " ");
        while (it.next()) |x| {
            const num = (x[0] - '0') * 10 + x[1] - '0';
            grid[count] = num;
            count += 1;
        }
    }

    var max_found: usize = 0;
    for (0..16) |i| {
        for (0..20) |j| {
            const p = prod(getHorizontal(grid, i, j));
            if (p > max_found) {
                max_found = p;
            }
        }
    }
    for (0..20) |i| {
        for (0..16) |j| {
            const p = prod(getVertical(grid, i, j));
            if (p > max_found) {
                max_found = p;
            }
        }
    }
    for (0..16) |i| {
        for (0..16) |j| {
            const p = prod(getDiagonal1(grid, i, j));
            if (p > max_found) {
                max_found = p;
            }
        }
    }
    for (0..16) |i| {
        for (3..20) |j| {
            const p = prod(getDiagonal2(grid, i, j));
            if (p > max_found) {
                max_found = p;
            }
        }
    }
    std.debug.print("{}\n", .{max_found});
}

fn prod(array: [4]usize) usize {
    return array[0] * array[1] * array[2] * array[3];
}

fn get(grid: [400]usize, x: usize, y: usize) usize {
    return grid[x + 20 * y];
}

fn getHorizontal(grid: [400]usize, x: usize, y: usize) [4]usize {
    return [4]usize{
        get(grid, x, y),
        get(grid, x + 1, y),
        get(grid, x + 2, y),
        get(grid, x + 3, y),
    };
}

fn getVertical(grid: [400]usize, x: usize, y: usize) [4]usize {
    return [4]usize{
        get(grid, x, y),
        get(grid, x, y + 1),
        get(grid, x, y + 2),
        get(grid, x, y + 3),
    };
}

fn getDiagonal1(grid: [400]usize, x: usize, y: usize) [4]usize {
    return [4]usize{
        get(grid, x, y),
        get(grid, x + 1, y + 1),
        get(grid, x + 2, y + 2),
        get(grid, x + 3, y + 3),
    };
}

fn getDiagonal2(grid: [400]usize, x: usize, y: usize) [4]usize {
    return [4]usize{
        get(grid, x, y),
        get(grid, x + 1, y - 1),
        get(grid, x + 2, y - 2),
        get(grid, x + 3, y - 3),
    };
}
