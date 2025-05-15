const std = @import("std");
const builtin = @import("builtin");
const main = @import("main.zig"); // Just for colours, lol
const tables = @import("struct.zig");
const render = @import("render.zig"); // Render engine.
const microwave = @import("microwave");

const print = std.debug.print;
const fs = std.fs;
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
    // check for init_scan setting.
    // Scans current directory according to b3t.toml
    // recursively reads all files inside of project dir.
    // parse all lines that starts with template's project.parse
    // writes data to projectname.project
}

// 2 arg handlers

pub fn initHandler(template: ?[]const u8, dataPath: []const u8) !void {
    // checks for scan_init setting.
    // Creates two files:
    // b3t.toml
    // projectname.project
    // adds projectname_list and projectname_path to [projects] in data.toml.
    // reads template and writes it to b3t.toml
    _ = template;
    _ = dataPath;
}

pub fn listHandler(argument: ?[]const u8, dataPath: []const u8, configPath: []const u8) !void {
    const unwrap = argument.?;

    // if argument == null list all projects.
    // if argument == config list all settings.toml variables
    // --- normal ---
    // Check if there's projectname.list file
    // if not - send projectname.project file to render engine
    // Then just print contents of projectname.list
    // --- null ---
    // just prints names of all avaliable .project files.
    // --- settings ---
    // just print settings.toml contents ignoring all comments.

    if (argument == null) {
        var gpa = std.heap.GeneralPurposeAllocator(.{}){};
        const allocator = gpa.allocator();
        defer _ = gpa.deinit();

        const resolved_path = try resolveTildePath(allocator, dataPath);
        defer allocator.free(resolved_path);

        var dir = try fs.cwd().openDir(resolved_path, .{ .iterate = true });
        defer dir.close();

        var components = std.ArrayList([]const u8).init(allocator);
        defer components.deinit();

        print("Projects:\n", .{});
        try listProjects(dir, &components, allocator);
    }
    if (std.mem.eql(u8, unwrap, "config")) {
        var gpa = std.heap.GeneralPurposeAllocator(.{}){};
        const allocator = gpa.allocator();
        defer _ = gpa.deinit();

        const resolvedPath = try resolveTildePath(allocator, configPath);
        defer allocator.free(resolvedPath);

        const config = try std.fs.openFileAbsolute(resolvedPath, .{ .mode = .read_only });
        defer config.close();

        const contents = try std.fs.File.readToEndAlloc(config, allocator, std.math.maxInt(usize));
        defer allocator.free(contents);

        print("{s}", .{contents});
    } else {}
}

pub fn deleteHandler(project: ?[]const u8, dataPath: []const u8) !void {
    // Read data.toml and try to find projectname_list
    // if project not found - say about it
    // if project found - read paths, delete files on this paths and then delete the paths from data.toml.
    _ = project;
    _ = dataPath;
}

pub fn renameHandler(dataPath: []const u8) !void {
    // Will ask for old project name and new project name.
    // then replace name fileds in old files and rename them.
    // then delete old projectname_list and projectname_path with new ones.
    // I don't really know how it will work.
    _ = dataPath;
}

fn listProjects(dir: fs.Dir, components: *std.ArrayList([]const u8), allocator: std.mem.Allocator) !void {
    var iter = dir.iterate();
    const ext = ".project";
    while (try iter.next()) |entry| {
        if (entry.kind == .directory) {
            // Recurse into subdirectories (but don't track components)
            var subdir = try dir.openDir(entry.name, .{ .iterate = true });
            defer subdir.close();
            try listProjects(subdir, components, allocator);
        } else {
            // Check if the filename ends with ".project"
            if (std.mem.endsWith(u8, entry.name, ext)) {
                // Trim the ".project" extension from the filename
                const basename = entry.name[0 .. entry.name.len - ext.len];
                print("{s}\n", .{basename});
            }
        }
    }
}

fn resolveTildePath(allocator: std.mem.Allocator, path: []const u8) ![]const u8 {
    if (std.mem.startsWith(u8, path, "~/")) {
        // Get home directory from environment
        const home_dir = try getHomeDir(allocator);
        defer allocator.free(home_dir);

        // Join home directory with the rest of the path (after "~/")
        return fs.path.join(allocator, &.{ home_dir, path[2..] });
    } else if (std.mem.eql(u8, path, "~")) {
        // Handle standalone "~"
        return getHomeDir(allocator);
    } else {
        // Return the path as-is if no tilde is present
        return allocator.dupe(u8, path);
    }
}

fn getHomeDir(allocator: std.mem.Allocator) ![]const u8 {
    const home_var = if (builtin.os.tag == .windows) "USERPROFILE" else "HOME";
    return std.process.getEnvVarOwned(allocator, home_var) catch |err| {
        std.log.err("Failed to read {s} environment variable: {s}", .{ home_var, @errorName(err) });
        return error.HomeDirNotFound;
    };
}
