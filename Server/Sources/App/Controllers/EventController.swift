import Fluent
import Vapor

struct EventController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let tokenProtected = routes.grouped(UserToken.authenticator())
        let events = tokenProtected.grouped("events")

        events.get(use: { try await self.index(req: $0) })

        events.get { req in
            try await self.listEvents(req: req)
        }

        events.get(":eventId", use: find)
        events.delete(":eventId", use: delete)
        events.post(":eventId", "interested", use: interested)
        events.post(":eventId", "not-interested", use: notInterested)
    }

    func index(req: Request) async throws -> [Event] {
        try await Event.query(on: req.db).all()
    }

    private func userGroupIds(_ req: Request, _ user: User) async throws -> [UUID] {
        let groups = try await user.$groups.query(on: req.db).all()
        let groupIds = groups.map({ group in group.id! })

        return groupIds
    }

    @Sendable func find(_ req: Request) async throws -> Event.Public {
        let user = try req.auth.require(User.self)

        guard let eventId = req.parameters.get("eventId").toUUID() else {
            throw Abort(.badRequest)
        }

        guard let event = try await Event.find(eventId, on: req.db) else {
            throw Abort(.notFound)
        }

        try await event.loadUsers(on: req.db)

        return try await event.toPublic(reqUserId: user.id!)
    }

    @Sendable func delete(_ req: Request) async throws -> HTTPStatus {
        let user = try req.auth.require(User.self)

        guard let eventId = req.parameters.get("eventId").toUUID() else {
            throw Abort(.badRequest)
        }

        guard let event = try? await Event.find(eventId, on: req.db) else {
            throw Abort(.notFound)
        }

        try await event.loadGroup(on: req.db)
        try await event.group.loadUsers(on: req.db)

        if !event.group.users.hasId(user.id) {
            throw Abort(.unauthorized)
        }

        try await event.delete(on: req.db)

        return .ok
    }

    func listEvents(req: Request) async throws -> [Event] {
        let user = try req.auth.require(User.self)
        let events = try await Event.query(on: req.db).filter(
            \.$group.$id ~~ userGroupIds(req, user)
        )
        .all()

        return events
    }

    private func eventFromParams(_ req: Request) async throws -> Event {
        guard let eventId = req.parameters.get("eventId") else {
            throw Abort(.badRequest)
        }

        guard let eventUUID = UUID(eventId) else {
            throw Abort(.badRequest)
        }

        guard let event = try await Event.find(eventUUID, on: req.db) else {
            throw Abort(.notFound)
        }

        return event
    }

    @Sendable func interested(req: Request) async throws -> HTTPStatus {
        let user = try req.auth.require(User.self)

        let event = try await eventFromParams(req)
        let userEvent = try? await UserEvent.query(on: req.db)
            .filter(\.$user.$id == user.id!)
            .filter(\.$event.$id == event.id!)
            .first()

        // If already in DB, return ok
        if userEvent != nil {
            return .ok
        }

        do {
            try await user.$events.attach(event, on: req.db)
        } catch {
            print(String(reflecting: error))
            throw Abort(.internalServerError)
        }

        return .ok
    }

    @Sendable func notInterested(req: Request) async throws -> HTTPStatus {
        let user = try req.auth.require(User.self)

        guard let _ = try? await user.$events.detach(eventFromParams(req), on: req.db) else {
            throw Abort(.internalServerError)
        }

        return .ok
    }
}
