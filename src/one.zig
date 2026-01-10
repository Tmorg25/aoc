const std = @import("std");

const start = 50;

pub fn q() !void {
    const cwd = std.fs.cwd();

    const file = try cwd.openFile("q1/input.txt", .{});
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

    const res = p2(content) catch 0;
    std.debug.print("res: {d}\n", .{res});
}

fn p2(parsed: []u8) !u32 {
    const delim: u8 = '\n';
    var iterator = std.mem.splitScalar(u8, parsed, delim);
    var curr: i32 = 50;
    var count: u32 = 0;

    std.debug.print("val \tcurr \tcount\n", .{});

    while (iterator.next()) |segment| {
        if (segment.len == 0) {
            break;
        }
        const number = segment[1..];
        const parsedNum = try std.fmt.parseInt(i32, number, 10);

        const wholeRotations = @abs(@divTrunc(parsedNum, 100));
        const remainder = @rem(parsedNum, 100);

        if (segment[0] == 'L') {
            const st = curr;
            const end = curr - remainder;

            if (st > 0 and end < 0) {
                count += 1;
            } else if (@divTrunc(st, 100) != @divTrunc(end, 100) and (@rem(st, 100) != 0 and @rem(end, 100) != 0)) {
                // if start is alr on 0, we counted in the last rotation
                // if end is on 0, we count in the next conditional
                count += 1;
            } else if (@rem(end, 100) == 0) {
                count += 1;
            }

            count += wholeRotations;

            curr = curr - parsedNum;
            curr = @mod(curr, 100);
        } else if (segment[0] == 'R') {
            const st = curr;
            const end = curr + remainder;

            if (st < 0 and end > 0) {
                count += 1;
            } else if (@divTrunc(st, 100) != @divTrunc(end, 100) and (@rem(st, 100) != 0 and @rem(end, 100) != 0)) {
                count += 1;
            } else if (@rem(end, 100) == 0) {
                count += 1;
            }

            count += wholeRotations;

            curr = curr + parsedNum;
            curr = @mod(curr, 100);
        }
        std.debug.print("{d} \t{d} \t{d}\n", .{ parsedNum, curr, count });
    }
    return count;
}

fn p1(parsed: []u8) !u32 {
    const delim: u8 = '\n';
    var iterator = std.mem.splitScalar(u8, parsed, delim);
    var curr: i32 = 50;
    var count: u32 = 0;

    while (iterator.next()) |segment| {
        // does this include the delim?
        if (segment.len == 0) {
            break;
        }
        const number = segment[1..];
        const parsedNum = try std.fmt.parseInt(i32, number, 10);

        std.debug.print("val: {d}\n", .{parsedNum});

        if (segment[0] == 'L') {
            curr = curr - parsedNum;
        } else if (segment[0] == 'R') {
            curr = curr + parsedNum;
        }
        if (@rem(curr, 100) == 0) {
            count += 1;
        }
        curr = @mod(curr, 100);
    }
    return count;
}
