const std = @import("std");
const microwave = @import("microwave");
const utils = @import("utils.zig");
const models = @import("models.zig");

// Easiest command - init.
pub fn init_handler(name: []const u8, template: ?[]const u8) !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    // Forming path to template.
    const template_name = template orelse "default";
    const templates_root = try utils.resolve_home(allocator, "/.config/b3t/config/templates");
    defer allocator.free(templates_root);

    const template_path = try std.fmt.allocPrint(allocator, "{s}/{s}.toml", .{ templates_root, template_name });
    defer allocator.free(template_path);

    // Reading and parsing
    const template_data = try utils.read_file(allocator, template_path);
    defer allocator.free(template_data);

    const template_doc = try microwave.parseFromSlice(allocator, template_data);
    defer template_doc.deinit();

    // Filling the structure (arena for lifetime control)
    var project_struct: models.Template = undefined;
    var arena = try microwave.Populate(models.Template).intoFromTable(
        allocator,
        &project_struct,
        template_doc.table,
    );
    defer arena.deinit();

    // Modifying project name
    project_struct.project.name = name;

    // Creating file in CWD.
    const file = std.fs.cwd().createFile("b3t.toml", .{ .exclusive = true }) catch |err| {
        if (err == error.PathAlreadyExists) {
            std.debug.print("b3t.toml already exists. Skipping.\n", .{});
            return;
        }
        return err;
    };
    defer file.close();

    // Creating buffer in stack.
    var write_buffer: [4096]u8 = undefined;

    // Initializing new Writer interface
    var file_writer = file.writer(&write_buffer);

    // Getting a pointer to interface
    const writer = &file_writer.interface;

    // Writing into file.
    var write_stream: microwave.WriteStream = .{
        .allocator = allocator,
        .writer = writer,
    };
    defer write_stream.deinit();

    var stringify: microwave.Stringify = .{
        .key_allocator = allocator,
        .stream = &write_stream,
    };
    defer stringify.deinit();

    try stringify.write(project_struct);

    // 5. КРИТИЧЕСКИ ВАЖНО: Don't forget to flush!
    // Теперь flush() вызывается прямо у интерфейса.
    try writer.flush();

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
