import Fluent
import Vapor

extension Event {
    struct Migration: AsyncMigration {
        var name: String { "CreateEvents" }

        func prepare(on database: Database) async throws {
            try await database.schema("events")
                .id()
                .field("title", .string, .required)
                .field("location", .string, .required)
                .field("start_time", .date, .required)
                .field("duration_seconds", .int, .required)
                .field("base64image", .string)
                .field("creator_id", .uuid, .required, .references("users", "id"))
                .field("group_id", .uuid, .required, .references("groups", "id"))
                .create()
        }

        func revert(on database: Database) async throws {
            try await database.schema("events").delete()
        }
    }
}
