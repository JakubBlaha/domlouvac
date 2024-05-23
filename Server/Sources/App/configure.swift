import Fluent
import FluentSQLiteDriver
import NIOSSL
import Vapor

public func configure(_ app: Application) async throws {
    app.databases.use(.sqlite(.file("db.sqlite")), as: .sqlite)

    app.migrations.add(User.Migration())
    app.migrations.add(UserToken.Migration())
    app.migrations.add(Group.Migration())
    app.migrations.add(UserGroup.Migration())
    app.migrations.add(Event.Migration())
    app.migrations.add(UserEvent.Migration())

    try await app.autoMigrate()

    try routes(app)
}
