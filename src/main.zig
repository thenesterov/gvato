const std = @import("std");
const Io = std.Io;

const build_options = @import("build_options");

pub fn main(init: std.process.Init) !void {
    _ = init;
    std.debug.print("Hello, world! {s}\n", .{build_options.version});
}

