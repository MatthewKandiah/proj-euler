const std = @import("std");

const target = 500;

pub fn main() !void {
    const start_time = std.time.milliTimestamp();

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var generator: TriangleNumberGenerator = .{
        .triangle_number = 1,
        .increment = 2,
    };

    var worker_context: WorkerContext = .{
        .mutex = .{},
        .generator = &generator,
        .result = null,
        .target = target,
    };

    const thread_count = try std.Thread.getCpuCount();
    var threads = try allocator.alloc(std.Thread, thread_count);
    defer allocator.free(threads);
    for (0..thread_count) |i| {
        threads[i] = try std.Thread.spawn(
            .{ .allocator = allocator },
            worker,
            .{&worker_context},
        );
    }

    for (threads) |thread| {
        thread.join();
    }

    const finish_time = std.time.milliTimestamp();
    std.debug.print("Run time = {}ms\n", .{finish_time - start_time});
    std.debug.print("{}\n", .{worker_context.result.?});
}

fn worker(context: *WorkerContext) void {
    while (!context.isFinished()) {
        const candidate = context.next();
        const divisor_count = countDivisors(candidate);
        if (divisor_count > context.target) {
            context.updateResult(candidate);
        }
    }
}

const WorkerContext = struct {
    mutex: std.Thread.Mutex,
    generator: *TriangleNumberGenerator,
    result: ?usize,
    target: usize,

    const Self = @This();

    pub fn isFinished(self: Self) bool {
        return self.result != null;
    }

    pub fn updateResult(self: *Self, x: usize) void {
        self.mutex.lock();
        defer self.mutex.unlock();

        self.result = @max(self.result orelse 0, x);
    }

    pub fn next(self: *Self) usize {
        self.mutex.lock();
        defer self.mutex.unlock();

        return self.generator.next();
    }
};

const TriangleNumberGenerator = struct {
    triangle_number: usize,
    increment: usize,

    const Self = @This();

    pub fn next(self: *Self) usize {
        const result = self.triangle_number;
        self.triangle_number += self.increment;
        self.increment += 1;
        return result;
    }
};

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
