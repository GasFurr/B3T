const std = @import("std");
const microwave = @import("microwave");
const utils = @import("utils.zig");

// Easiest command - init.
pub fn init_handler() !void {
    // Basically create file according to template
    // All data thingies i will handle later
    // Needs data architecture.
}

// List handler
pub fn list_handler(arg: []const u8) !void {
    // Needs render engine
    _ = arg;
}

pub fn scan_handler() !void {
    // Should be the hardest.
}

pub fn delete_handler(arg: []const u8) !void {
    // Needs data architecture
    _ = arg;
}
