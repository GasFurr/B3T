// All structures
const std = @import("std");

// Configuration
pub const Config = struct {
    Tools: struct {
        initCmd: []const u8,
        listCmd: []const u8,
        scanCmd: []const u8,
        deleteCmd: []const u8,
        Template: struct {
            cmd: []const u8,
            save: []const u8,
            delete: []const u8,
        },
        Settings: struct {
            enable: bool,
            cmd: []const u8,
            set: []const u8,
            init: []const u8,
            save: []const u8,
        },
        Project: struct {
            cmd: []const u8,
            delete: []const u8,
            exprt: []const u8,
        },
    },
    Path: struct {
        templatesDir: []const u8,
        visualDir: []const u8,
        dataDir: []const u8,
        dataFile: []const u8,
        defaultsConfig: []const u8,
        projectsFile: []const u8,
        projectsDir: []const u8,
    },
    Env: struct {
        skin: []const u8,
        template: []const u8,
    },
    Project: struct {
        initFile: []const u8,
        autoBase: bool,
        autoGitignore: bool,
    },
};

pub const Template = struct {
    Project: struct {
        name: []const u8,
        ignore: ?[]const []const u8,
    },
    Scan: struct {
        taskName: []const u8,
        enableMultiline: bool,
        multilineTask: ?[]const u8,
        multilineEnd: ?[]const u8,
    },
    Priorities: struct {
        enable: bool,
        name: []const []const u8,
        level: []const u32,
        flag: []const u8,
        lowerToHigher: bool,
    },
    // In work
};

pub const Skin = struct {
    name: []const u8,
    Sections: struct {
        header: bool,
        task: bool,
        number: bool,
        priority: bool,
        line: bool,
        separator: bool,
    },
    Header: struct {
        separator: ?[]const u8,
        prefix: []const u8,
        postfix: []const u8,
        capitalized: bool,
    },
    Task: struct {
        separator: ?[]const u8,
        prefix: []const u8,
        postfix: []const u8,
        capitalized: bool,
    },
    Number: struct {
        separator: ?[]const u8,
        prefix: []const u8,
        postfix: []const u8,
        beforePriority: bool,
    },
    Priority: struct {
        prefix: []const u8,
        postfix: []const u8,
        capitalized: bool,
    },
    Line: struct {
        separator: ?[]const u8,
        prefix: []const u8,
        postfix: []const u8,
        numberPrefix: []const u8,
        numberPostfix: []const u8,
        numBeforeFile: bool,
    },
};
