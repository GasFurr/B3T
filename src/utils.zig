const std = @import("std");
const microwave = @import("microwave");
const models = @import("models.zig");
const fs = std.fs;

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

pub fn read_config(allocator: std.mem.Allocator, path: []const u8) ![]u8 {
    var file = try std.fs.cwd().openFile(path, .{ .mode = .read_only });
    defer file.close();

    const file_size = (try file.stat()).size;

    // Allocate exactly what we need
    const content = try allocator.alloc(u8, file_size);
    errdefer allocator.free(content);

    var threaded: std.Io.Threaded = .init_single_threaded;
    const io = threaded.io();
    // In the new API, file.reader() takes the buffer directly!
    var file_reader = file.reader(io, content);

    // .fill(n) tells the reader to fill the internal buffer with n bytes
    try file_reader.interface.fill(file_size);

    return content;
}

pub fn read_index(allocator: std.mem.Allocator, path: []const u8) ![]u8 {
    var file = try std.fs.cwd().openFile(path, .{ .mode = .read_only });
    defer file.close();

    var threaded: std.Io.Threaded = .init_single_threaded;
    const io = threaded.io();

    var read_buf: [4096]u8 = undefined;
    var f_reader = file.reader(io, &read_buf);

    // Using the modern Allocating writer
    var list = std.Io.Writer.Allocating.init(allocator);
    errdefer list.deinit();

    _ = try f_reader.interface.streamRemaining(&list.writer);

    // Return the slice. Because it's from an Arena,
    // we don't need to return the 'list' object itself,
    // just the bytes.
    return list.written();
}
