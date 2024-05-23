import Foundation

class EventDetailViewModel: ObservableObject {
    @Published var isChangingInterested = false
    @Published var event: Event

    var peopleInterestedString: String {
        if event.interestedUsers.count == 1 {
            return "1 person interested"
        }

        return "\(event.interestedUsers.count) people interested"
    }

    init(event: Event) {
        self.event = event
    }

    func changeInterested(auth: Authorization, interested: Bool) async {
        await MainActor.run { isChangingInterested = true }
        defer { Task { @MainActor in isChangingInterested = false } }

        do {
            try await HttpClient.shared.sendReqest(
                to: "events/\(event.id)/\(interested ? "interested" : "not-interested")",
                httpMethod: HttpMethod.POST.rawValue, auth: auth)
        } catch {
            print(error)
            return
        }

        await MainActor.run { event.isUserInterested = interested }
        await refresh(auth: auth)
    }

    func refresh(auth: Authorization) async {
        guard let event: Event = try? await HttpClient.shared.fetch(endpoint: "events/" + event.id.uuidString, auth: auth) else {
            print("Failed to fetch event!")
            return
        }

        await MainActor.run {
            self.event = event
        }
    }

    func deleteEvent(auth: Authorization, onSuccess: () -> Void) async {
        guard let _ = try? await HttpClient.shared.sendReqest(to: "events/\(event.id)", httpMethod: HttpMethod.DELETE.rawValue, auth: auth) else {
            return
        }

        onSuccess()
    }
}
