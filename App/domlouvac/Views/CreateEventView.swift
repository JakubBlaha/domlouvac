import SwiftUI

struct CreateEventView: View {
    @ObservedObject var model = CreateEventViewModel()
    @EnvironmentObject var environ: EnvironModel

    var group: GroupListModel

    var body: some View {
        VStack {
            Text("Create New Event")
                .font(.title)
                .fontWeight(.semibold)

            Text("In group " + group.name)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundStyle(Color(.gray))

            // Title
            VStack(alignment: .leading) {
                Text("Event title").padding(.horizontal).fontWeight(.semibold)

                TextField("My New Event", text: $model.eventTitle)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)
            }.padding()

            // Start time
            HStack {
                VStack(alignment: .leading) {
                    Text("Start time").padding(.horizontal).fontWeight(.semibold)

                    DatePicker(
                        "Date & Time",
                        selection: $model.eventStartDate,
                        displayedComponents: [.date, .hourAndMinute]
                    ).datePickerStyle(.compact).labelsHidden().padding()
                }.padding()

                Spacer()
            }

            // Duration
            HStack {
                VStack {
                    Text("Duration").padding(.horizontal).fontWeight(.semibold)

                    Picker("Please choose event duration", selection: $model.eventDurationEnumValue) {
                        ForEach(EventDuration.allCases, id: \.self) { value in
                            Text(value.rawValue)
                        }
                    }
                }.padding()

                Spacer()
            }

            Spacer()

            Button {
                Task {
                    await model.createEvent(auth: try! environ.tokenAuth)
                }
            } label: {
                Text("Save Event")
                    .frame(maxWidth: .infinity)
                    .frame(maxHeight: .infinity)
                    .fontWeight(.semibold)
            }
            .buttonStyle(.borderedProminent)
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .padding()
        }
    }
}

#Preview {
    CreateEventView(group: GroupListModel(id: UUID(), code: "123123", name: "Test Group", users: []))
}
