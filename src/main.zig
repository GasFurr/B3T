// Import files
const std = @import("std");
const util = @import("utils.zig");
const tables = @import("struct.zig");
const microwave = @import("microwave");
const handlers = @import("handlers.zig");
// Shortcuts
const print = std.debug.print;

// Some strange way for colored output
pub const red = "\x1b[31m";
pub const green = "\x1b[32m";
pub const yellow = "\x1b[33m";
pub const cyan = "\x1b[36m";
pub const reset = "\x1b[0m";

pub fn init(allocator: std.mem.Allocator) ![]const u8 {
    var buf: [4096]u8 = undefined;

    // getting path to binary
    const selfPath = try util.absolutePath(&buf);
    // init.toml should always be in the same folder as binary
    // and should always contain path to config.toml
    const initPath = try std.fs.path.join(allocator, &[_][]const u8{ selfPath, "init.toml" }); // Making from it path to init.toml
    // Open it and read.
    const initconf = try std.fs.cwd().openFile(initPath, .{ .mode = .read_only });
    defer initconf.close(); // Ensure the file is closed when done

    // Read the entire file into memory
    const raw_config_path = try initconf.readToEndAlloc(allocator, std.math.maxInt(usize));
    const configPath = std.mem.trim(u8, raw_config_path, " \t\n\r");
    // print("{s}selfPath:{s},\ninitPath:{s},\nconfigPath:{s}\n", .{ red, selfPath, initPath, configPath });
    // saved in case of debugging
    return configPath;
}

// Main function
pub fn main() !void {
    // Initializing arena allocator.
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    const configPath = try init(allocator);
    defer allocator.free(configPath);

    const args = try util.processArguments(allocator);
    defer allocator.free(args);

    const toml_content = std.fs.cwd().readFileAlloc(allocator, configPath, 1_000_000) catch |err| {
        handleFileError(err, configPath);
        return;
    };
    defer allocator.free(toml_content);

    const config = try microwave.Populate(tables.Config).createFromSlice(allocator, toml_content);
    defer config.deinit();

    // print("{s}Config pulled!{s}", .{ green, reset });
    // saved for debug purpose

    const cfg = config.value;
    const cmd = cfg.cmd;
    const cmp = std.mem.eql;

    // Now checking arguments

    // First - validate the number of arguments
    switch (args.len) {
        0 => try handlers.helpHandler(configPath, null),
        1...2 => {
            const arg: []const u8 = args[0];
            const value: ?[]const u8 = if (args.len > 1) args[1] else null;

            if (cmp(u8, arg, cmd.list)) {
                try handlers.listHandler(value);
            } else if (cmp(u8, arg, cmd.help)) {
                try handlers.helpHandler(configPath, value);
            } else {
                print("Unknown command.\n b3t {s} to list commands", .{cmd.help});
            }
        },
        else => try handlers.helpHandler(configPath, null),
    }
}

fn handleFileError(err: anyerror, configPath: []const u8) void {
    switch (err) {
        error.FileNotFound => {
            print("{s}ERROR:{s} Config file not found at {s}'{s}'{s}\n", .{ red, reset, yellow, configPath, reset });
            print("Check that:\n", .{});
            print("- The path is correct\n", .{});
            print("- File exists\n", .{});
            print("- You have read permissions{s}\n", .{"\n"});
        },
        error.AccessDenied => {
            print("{s}ERROR:{s} Permission denied for config file '{s}'{s}\n", .{ red, reset, configPath, reset });
        },
        else => {
            print("{s}ERROR:{s} Failed to read config file: {s}{s}\n", .{ red, reset, @errorName(err), reset });
        },
    }
}
