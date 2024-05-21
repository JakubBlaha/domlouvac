import Foundation

enum EventDuration: String, CaseIterable {
    case MINS_15 = "15 minutes"
    case MINS_30 = "30 minutes"
    case MINS_45 = "45 minutes"
    case HOURS_1 = "1 hour"
    case HOURS_2 = "2 hours"
    case HOURS_3 = "3 hours"
    case HOURS_4 = "4 hours"
    case HOURS_5 = "5 hours"
    case HOURS_6 = "6 hours"
    case HOURS_12 = "12 hours"
    case HOURS_24 = "24 hours"
    case DAYS_2 = "2 days"
    case WEEK = "1 week"
}

class CreateEventViewModel: ObservableObject, Encodable {
    @Published var eventTitle: String = ""
    @Published var eventStartDate: Date = Date.now
    @Published var eventDurationEnumValue: EventDuration = .HOURS_1

    @Published var isCreatingEvent = false
    @Published var isSuccess = false

    private enum CodingKeys: String, CodingKey {
        case title
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(eventTitle, forKey: .title)
    }

    func createEvent(auth: Authorization) async {
        print(auth)

        DispatchQueue.main.async {
            self.isCreatingEvent = true
        }

        do {
            try await HttpClient.shared.sendData(
                toEndpoint: "events",
                object: self,
                httpMethod: HttpMethod.POST,
                authorization: auth
            )
        } catch {
            isCreatingEvent = false
            print(error)

            return
        }

        DispatchQueue.main.async {
            self.isCreatingEvent = false
            self.isSuccess = true
        }
    }
}
