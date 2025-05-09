// Import files
const std = @import("std");
const util = @import("utils.zig");
const microwave = @import("microwave");

// Main function
pub fn main() !void {
    // Initializing GPA
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    // Setting up allocator up top of GPA.
    const allocator = gpa.allocator();

    // Retrieve arguments as a slice
    const args = try util.processArguments(allocator);
    defer allocator.free(args); // Free the memory when done

    // Example usage:
    for (args) |arg| {
        const capt = try util.capitalize(allocator, arg);
        std.debug.print("Argument: {s}\n", .{capt});
        defer allocator.free(capt);
    }
}
