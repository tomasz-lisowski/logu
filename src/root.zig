const std = @import("std");
pub const logz = @import("logz");

var allocator_general_purpose = std.heap.GeneralPurposeAllocator(.{}){};
const allocator_logz = allocator_general_purpose.allocator();

pub fn logzOff() void {
    // Do not use testing.allocator here! This leaks because we allocate a global and never dealloc it. It's necessary if we want logging in tests.
    logz.setup(allocator_logz, .{ .pool_size = 1, .level = .None, .output = .stderr }) catch unreachable;
}

pub fn logzOn() void {
    // Do not use testing.allocator here! This leaks because we allocate a global and never dealloc it. It's necessary if we want logging in tests.
    logz.setup(allocator_logz, .{ .pool_size = 2, .level = .Debug, .output = .stderr }) catch unreachable;
}

pub inline fn logzScope(logger: logz.Logger, comptime parent: type, src: std.builtin.SourceLocation) logz.Logger {
    return logger.string("@src", std.fmt.comptimePrint("{s}:{}:{} ({s}.{s})", .{ src.file, src.line, src.column, @typeName(parent), src.fn_name }));
}

pub fn logzBlockOpen(logger: logz.Logger, block_name: []const u8) logz.Logger {
    return logger.string("@block__open", block_name);
}

pub fn logzBlockClose(logger: logz.Logger, block_name: []const u8) logz.Logger {
    return logger.string("@block__close", block_name);
}
