const std = @import("std");
const microwave = @import("microwave");
const utils = @import("utils.zig");
const models = @import("models.zig");

// Easiest command - init.
pub fn init_handler(name: []const u8, template: ?[]const u8) !void {
    // Setting up GPA as debug allocator;
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    // Setting up arena allocator for the function
    // there's just too much microoperations inside this function anyway.
    var arena_allocator = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena_allocator.deinit();
    const arena = arena_allocator.allocator();

    // current working directory;
    const cwd = try std.fs.cwd().realpathAlloc(arena, ".");

    // Forming path to template.
    const template_name = template orelse "default";
    const templates_root = try utils.resolve_home(arena, "/.config/b3t/config/templates");

    const template_path = try std.fmt.allocPrint(arena, "{s}/{s}.toml", .{ templates_root, template_name });

    // Reading and parsing
    const template_data = try utils.read_file(arena, template_path);

    // explicit GPA and deinit;
    const template_doc = try microwave.parseFromSlice(allocator, template_data);
    defer template_doc.deinit();

    // Filling the structure (arena for lifetime control)
    var project_struct: models.Template = undefined;
    var struct_arena = try microwave.Populate(models.Template).intoFromTable(
        allocator,
        &project_struct,
        template_doc.table,
    );
    defer struct_arena.deinit();

    // Modifying project name
    project_struct.project.name = name;
    // Indexing project path;
    const project_path = try std.fmt.allocPrint(arena, "{s}/b3t.toml", .{cwd});

    var index_struct: models.Data = undefined;
    index_struct.path = project_path;

    // --- I/O section ---

    // indexation logic.
    // creating indexation name using project name.
    const index_name = try std.fmt.allocPrint(arena, "{s}.toml", .{name});
    const data_dir = try utils.resolve_home(arena, "/.config/b3t/data/");
    const index_path = try std.fmt.allocPrint(arena, "{s}{s}", .{ data_dir, index_name });

    // creating file...
    const index = std.fs.createFileAbsolute(index_path, .{ .exclusive = true }) catch |err| {
        if (err == error.PathAlreadyExists) {
            std.debug.print("Project already exists!", .{});
            return;
        }
        return err;
    };
    defer index.close();
    // We're doing indexation logic before local b3t.toml logic so if there's
    // already project with the same name it would catch an error as PathAlreadyExists,

    // Creating file in CWD.
    const file = std.fs.cwd().createFile("b3t.toml", .{ .exclusive = true }) catch |err| {
        if (err == error.PathAlreadyExists) {
            std.debug.print("b3t.toml already exists. Skipping.\n", .{});
            return;
        }
        return err;
    };
    defer file.close();

    // --- R/W operations ---

    // Creating buffer in stack.
    var write_buffer: [4096]u8 = undefined;

    // Initializing new Writer interface
    var file_writer = file.writer(&write_buffer);

    // Getting a pointer to interface
    const file_writer_interface = &file_writer.interface;

    // Writing into file.
    var file_write_stream: microwave.WriteStream = .{
        .allocator = allocator,
        .writer = file_writer_interface,
    };
    defer file_write_stream.deinit();

    var file_stringify: microwave.Stringify = .{
        .key_allocator = allocator,
        .stream = &file_write_stream,
    };
    defer file_stringify.deinit();

    try file_stringify.write(project_struct);

    // indexation logic

    var index_writer = index.writer(&write_buffer);

    const index_writer_interface = &index_writer.interface;

    var index_write_stream: microwave.WriteStream = .{
        .allocator = allocator,
        .writer = index_writer_interface,
    };
    defer index_write_stream.deinit();

    var index_stringify: microwave.Stringify = .{
        .key_allocator = allocator,
        .stream = &index_write_stream,
    };
    defer index_stringify.deinit();

    // writing index structure;
    try index_stringify.write(index_struct);

    // and don't forget to flush.
    try file_writer_interface.flush();
    try index_writer_interface.flush();

    // That's it.
    std.debug.print("Project '{s}' initialized successfully.\n", .{name});
}

// List handler
pub fn list_handler(arg: []const u8) !void {
    // Create general purpose allocator. (obvious)
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    // Create arena for temporary allocations (auto-freed at end of block)
    var arena = std.heap.ArenaAllocator.init(allocator);
    defer arena.deinit();
    const arena_alloc = arena.allocator();

    // Get all paths and data
    const config_dir = try utils.config_dir(arena_alloc);
    const config_path = try utils.config_path(arena_alloc);
    const config = try utils.read_file(arena_alloc, config_path);
    const index_dir = try utils.data_dir(arena_alloc);
    const index_path = try utils.index_path(arena_alloc);
    const index = try utils.read_file(arena_alloc, index_path);

    if (std.mem.eql(u8, arg, "config")) {
        // Print output
        std.debug.print(
            \\# paths:
            \\{s}
            \\{s}
            \\{s}
            \\{s}
            \\
            \\# index.toml
            \\{s}
            \\
            \\# config.toml
            \\{s}
            \\
        , .{
            config_dir,
            config_path,
            index_dir,
            index_path,
            index,
            config,
        });
    } else return;
}

pub fn scan_handler() !void {
    // Should be the hardest.
}

pub fn delete_handler(arg: []const u8) !void {
    // Needs data architecture
    _ = arg;
}

// Projects list
pub fn projects_handler() !void {
    // Projects list
}
