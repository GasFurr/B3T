// Import files
const std = @import("std");
const util = @import("utils.zig");
const configs = @import("struct.zig");
const microwave = @import("microwave");
// Shortcuts
const print = std.debug.print;

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

    // Validate argument count
    switch (args.len) {
        1 => {
            //const arg = args[0];

        },
        2 => {
            //const arg = args[0];
            //const subcmd = args[1];

        },
        3 => {
            //const arg = args[0];
            //const subcmd = args[1];
            //const value = args[2];

        },
        else => {
            // Program don't have commands with more than 3 arguments.
            print("Command {s} not found", .{args[0]});
        },
    }

    // Example usage with TOML parser (future integration)
    print(
        "Command: {s}, Subcommand: {s}, File: {s}\n",
        .{ command, subcommand, filename },
    );
}
