const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // create executable binary target
    const exe = b.addExecutable(.{
        .name = "b3t",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .target = target,
            .optimize = optimize,
        }),
    });

    // Dependencies
    const clap = b.dependency("clap", .{});
    exe.root_module.addImport("clap", clap.module("clap"));

    const microwave = b.dependency("microwave", .{});
    exe.root_module.addImport("microwave", microwave.module("microwave"));

    const install = b.addInstallArtifact(exe, .{ .dest_dir = .{ .override = .{ .custom = "../b3t/" } } });

    b.default_step.dependOn(&install.step);
    // Install it
    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    // Run it
    const run_step = b.step("run", "Run the app!");
    run_step.dependOn(&run_cmd.step);
}
