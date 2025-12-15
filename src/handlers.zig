const std = @import("std");
const microwave = @import("microwave");
const utils = @import("utils.zig");

// Easiest command - init.
pub fn init_handler(name: []const u8, template: ?[]const u8) !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    // Getting cwd
    const cwd = try std.process.getCwdAlloc(allocator);
    defer allocator.free(cwd);
    std.debug.print("Current Working Directory {s}\n", .{cwd});

    // Create b3t.toml
    const file = std.fs.cwd().createFile("b3t.toml", .{ .read = true, .exclusive = true }) catch |err| {
        std.debug.print("Caught an error while init'ing a project:\n", .{});
        std.debug.print("{}\n", .{err});
        if (err == error.PathAlreadyExists) {
            // Handle existing file case
            std.debug.print("b3t.toml already exists. Skipping creation.\n", .{});
        }
        return;
    };
    defer file.close();

    std.debug.print("Project Name: {s}\n", .{name});

    const templates_path: []const u8 = try utils.resolve_home(allocator, "/.config/b3t/config/templates");

    if (template) |t| {
        std.debug.print("Using template: {s}\n", .{t});
        // TODO: Load template file and use it to create b3t.toml
    } else {
        std.debug.print("Using default template\n", .{});
        const default_template: []const u8 = try utils.read_config(allocator, try std.fmt.allocPrint(allocator, "{s}/default.toml", .{templates_path}));
        try file.writeAll(default_template);
        defer allocator.free(default_template);
        // TODO: Use default template
    }

    // TODO: add resulted path into data/index.toml

}

// List handler
pub fn list_handler(arg: []const u8) !void {
    // Create general purpose allocator. (obvious)
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    // Create arena for temporary allocations (auto-freed at end of block)
    var arena = std.heap.ArenaAllocator.init(allocator);
    defer arena.deinit();
    const arena_alloc = arena.allocator();

    // Get all paths and data
    const config_dir = try utils.config_dir(arena_alloc);
    const config_path = try utils.config_path(arena_alloc);
    const config = try utils.read_config(arena_alloc, config_path);
    const index_dir = try utils.data_dir(arena_alloc);
    const index_path = try utils.index_path(arena_alloc);
    const index = try utils.read_index(arena_alloc, index_path);

    if (std.mem.eql(u8, arg, "config")) {
        // Print output
        std.debug.print(
            \\# paths:
            \\{s}
            \\{s}
            \\{s}
            \\{s}
            \\
            \\# index.toml
            \\{s}
            \\
            \\# config.toml
            \\{s}
            \\
        , .{
            config_dir,
            config_path,
            index_dir,
            index_path,
            index,
            config,
        });
    } else return;
}

pub fn scan_handler() !void {
    // Should be the hardest.
}

pub fn delete_handler(arg: []const u8) !void {
    // Needs data architecture
    _ = arg;
}
