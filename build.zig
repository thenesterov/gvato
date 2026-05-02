const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const version = b.option([]const u8, "version", "Version of the application") orelse "0.0.0";

    const exe = b.addExecutable(.{
        .name = "gvato",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .target = target,
            .optimize = optimize,
        }),
    });

    const options = b.addOptions();
    options.addOption([]const u8, "version", version);

    exe.root_module.addOptions("build_options", options);

    b.installArtifact(exe);

    // zig build run
    const run_exe = b.addRunArtifact(exe);
    run_exe.step.dependOn(b.getInstallStep());

    const run_step = b.step("run", "Run the application");
    run_step.dependOn(&run_exe.step);

    if (b.args) |args| {
        run_exe.addArgs(args);
    }

    // zig build tests
    const tests = b.addTest(.{
        .root_module = exe.root_module,
    });

    const run_tests = b.addRunArtifact(tests);

    const tests_step = b.step("test", "Run tests");
    tests_step.dependOn(&run_tests.step);
}

