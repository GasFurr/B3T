const std = @import("std");
const tables = @import("struct.zig");
const microwave = @import("microwave");

const print = std.debug.print;

// 1 arg handlers:

pub fn helpHandler(absPath: []const u8) !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    // Setting up allocator up top of GPA.
    const allocator = gpa.allocator();

    // Constructing config path
    const configPath = try std.fs.path.join(allocator, &[_][]const u8{
        absPath,
        "config",
        "settings.toml",
    });
    defer allocator.free(configPath);

    const toml_content = try std.fs.cwd().readFileAlloc(allocator, configPath, 1_000_000);
    defer allocator.free(toml_content);

    const config = try microwave.Populate(tables.Config).createFromSlice(allocator, toml_content);
    defer config.deinit();

    const cfg = config.value;

    print("Absolute config path: \n{s}", .{configPath});
    print("\nCommands:", .{});
    print("{s} - Show this list\n", .{cfg.tools.help_cmd});
    print("{s} - Scan project directory\n", .{cfg.tools.scan_cmd});
    print("{s} (arg1: project_name) - Create project\n", .{cfg.tools.init_cmd});
    print("{s} (arg1: project_name) - Show task list\n", .{cfg.tools.list_cmd});
    print("Without arguments prints list of active projects", .{});
    print("{s} (arg1: project_name) - delete project", .{cfg.tools.delete_cmd});
}

pub fn scanHandler() !void {}

pub fn globalListHandler() !void {}

// 2 arg handlers

pub fn initHandler(name: []const u8) !void {
    _ = name; // Do not hash!
}

pub fn listHandler(project: []const u8) !void {
    _ = project; // Do not hash!
}

pub fn deleteHandler(project: []const u8) !void {
    _ = project; // Do not hash!
}
