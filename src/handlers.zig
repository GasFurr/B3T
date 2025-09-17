const std = @import("std");
const microwave = @import("microwave");
const utils = @import("utils.zig");

// Easiest command - init.
pub fn init_handler() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    // Okay, we have a new way.
    // 1. Creating b3t.toml by the template
    // 2. Adding indexing to data/index.toml
    // 3. Creating project.toml in data/projects

    const cwd = try utils.get_cwd(allocator);
    std.debug.print("Current Working Directory {s}", .{cwd});
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
    const config = try utils.read_config(arena_alloc);
    const config_dir = try utils.config_dir(arena_alloc);
    const config_path = try utils.config_path(arena_alloc);
    const index = try utils.read_index(arena_alloc);
    const index_dir = try utils.data_dir(arena_alloc);
    const index_path = try utils.index_path(arena_alloc);

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
