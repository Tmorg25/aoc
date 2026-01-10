const std = @import("std");
const q = @import("three.zig");

pub fn main() !void {
    // Prints to stderr, ignoring potential errors.
    try q.q();
}
