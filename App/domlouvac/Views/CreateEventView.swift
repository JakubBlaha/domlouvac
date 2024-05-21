import SwiftUI

struct CreateEventView: View {
    @ObservedObject var model = CreateEventViewModel()
    @EnvironmentObject var environ: EnvironModel
    @Environment(\.dismiss) private var dismiss

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
                Text("Title").padding(.horizontal).fontWeight(.semibold)

                TextField("House party", text: $model.eventTitle)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)
            }.padding()

            VStack(alignment: .leading) {
                Text("Location").padding(.horizontal).fontWeight(.semibold)

                TextField("at my place...", text: $model.eventLocation)
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
            VStack {
                HStack {
                    Text("Duration").padding(.horizontal).fontWeight(.semibold)
                    Spacer()
                }

                HStack {
                    Picker("Please choose event duration", selection: $model.eventDurationEnumValue)
                        {
                            ForEach(EventDuration.allCases, id: \.self.value.seconds) { value in
                                Text(value.value.label)
                            }
                        }
                    Spacer()
                }
            }
            .padding(.horizontal)

            Spacer()

            Button {
                Task {
                    await model.createEvent(auth: try! environ.tokenAuth, groupId: group.id)

                    if model.isSuccess {
                        dismiss()
                    }
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
            .disabled(!model.inputValid)
        }
    }
}

#Preview {
    CreateEventView(
        group: GroupListModel(id: UUID(), code: "123123", name: "Test Group", users: []))
}
