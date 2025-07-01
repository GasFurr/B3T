const std = @import("std");
const microwave = @import("microwave");
const models = @import("models.zig");

// We are FHS compliant (and bad programmers)
// Some hardcoded paths. For now only linux, will be crossplatform someday.
pub fn config_path(allocator: std.mem.Allocator) ![]const u8 {
    const home_dir = std.os.getenv("HOME") orelse ""; // Get HOME environment variable, or empty string if not set

    // If HOME is not set, you might want to fall back to a default or return an error.
    // For now, let's assume it's set or handle an empty string gracefully.
    if (home_dir.len == 0) {
        std.debug.print("You don't have config.toml in your ~/.config/b3t/ dir\nOr you're not using linux. B3T is linux-only tool for now.\nStay tuned for updates!\n", .{});
        return error.HomeDirNotFound;
    }

    // Allocate enough space for the home directory, "/.config/b3t/config.toml", and the null terminator.
    const suffix = "/.config/b3t/config.toml";
    const path_len = home_dir.len + suffix.len;

    // Allocate memory for the full path
    var path_buffer = try allocator.alloc(u8, path_len);

    // Copy home directory
    std.mem.copy(u8, path_buffer, home_dir);
    // Append the suffix
    std.mem.copy(u8, path_buffer[home_dir.len..], suffix);

    return path_buffer;
}

// Read the config.
pub fn read_config() ![]const u8 {
    // Allocator setup
    const gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer gpa.deinit();

    // Getting config path using config_path();
    const path = try config_path(gpa.allocator());
    defer gpa.allocator().free(path);

    // Open the configuration.
    const file = try std.fs.cwd().openFile(path, .{});
    defer file.close();

    return file.readToEndAlloc(gpa.allocator(), usize);
}
