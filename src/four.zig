const std = @import("std");
const print = std.debug.print;

pub fn q() !void {
    const cwd = std.fs.cwd();

    const file = try cwd.openFile("q4/input.txt", .{});
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

    // remove the final newline
    const res = try p1(content[0 .. content.len - 1], a);
    std.debug.print("res: {d}\n", .{res});
}

fn p1(content: []u8, a: std.mem.Allocator) !u64 {
    const delim: u8 = '\n';
    var iterator = std.mem.splitScalar(u8, content, delim);

    var list: std.ArrayList([]u8) = .empty;
    defer list.deinit(a);

    while (iterator.next()) |row| {
        // there's prob a better way but i need a mutable slice and am not adding / removing any memory from the row
        const mutable: []u8 = @constCast(row);
        try list.append(a, mutable);
    }

    var i: u16 = 0;
    var j: u16 = 0;
    var count: u16 = 0;
    var total: u16 = 0;
    var start: bool = true;

    //    print("len: {d}\n", .{list.items[138].len});
    //    print("row: {s}\n", .{list.items[138]});
    //    print("{c}", .{list.items[138][138]});
    while (start or count != 0) {
        count = 0;
        start = false;

        while (i < list.items.len) {
            j = 0;
            //            print("row: {d}, len: {d}\n", .{ i, list.items[i].len });
            while (j < list.items[i].len) {
                if (list.items[i][j] == '@' and detectValid(list.items, i, j, list.items.len, list.items[i].len)) {
                    count += 1;
                    list.items[i][j] = 'x';
                }

                j += 1;
            }
            // print("\n", .{});
            i += 1;
        }
        total += count;
        i = 0;
    }

    return total;
}

fn detectValid(map: [][]u8, indexx: u64, indexy: u64, boundx: u64, boundy: u64) bool {
    var count: u16 = 0;
    //    print("{d}, {d} -- {d}, {d}\n", .{ indexx, indexy, boundx, boundy });
    //    print("len: {d}, len2: {d}\n", .{ map.len, map[indexx].len });
    if (indexx != 0 and map[indexx - 1][indexy] == '@') {
        count += 1;
    }
    if (indexx + 1 < boundx and map[indexx + 1][indexy] == '@') {
        count += 1;
    }
    if (indexy != 0 and map[indexx][indexy - 1] == '@') {
        count += 1;
    }
    if (indexy + 1 < boundy and map[indexx][indexy + 1] == '@') {
        count += 1;
    }
    if (indexx != 0 and indexy != 0 and map[indexx - 1][indexy - 1] == '@') {
        count += 1;
    }
    if (indexx + 1 < boundx and indexy + 1 < boundy and map[indexx + 1][indexy + 1] == '@') {
        count += 1;
    }
    if (indexx + 1 < boundx and indexy != 0 and map[indexx + 1][indexy - 1] == '@') {
        count += 1;
    }
    if (indexx != 0 and indexy + 1 < boundy and map[indexx - 1][indexy + 1] == '@') {
        count += 1;
    }

    if (count < 4) {
        print("({d},{d})", .{ indexx, indexy });
    }

    return count < 4;
}
