const std = @import("std");
const print = std.debug.print;

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

    // remove the file termination and the newline
    const res = try p1(content[0 .. content.len - 1]);
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
    var sum: u64 = 0;
    var st = start;

    while (st <= end) {
        if (isIntValid(st)) {
            sum += st;
        }
        st += 1;
    }

    return sum;
}

fn isIntValid(num: u64) bool {
    var gpa = std.heap.DebugAllocator(.{}).init;
    defer _ = gpa.deinit();
    const a = gpa.allocator();

    const stringNum: []const u8 = std.fmt.allocPrint(a, "{}", .{num}) catch "";
    defer a.free(stringNum);

    //    std.debug.print("{s}", .{stringNum});

    return isStringValidP2(stringNum);
}

fn isStringValid(str: []const u8) bool {
    if (str.len == 0 or str.len % 2 != 0) {
        return false;
    }
    const possiblePattern = str[0 .. str.len / 2];
    const countNeedles = std.mem.count(u8, str, possiblePattern);
    if (countNeedles == 2) {
        return true;
    }

    return false;
}

fn isStringValidP2(str: []const u8) bool {
    if (str.len == 0) {
        return false;
    }
    const firstChar = 0;
    var second: u32 = 1;
    //    print("\nstring: {s}\n", .{str});

    while (second < str.len / 2 + 1) {
        if (str[second] == str[firstChar]) {
            // we have a pattern from firstChar -> second - 1
            const possiblePattern = str[firstChar..second];
            //            print("pattern: {s}\n", .{possiblePattern});

            const countNeedles = std.mem.count(u8, str, possiblePattern);
            //            print("count: {d}\n", .{countNeedles});

            if (countNeedles * possiblePattern.len == str.len) {
                print("found: {s}\n", .{str});
                return true;
            }
        }
        second += 1;
    }
    return false;
}
