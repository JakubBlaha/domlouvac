import Foundation

class EventsViewModel: ObservableObject {
    @Published var isRefreshing = false
    @Published var events: [Event] = []

    func refreshEvents(auth: Authorization) async {
        Task { @MainActor in
            isRefreshing = true
        }

        defer {
            Task { @MainActor in
                isRefreshing = false
            }
        }

        var events_: [Event]

        do {
            events_ = try await HttpClient.shared.fetch(endpoint: "events", auth: auth)
        } catch {
            print(error)
            return
        }

        for index in events_.indices {
            events_[index].decodeImage()
        }

        await MainActor.run { [events_] in
            events = events_
            isRefreshing = false
        }
    }
}
