const std = @import("std");
const main = @import("main.zig"); // Just for colours, lol
const tables = @import("struct.zig");
const render = @import("render.zig"); // Render engine.
const microwave = @import("microwave");

const print = std.debug.print;

// 1 arg handlers:

pub fn helpHandler(configPath: []const u8, arg: ?[]const u8) !void {
    const compare = std.mem.eql;

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    // Constructing config path
    const toml_content = try std.fs.cwd().readFileAlloc(allocator, configPath, 1_000_000);
    defer allocator.free(toml_content);

    const config = try microwave.Populate(tables.Config).createFromSlice(allocator, toml_content);
    defer config.deinit();

    const help = config.value.cmd;
    // const path = config.value.dir;
    const proj = config.value.project;
    // const env = config.value.project;

    if (arg == null) {
        print("\nCommands:\n", .{});
        print("1.b3t {s}{s}{s} - Scan directory (b3t {s} {s} for more info)\n", .{ main.cyan, help.scan, main.reset, help.help, help.scan });
        print("2.b3t {s}{s}{s} optional: [command] {s}- Show this list or explain the command\n", .{ main.cyan, help.help, main.yellow, main.reset });
        print("3.b3t {s}{s}{s} optional: [template] {s}- Create project\n", .{ main.cyan, help.init, main.yellow, main.reset });
        print("4.b3t {s}{s}{s} optional: [project name] {s}- Show task list\n", .{ main.cyan, help.list, main.yellow, main.reset });
        print("5.b3t {s}{s}{s} required: [project name] {s}- delete project\n", .{ main.cyan, help.delete, main.yellow, main.reset });
        print("6.b3t {s}{s}{s} required: [new name] {s} - rename project\n", .{ main.cyan, help.rename, main.yellow, main.reset });
    } else {
        const unwrap = arg.?;

        if (compare(u8, unwrap, help.help)) {
            print("\nI thought it should be self-explainatory.", .{});
            print("\n{s}b3t {s}{s} [command] {s}- show information about comand\n", .{ main.cyan, help.help, main.yellow, main.reset });
        } else if (compare(u8, unwrap, help.scan)) {
            print("\n{s}b3t {s} {s}- scans current directory for the project", .{ main.cyan, help.scan, main.reset });
            print("\nif {s}{s}{s} project config found - scan according it", .{ main.yellow, proj.init_file, main.reset });
            print("\nif {s}{s}{s} file not found - checks for scan_init rule", .{ main.yellow, proj.init_file, main.reset });
            print("\nif scan_init = true it creates project with default config\n", .{});
        } else if (compare(u8, unwrap, help.list)) {
            print("\n{s}b3t {s}{s} [project] {s}- prints todo-list for the project.", .{ main.cyan, help.list, main.yellow, main.reset });
            print("\nWithout{s} [project] {s}argument prints list of projects\n", .{ main.yellow, main.reset });
        } else if (compare(u8, unwrap, help.init)) {
            print("\n{s}b3t {s}{s} [template] {s}- create new project using template.", .{ main.cyan, help.init, main.yellow, main.reset });
            print("\nWithout{s} [template] {s}argument uses default template (see settings.toml)\n", .{ main.yellow, main.reset });
        } else if (compare(u8, unwrap, help.delete)) {
            print("\n{s}b3t {s}{s} [project name] {s}- deletes the project.\n", .{ main.cyan, help.delete, main.yellow, main.reset });
        } else if (compare(u8, unwrap, help.rename)) {
            print("\n{s}b3t {s}{s}- renames project.", .{ main.cyan, help.rename, main.reset });
        } else {
            return;
        }
    }
}

pub fn scanHandler() !void {
    // Scans current directory according to b3t.toml
    // recursively reads all files inside of project dir.
    // parse all lines that starts with template's project.parse
    // writes data to projectname.project
}

// 2 arg handlers

pub fn initHandler(template: ?[]const u8) !void {
    // Creates two files:
    // b3t.toml
    // projectname.project
    // adds projectname_list and projectname_path to [projects] in data.toml.
    // reads template and writes it to b3t.toml
    _ = template;
}

pub fn listHandler(argument: ?[]const u8) !void {
    _ = argument;
    // if argument == null list all projects.
    // if argument == settings list all settings.toml variables
    // --- normal ---
    // Check if there's projectname.list file
    // if not - send projectname.project file to render engine
    // Then just print contents of projectname.list
    // --- null ---
    // just prints names of all avaliable .project files.
    // --- settings ---
    // just print settings.toml contents.
}

pub fn deleteHandler(project: ?[]const u8) !void {
    // Read data.toml and try to find projectname_list
    // if project not found - say about it
    // if project found - read paths, delete files on this paths and then delete the paths from data.toml.
    _ = project;
}

pub fn renameHandler() !void {
    // Will ask for old project name and new project name.
    // then replace name fileds in old files and rename them.
    // then delete old projectname_list and projectname_path with new ones.
    // I don't really know how it will work.
}
