import Foundation

class EventDetailViewModel: ObservableObject {
    @Published var isChangingInterested = false
    @Published var event: Event

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
    }
}
