// Some utilities not rrelated to toml
const std = @import("std");
// Pass allocator easier
const Allocator = std.mem.Allocator;


// Returns a slice of argument strings (allocated with the provided allocator)
pub fn processArguments(allocator: std.mem.Allocator) ![][]const u8 {
    var args_iter = try std.process.argsWithAllocator(allocator);
    defer args_iter.deinit();

    var args_list = std.ArrayList([]const u8).init(allocator);
    defer args_list.deinit(); // Optional: Only if you modify the list later

    // Skip the first argument (program name)
    _ = args_iter.next();

    // Collect arguments into the list
    while (args_iter.next()) |arg| {
        try args_list.append(arg);
    }

    // Transfer ownership of the slice to the caller
    return args_list.toOwnedSlice();
}

// Lowercases the string 
pub fn minimize(allocator: Allocator, input: []const u8) ![]u8 {
    var result = try allocator.alloc(u8, input.len);
    for (input, 0..) |char, i| {
        result[i] = switch (char) {
            'A'...'Z' => char + 32, // Convert to lowercase
            else => char, // Leave non-letters unchanged
        };
    }
    return result;
}

// Uppercases the string 
pub fn capitalize(allocator: Allocator, input: []const u8) ![]u8 {
    var result = try allocator.alloc(u8, input.len);
    for (input, 0..) |char, i| {
        result[i] = switch (char) {
            'a'...'z' => char - 32, // Convert to uppercase
            else => char, // Leave non-letters unchanged
        };
    }
    return result;
}
