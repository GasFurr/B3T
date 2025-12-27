// Configuration model
pub const Config = struct {
    // [[env]]
    env: struct {
        // skin = "..."
        skin: []const u8,
        // template = "..."
        template: []const u8,
    },
};

// Template model
pub const Template = struct {
    // template_name = "..."
    template_name: []const u8,
    // [[project]]
    project: struct {
        // name = "..."
        name: []const u8,
        // ignore = ["...", "..."]
        ignore: ?[]const []const u8, //optional.
        // parse = "..."
        parse: []const u8,
    },
    // [[priorities]]
    priorities: ?struct {
        // name = ["...", "..."]
        name: ?[][]const u8,
        // level = [1, 2, 3, ...]
        level: ?[]i64,
        // flag = "..."
        flag: ?[]const u8,
    },
};

// Project index. Yeah, that's it.
pub const Data = struct {
    // path = "..."
    path: []const u8,
};

// Biggest one
// Visual model (skin)
pub const Skin = struct {
    // name = "..."
    name: []const u8,
    // [[sections]]
    sections: struct {
        // header = t/f
        header: bool,
        // task = t/f
        task: bool,
        // number = t/f
        number: bool,
        // priority = t/f
        priority: bool,
        // line = t/f
        line: bool,
        // separator = t/f
        separator: bool,
    },
    // [[header]]
    header: struct {
        // separator = "..."
        separator: []const u8,
        // prefix = "..."
        prefix: []const u8,
        // postfix = "..."
        postfix: []const u8,
        // captialized = t/f
        capitalized: bool,
    },
    // [[task]]
    task: struct {
        // separator = "..."
        separator: []const u8,
        // prefix = "..."
        prefix: []const u8,
        // postfix = "..."
        postfix: []const u8,
        // captialized = t/f
        capitalized: bool,
    },
    // [[number]]
    number: struct {
        // separator = "..."
        separator: []const u8,
        // prefix = "..."
        prefix: []const u8,
        // postfix = "..."
        postfix: []const u8,
        // before_priority = t/f
        before_priority: bool,
    },
    // [[priority]]
    priority: struct {
        // prefix = "..."
        prefix: []const u8,
        // postfix = "..."
        postfix: []const u8,
        // captialized = t/f
        capitalized: bool,
    },
    // [[line]]
    line: struct {
        // separator = "..."
        separator: []const u8,
        // prefix = "..."
        prefix: []const u8,
        // postfix = "..."
        postfix: []const u8,
        // number_prefix = "..."
        number_prefix: []const u8,
        // number_postfix = "..."
        number_postfix: []const u8,
        // num_before_file = t/f
        num_before_file: bool,
    },
};
