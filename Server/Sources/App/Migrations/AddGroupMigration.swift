import Fluent
import Vapor

extension Group {
    struct Migration: AsyncMigration {
        var name: String { "CreateGroup" }

        func prepare(on database: Database) async throws {
            try await database.schema("groups")
                .id()
                .field("name", .string, .required)
                .field("code", .string, .required)
                .unique(on: "code")
                .create()
        }

        func revert(on database: Database) async throws {
            try await database.schema("groups").delete()
        }
    }
}
