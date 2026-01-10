const std = @import("std");

pub fn q() !void {
    const cwd = std.fs.cwd();

    const file = try cwd.openFile("q2/input.txt", .{});
    defer file.close();

    var gpa = std.heap.DebugAllocator(.{}).init;
    defer {
        const leaks = gpa.deinit();
        switch (leaks) {
            .ok => {},
            .leak => {
                std.debug.print("Memory leak detected!\n", .{});
            },
        }
    }

    const a = gpa.allocator();

    const content = try file.readToEndAlloc(a, std.math.maxInt(usize));

    defer a.free(content);

    const res = p1(content) catch 0;
    std.debug.print("res: {d}\n", .{res});
}

fn p1(content: []u8) !u64 {
    const delim: u8 = ',';
    var iterator = std.mem.splitScalar(u8, content, delim);
    var ret: u64 = 0;

    while (iterator.next()) |range| {
        const rangeDelim: u8 = '-';
        var rangeIter = std.mem.splitScalar(u8, range, rangeDelim);

        // guaranteed to be a valid range that looks like x-y
        const start = rangeIter.next().?;
        const end = rangeIter.next().?;

        std.debug.print("{s: <[width]}\t", .{
            .value = start,
            .width = 14,
        });
        std.debug.print("{s: <[width]}\n", .{
            .value = end,
            .width = 14,
        });

        const startInt: u64 = try std.fmt.parseInt(u64, start, 10);
        const endInt: u64 = try std.fmt.parseInt(u64, end, 10);

        ret += getSumInvalidFromRange(startInt, endInt);
    }
    return ret;
}

fn getSumInvalidFromRange(start: u64, end: u64) u64 {
    var sum = 0;

    while (start <= end) {
        // grab a  string from start

    }
    return 0;
}

fn checkInvalid(num: u64) u64 {
    var gpa = std.heap.DebugAllocator(.{}).init;
    defer _ = gpa.deinit();
    const a = gpa.allocator();
    const stringNum: []const u8 = try std.fmt.allocPrint(a, "{}", .{num});
    defer a.free(stringNum);

    return 0;
}
