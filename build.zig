const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // create executable binary target
    const exe = b.addExecutable(.{
        .name = "b3t-bin",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    // Add toml dependency.
    const zig_toml_dep = b.dependency("microwave", .{
        .target = target,
        .optimize = optimize,
    });

    // Add its module using the
    exe.root_module.addImport("microwave", zig_toml_dep.module("microwave"));
    // Place binary in root folder
    const install = b.addInstallArtifact(exe, .{ .dest_dir = .{ .override = .{ .custom = "../resources/" } } });

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

    // Release package configuration
    const exe_release = b.addExecutable(.{
        .name = "b3t-bin",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = .ReleaseSafe,
    });

    // Create release directory structure
    const mkdir_release = b.addSystemCommand(&.{"mkdir"});
    mkdir_release.addArgs(&.{ "-p", "release" });

    // Install binary to release directory

    const install_release = b.addInstallArtifact(exe_release, .{ .dest_dir = .{ .override = .{ .custom = "../release" } } });

    // Copy resources to release directory
    const copy_resources = b.addSystemCommand(&.{"cp"});
    copy_resources.addArgs(&.{ "-r", "resources/", "release/" });

    // Create archive of release directory
    const create_archive = b.addSystemCommand(&.{
        "tar",
        "-czvf",
        "b3t.tar.gz",
        "release",
    });

    // Set up dependencies
    const release_step = b.step("release", "Create release package");
    release_step.dependOn(&mkdir_release.step);
    release_step.dependOn(&install_release.step);
    release_step.dependOn(&copy_resources.step);
    release_step.dependOn(&create_archive.step);

    // Ensure proper execution order
    install_release.step.dependOn(&mkdir_release.step);
    copy_resources.step.dependOn(&mkdir_release.step);
    create_archive.step.dependOn(&install_release.step);
    create_archive.step.dependOn(&copy_resources.step);

    const clean_release = b.addSystemCommand(&.{
        "rm",
        "-rf",
        "release/",
        "b3t.tar.gz",
        "b3t-bin",
    });

    const clean_step = b.step("clean", "Cleans up root from release files");

    clean_step.dependOn(&clean_release.step);
}
