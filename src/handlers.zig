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
        if (err == error.PathAlreadyExists) {
            // Handle existing file case
            std.debug.print("b3t.toml already exists. Skipping creation.\n", .{});
        } else {
            return err;
        }
        return;
    };
    defer file.close();

    std.debug.print("Project Name: {s}\n", .{name});

    const templates_path: []const u8 = try utils.resolve_home(allocator, "/.config/b3t/config/templates");
    defer allocator.free(templates_path);

    // OOOHHHH, this code SUCKS!
    // rewrite this shit later, why delete b3t.toml
    // if we can just NOT CREATE IT IN THE FIRST PLACE.
    //
    // Later validate all data before I/O operations.
    // Yes, on this scale the performance overhead is negligable,
    // but it's generally a good practice to minimize I/O operations.

    if (template) |t| {
        std.debug.print("Using template: {s}\n", .{t});
        // TODO: Load template file and use it to create b3t.toml

        const template_path: []const u8 = try std.fmt.allocPrint(
            allocator,
            "{s}/{s}.toml",
            .{ templates_path, t },
        );

        defer allocator.free(template_path);

        const template_file = utils.read_config(allocator, template_path) catch |err| switch (err) {
            error.FileNotFound => {
                std.debug.print("Error: Template '{s}' not found.\n", .{t});
                // TODO: try listAvailableTemplates(templates_path);
                try std.fs.cwd().deleteFile("b3t.toml");
                return;
            },
            else => |e| {
                std.debug.print("Error reading template: {}\n", .{e});
                return e;
            },
        };
        defer allocator.free(template_file);

        try file.writeAll(template_file);

        defer allocator.free(template_file);
    } else {
        std.debug.print("Using default template\n", .{});

        const default_path: []const u8 = try std.fmt.allocPrint(
            allocator,
            "{s}/default.toml",
            .{templates_path},
        );

        const default_template: []const u8 = try utils.read_config(allocator, default_path);
        // trying to write default_tepmplate to b3t.toml
        try file.writeAll(default_template);

        defer allocator.free(default_template);
        defer allocator.free(default_path);
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
