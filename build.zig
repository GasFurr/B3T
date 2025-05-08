const std = @import("std");

pub fn build(b: *std.Build) void {
    // No standard options
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // Main executable
    const executable = b.addExecutable(.{
        .name = "b3t",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    // Place binary in root of the project
    const install = b.addInstallArtifact(executable, .{ .dest_dir = .{ .override = .{ .custom = "../" } } });

    b.default_step.dependOn(&install.step);

    // Install b3t executable
    const run_cmd = b.addRunArtifact(executable);
    run_cmd.step.dependOn(b.getInstallStep());
    // Run b3t executable
    const run_step = b.step("run", "Run the app!");
    run_step.dependOn(&run_cmd.step);
}
