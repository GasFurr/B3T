// All structures
const std = @import("std");

// Configuration
pub const Config = struct {
    cmd: struct {
        init: []const u8,
        list: []const u8,
        scan: []const u8,
        help: []const u8,
        delete: []const u8,
        rename: []const u8,
    },
    dir: struct {
        data: []const u8,
        visual: []const u8,
        templates: []const u8,
    },
    env: struct {
        skin: []const u8,
        template: []const u8,
    },
    project: struct {
        init_file: []const u8,
        scan_init: bool,
        autoignore: bool,
    },
};

pub const Template = struct {
    template_name: []const u8,
    project: struct {
        name: []const u8,
        ignore: ?[]const []const u8,
        parse: []const u8,
    },
    priorities: ?struct {
        name: ?[]const []const u8,
        level: ?[]const u32,
        flag: ?[]const u8,
    },
};

pub const Skin = struct {
    name: []const u8,
    sections: struct {
        header: bool,
        task: bool,
        number: bool,
        priority: bool,
        line: bool,
        separator: bool,
    },
    header: struct {
        separator: ?[]const u8,
        prefix: []const u8,
        postfix: []const u8,
        capitalized: bool,
    },
    task: struct {
        separator: ?[]const u8,
        prefix: []const u8,
        postfix: []const u8,
        capitalized: bool,
    },
    number: struct {
        separator: ?[]const u8,
        prefix: []const u8,
        postfix: []const u8,
        before_priority: bool,
    },
    priority: struct {
        prefix: []const u8,
        postfix: []const u8,
        capitalized: bool,
    },
    line: struct {
        separator: ?[]const u8,
        prefix: []const u8,
        postfix: []const u8,
        number_prefix: []const u8,
        number_postfix: []const u8,
        num_before_file: bool = false,
    },
};
