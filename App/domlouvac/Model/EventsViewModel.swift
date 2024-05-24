import Foundation

class EventsViewModel: ObservableObject {
    @Published var events: [Event] = []

    func refreshEvents(auth: Authorization) async {
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
        }
    }
}
