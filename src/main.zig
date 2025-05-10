// Import files
const std = @import("std");
const util = @import("utils.zig");
const tables = @import("struct.zig");
const microwave = @import("microwave");
const handlers = @import("handlers.zig");
// Shortcuts
const print = std.debug.print;
const hash = std.hash.Fnv1a_32.hash;

// Main function
pub fn main() !void {
    // Initializing GPA
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    // Setting up allocator up top of GPA.
    const allocator = gpa.allocator();

    var buf: [4096]u8 = undefined;

    // Retrieve arguments as a slice
    const args = try util.processArguments(allocator);
    defer allocator.free(args); // Free the memory when done

    // Constructing config path
    const absPath = try util.absolutePath(&buf);
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
    const cmp = std.mem.eql;

    const visualPath = try std.fs.path.join(allocator, &[_][]const u8{
        absPath,
        cfg.path.visual_dir,
    });
    defer allocator.free(visualPath);

    const templatesPath = try std.fs.path.join(allocator, &[_][]const u8{
        absPath,
        cfg.path.templates_dir,
    });
    defer allocator.free(templatesPath);

    // Validate argument count
    switch (args.len) {
        0 => {
            print("Not enough arguments", .{});
            print("paths:\n config: \n{s} \n visual: \n{s} \n templates: \n{s} \n", .{ configPath, visualPath, templatesPath });
            print("`b3t help` for list of all commands", .{});
        },
        1 => {
            const argument = args[0];
            // arg check

            // 1. scan
            // 2. help
            // 3. list1arg
            if (cmp(u8, argument, cfg.tools.scan_cmd)) {
                try handlers.scanHandler();
            } else if (cmp(u8, argument, cfg.tools.help_cmd)) {
                try handlers.helpHandler();
            } else if (cmp(u8, argument, cfg.tools.list_cmd)) {
                try handlers.globalListHandler();
            } else {
                print("command {s}: \nnot found/not enough arguments\n", .{argument});
            }
        },
        2 => {
            const argument = args[0];
            const subcmd = args[1];
            // arg check

            // 1. list
            // 2. init
            // 3. delete

            if (cmp(u8, argument, cfg.tools.list_cmd)) {
                try handlers.listHandler(subcmd);
            } else if (cmp(u8, argument, cfg.tools.init_cmd)) {
                try handlers.initHandler(subcmd);
            } else if (cmp(u8, argument, cfg.tools.delete_cmd)) {
                try handlers.deleteHandler(subcmd);
            } else {
                print("command {s}: \nnot found/not enough arguments\n", .{argument});
            }
        },
        3 => {
            const argument = args[0];
            const subcmd = args[1];
            const value = args[2];

            // 1. projects
            // 2. templates
            // 3. settings

            // command check
            if (cmp(u8, argument, cfg.tools.project.cmd)) {
                try handlers.projectHandler(subcmd, value);
            } else if (cmp(u8, argument, cfg.tools.template.cmd)) {
                try handlers.templateHandler(subcmd, value);
            } else if (cfg.tools.settings.enable == true) {
                if (std.mem.eql(u8, argument, cfg.tools.settings.cmd)) {
                    try handlers.settingsHandler(subcmd, value);
                } else {
                    print("command {s} not found\n", .{argument});
                }
            } else {
                print("command {s} not found\n", .{argument});
            }
        },
        else => {
            // program don't have commands with more than 3 arguments.
            print("command {s} not found\n", .{args[0]});
        },
    }
}
