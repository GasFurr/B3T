// Import files
const std = @import("std");
const util = @import("utils.zig");
const microwave = @import("microwave");
// Shortcuts
const comparestr = std.mem.eql;

// Configuration:

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
        1 => {},
        2 => {},
        3 => {
            const command = args[0]; // e.g., "template"
            const subcommand = args[1]; // e.g., "save"
            const filename = args[2]; // e.g., "mytemplate.toml"

            if (comparestr(
                u8,
                command,
            )) {}
        },
        else => {},
    }
}
