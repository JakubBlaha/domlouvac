import SwiftUI

struct CreateEventView: View {
    @ObservedObject var model = CreateEventViewModel()
    @EnvironmentObject var environ: EnvironModel
    @Environment(\.dismiss) private var dismiss
    @State private var isShowingImagePicker = false

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

            HStack {
                // Start time
                HStack {
                    VStack(alignment: .leading) {
                        Text("Start time").padding(.horizontal).fontWeight(.semibold)

                        DatePicker(
                            "Date & Time",
                            selection: $model.eventStartDate,
                            displayedComponents: [.date, .hourAndMinute]
                        ).datePickerStyle(.compact).labelsHidden().padding()
                    }

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
                    }.padding(.vertical)
                }
            }
            .padding()

            ZStack {
                Image(uiImage: model.selectedImage ?? UIImage())
                    .resizable()
                    .aspectRatio(contentMode: /*@START_MENU_TOKEN@*/ .fill/*@END_MENU_TOKEN@*/)
                    .frame(width: 200)
                    .frame(height: 100)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)
                    .clipped()
                    .padding(.horizontal)

                Button("Select", action: {
                    isShowingImagePicker = true
                })
                .padding()
                .sheet(isPresented: $isShowingImagePicker, content: {
                    ImagePicker(selectedImage: $model.selectedImage, base64EncodedImage: $model.base64EncodedImage)
                })
                .buttonStyle(PlainButtonStyle())
                .background(Color(.secondarySystemBackground))
                .foregroundColor(/*@START_MENU_TOKEN@*/ .blue/*@END_MENU_TOKEN@*/)
                .cornerRadius(10)
            }
            .padding()

            Spacer()

            Button {
                Task {
                    await model.createEvent(auth: environ.tokenAuth, groupId: group.id)

                    if model.isSuccess {
                        dismiss()
                    }
                }
            } label: {
                ZStack {
                    HStack {
                        if model.isCreatingEvent {
                            ProgressView().padding()
                        }

                        Spacer()
                    }

                    Text("Save Event")
                        .frame(maxWidth: .infinity)
                        .frame(maxHeight: .infinity)
                        .fontWeight(.semibold)
                        .padding()
                }
            }
            .buttonStyle(.borderedProminent)
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .padding()
            .disabled(!model.inputValid || model.isCreatingEvent)
        }
    }
}

#Preview {
    CreateEventView(
        group: GroupListModel(id: UUID(), code: "123123", name: "Test Group", users: []))
}
