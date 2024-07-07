const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const dep__logz = b.dependency("logz", .{
        .target = target,
        .optimize = optimize,
    });
    const module__logz = dep__logz.module("logz");

    const module__logu = b.addModule("logu", .{
        .root_source_file = b.path("src/root.zig"),
    });
    module__logu.addImport("logz", module__logz);

    const lib = b.addStaticLibrary(.{
        .name = "logu",
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
    });
    lib.root_module.addImport("logz", module__logz);
    b.installArtifact(lib);

    const lib_unit_tests = b.addTest(.{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
    });
    lib_unit_tests.root_module.addImport("logz", module__logz);

    const run_lib_unit_tests = b.addRunArtifact(lib_unit_tests);
    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_lib_unit_tests.step);
}
