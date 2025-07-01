const std = @import("std");
const clap = @import("clap");

// Void, but can return error.
pub fn main() !void {
    // Creating allocator and making it die after program closed.
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit(); // No leakz in my code!1!1

    // I have to use standard format.
    const params = comptime clap.parseParamsComptime(
        \\-h, --help display this text and exit.
        \\-i, --init create new b3t project.
        \\-s, --scan scan the project.
        \\-l, --list <str> show todo list.
        \\
    );

    // Not necessary, but some useful errors:
    var diag = clap.Diagnostic{};
    var res = clap.parse(clap.Help, &params, clap.parsers.default, .{
        .diagnostic = &diag,
        .allocator = gpa.allocator(),
    }) catch |err| {
        // Report useful error and exit.
        diag.report(std.io.getStdErr().writer(), err) catch {};
        return err;
    };
    defer res.deinit();

    // argument logic.
    if (res.args.help != 0) {
        try clap.usage(std.io.getStdErr().writer(), clap.Help, &params);
        std.debug.print("\n", .{});
        return clap.help(std.io.getStdErr().writer(), clap.Help, &params, .{});
    }
    if (res.args.scan != 0)
        std.debug.print("--scan\n", .{});
    //lol, i didn't know you can do this in zig, that's pretty cool.
    if (res.args.init != 0)
        std.debug.print("--init\n", .{});
    if (res.args.list) |s| //Catching S from argument
        std.debug.print("--list = {s}\n", .{s});
}
