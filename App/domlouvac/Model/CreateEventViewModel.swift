import Combine
import Foundation

struct Duration {
    var label: String
    var seconds: Int
}

enum EventDuration: CaseIterable {
    case MINS_15, MINS_30, MINS_45, HOURS_1, HOURS_2, HOURS_3, HOURS_4, HOURS_5, HOURS_6, HOURS_12,
         HOURS_24, DAYS_2, WEEK

    var value: Duration {
        switch self {
        case .MINS_15:
            return Duration(label: "15 minutes", seconds: 15 * 60)
        case .MINS_30:
            return Duration(label: "30 minutes", seconds: 30 * 60)
        case .MINS_45:
            return Duration(label: "45 minutes", seconds: 45 * 60)
        case .HOURS_1:
            return Duration(label: "1 hour", seconds: 1 * 60 * 60)
        case .HOURS_2:
            return Duration(label: "2 hours", seconds: 2 * 60 * 60)
        case .HOURS_3:
            return Duration(label: "3 hours", seconds: 3 * 60 * 60)
        case .HOURS_4:
            return Duration(label: "4 hours", seconds: 4 * 60 * 60)
        case .HOURS_5:
            return Duration(label: "5 hours", seconds: 5 * 60 * 60)
        case .HOURS_6:
            return Duration(label: "6 hours", seconds: 6 * 60 * 60)
        case .HOURS_12:
            return Duration(label: "12 hours", seconds: 12 * 60 * 60)
        case .HOURS_24:
            return Duration(label: "24 hours", seconds: 24 * 60 * 60)
        case .DAYS_2:
            return Duration(label: "2 days", seconds: 2 * 24 * 60 * 60)
        case .WEEK:
            return Duration(label: "1 week", seconds: 7 * 24 * 60 * 60)
        }
    }

    static var allCases: [EventDuration] {
        return [
            .MINS_15, .MINS_30, .MINS_45, .HOURS_1, .HOURS_2, .HOURS_3, .HOURS_4, .HOURS_5,
            .HOURS_6, .HOURS_12, .HOURS_24, .DAYS_2, .WEEK,
        ]
    }
}

class CreateEventViewModel: ObservableObject, Encodable {
    @Published var eventTitle: String = ""
    @Published var eventLocation: String = ""
    @Published var eventStartDate: Date = Date.now
    @Published var eventDurationEnumValue: EventDuration = .HOURS_1

    @Published var inputValid = false
    @Published var isCreatingEvent = false
    @Published var isSuccess = false

    var groupId: UUID?

    var kombajn: AnyCancellable?

    private enum CodingKeys: String, CodingKey {
        case title, location, startTime, durationSeconds, groupId
    }

    init() {
        kombajn = $eventTitle.combineLatest($eventLocation).sink { title, location in
            if !title.isEmpty && !location.isEmpty {
                self.inputValid = true
            }
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(eventTitle, forKey: .title)
        try container.encode(eventLocation, forKey: .location)
        try container.encode(groupId!.uuidString, forKey: .groupId)
        try container.encode(eventStartDate, forKey: .startTime)
        try container.encode(eventDurationEnumValue.value.seconds, forKey: .durationSeconds)
    }

    func createEvent(auth: Authorization, groupId: UUID) async {
        self.groupId = groupId

        print(auth)

        DispatchQueue.main.async {
            self.isCreatingEvent = true
        }

        defer {
            DispatchQueue.main.async {
                self.isCreatingEvent = false
            }
        }

        do {
            try await HttpClient.shared.sendData(
                toEndpoint: "groups/\(groupId.uuidString)/events",
                object: self,
                httpMethod: HttpMethod.POST,
                authorization: auth
            )
        } catch {
            print(error)
            return
        }

        DispatchQueue.main.async {
            self.isSuccess = true
        }
    }
}
