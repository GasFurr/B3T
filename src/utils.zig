const std = @import("std");
const microwave = @import("microwave");
const models = @import("models.zig");

// Variables:

// Path helper functions (not global constants!)
pub fn config_dir(allocator: std.mem.Allocator) ![]const u8 {
    return resolve_home(allocator, "/.config/b3t/");
}

pub fn config_path(allocator: std.mem.Allocator) ![]const u8 {
    return resolve_home(allocator, "/.config/b3t/config.toml");
}

pub fn data_dir(allocator: std.mem.Allocator) ![]const u8 {
    return resolve_home(allocator, "/.config/b3t/data");
}

pub fn index_path(allocator: std.mem.Allocator) ![]const u8 {
    return resolve_home(allocator, "/.config/b3t/data/index.toml");
}

/// Resolves a path relative to the user's home directory.
///
/// # Parameters
/// - `allocator`: memory allocator of the caller.
/// - `suffix`: Path to append (must start with '/')
///
/// # Returns
/// Heap-allocated resolved path (caller must free with `allocator`)
///
/// # Errors
/// Returns `error.HomeDirNotFound` if HOME environment variable is unset
///
/// # Example
/// ```zig
/// const path = try resolve_home(allocator, "/.config/b3t/config.toml");
/// defer allocator.free(path);
/// ```
pub fn resolve_home(allocator: std.mem.Allocator, suffix: []const u8) ![]const u8 {
    const home_dir = std.posix.getenv("HOME") orelse return error.HomeDirNotFound;
    return std.fs.path.join(allocator, &[_][]const u8{ home_dir, suffix });
}

// BROO, zig 0.15 broken it all :(((
// i need to rewrite it again.

pub fn read_config(allocator: std.mem.Allocator) ![]const u8 {
    const path = try config_path(allocator);
    defer allocator.free(path);

    const file = try std.fs.cwd().openFile(path, .{});
    defer file.close();

    return file.read(allocator);
}

pub fn read_index(allocator: std.mem.Allocator) ![]u8 {
    const path = try index_path(allocator);
    defer allocator.free(path);

    const file = try std.fs.cwd().openFile(path, .{});
    defer file.close();

    return file.read(allocator, std.math.maxInt(usize));
}
