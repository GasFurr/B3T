const std = @import("std");
const clap = @import("clap");
const handler = @import("handlers.zig");

// Void, but can return error.
pub fn main() !void {
    // Creating allocator and making it die after program closed.
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit(); // No leakz in my code!1!1

    // Create buffer and writer for stderr (for diagnostics)
    var stderr_buffer: [4096]u8 = undefined;
    var stderr_writer = std.fs.File.stderr().writer(&stderr_buffer);
    const stderr = &stderr_writer.interface;

    // Create buffer and writer for stdout (for normal output)
    var stdout_buffer: [4096]u8 = undefined;
    var stdout_writer = std.fs.File.stdout().writer(&stdout_buffer);
    const stdout = &stdout_writer.interface;

    // I have to use standard format.
    const params = comptime clap.parseParamsComptime(
        \\-h, --help display this text and exit.
        \\-i, --init <str> create new b3t project.
        \\-s, --scan scan the project.
        \\-l, --list <str> show todo list.
        \\-d, --delete <str> delete the project.
        \\
    );

    // Not necessary, but some useful errors:
    var diag = clap.Diagnostic{};
    var res = clap.parse(clap.Help, &params, clap.parsers.default, .{
        .diagnostic = &diag,
        .allocator = gpa.allocator(),
    }) catch |err| {
        // Report to stderr (for errors)
        try diag.report(stderr, err);
        try stderr.flush(); // Don't forget to flush!
        return;
    };
    defer res.deinit();

    // argument logic.
    if (res.args.help != 0) {
        try clap.help(stdout, clap.Help, &params, .{});
        try stdout.flush();
        return;
    }
    if (res.args.scan != 0)
        std.debug.print("--scan\n", .{});
    //lol, i didn't know you can do this in zig, that's pretty cool.
    if (res.args.init) |s|
        try handler.init_handler(s);
    if (res.args.list) |s| //Catching S from argument
        try handler.list_handler(s);
    if (res.args.delete) |s| //Catching S from argument
        try handler.delete_handler(s);
}
