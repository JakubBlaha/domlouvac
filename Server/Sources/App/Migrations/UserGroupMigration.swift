import Fluent
import Vapor

extension UserGroup {
    struct Migration: AsyncMigration {
        var name: String { "CreateUserGroupRelation" }

        func prepare(on database: Database) async throws {
            try await database.schema("user+group")
                .id()
                .field("user_id", .uuid, .required)
                .field("group_id", .uuid, .required)
                .unique(on: "user_id", "group_id")
                .create()
        }

        func revert(on database: Database) async throws {
            try await database.schema("user+group").delete()
        }
    }
}
