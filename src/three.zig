const std = @import("std");
const print = std.debug.print;

pub fn q() !void {
    const cwd = std.fs.cwd();

    const file = try cwd.openFile("q3/input.txt", .{});
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
    const res = try p1(content[0 .. content.len - 1], a);
    std.debug.print("res: {d}\n", .{res});
}

fn p1(content: []u8, a: std.mem.Allocator) !u64 {
    const delim: u8 = '\n';
    var iterator = std.mem.splitScalar(u8, content, delim);
    var ret: u64 = 0;

    while (iterator.next()) |bank| {
        ret += try maxInBankp2(bank, a);
    }

    return ret;
}
fn maxInBankp2(bank: []const u8, a: std.mem.Allocator) !u64 {
    var strMax = try std.fmt.allocPrint(a, "000000000000", .{});
    var indexInMax: u32 = 0;
    defer a.free(strMax);
    var startIdx: u32 = 0;

    print("bank: {s}\n", .{bank});

    while (indexInMax < strMax.len) {
        var index = startIdx;
        print("startIdx: {d} ", .{startIdx});
        print("finalIdxChecked: {d}\n", .{bank.len - (12 - indexInMax)});
        while (index < bank.len - (11 - indexInMax)) {
            if (bank[index] > strMax[indexInMax]) {
                strMax[indexInMax] = bank[index];
                startIdx = index + 1;
                if (bank[index] == '9') {
                    break;
                }
            }
            index += 1;
        }
        print("strmax: {s}\n", .{strMax});
        indexInMax += 1;
    }

    print("max: {s}\n", .{strMax});

    const max: u64 = try std.fmt.parseInt(u64, strMax, 10);
    return max;
}

fn maxInBank(bank: []const u8, a: std.mem.Allocator) !u64 {
    var strMax = try std.fmt.allocPrint(a, "00", .{});
    defer a.free(strMax);
    var index: u32 = 0;
    var startIdx: u32 = 0;

    print("bank: {s}\n", .{bank});

    while (index < bank.len - 1) {
        if (bank[index] > strMax[0]) {
            strMax[0] = bank[index];
            startIdx = index + 1;
            if (bank[index] == '9') {
                break;
            }
        }
        index += 1;
    }
    print("startidx: {d} ", .{startIdx});

    index = startIdx;
    while (index < bank.len) {
        if (bank[index] > strMax[1]) {
            strMax[1] = bank[index];
            if (bank[index] == '9') {
                break;
            }
        }
        index += 1;
    }

    print("max: {s}\n", .{strMax});

    const max: u64 = try std.fmt.parseInt(u64, strMax, 10);
    return max;
}
