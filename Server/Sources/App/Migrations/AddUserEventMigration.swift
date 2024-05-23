import Fluent
import Vapor

extension UserEvent {
    struct Migration: AsyncMigration {
        var name: String { "CreateUserEventRelation" }

        func prepare(on database: Database) async throws {
            try await database.schema("user+event")
                .id()
                .field("user_id", .uuid, .required)
                .field("event_id", .uuid, .required)
                .unique(on: "user_id", "event_id")
                .create()
        }

        func revert(on database: Database) async throws {
            try await database.schema("user+event").delete()
        }
    }
}
