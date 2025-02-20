import SwiftUI

struct EventDetailView: View {
    @EnvironmentObject var environ: EnvironModel
    @Environment(\.dismiss) private var dismiss
    @StateObject var model: EventDetailViewModel
    @State private var isDeleteConfirmShown = false

    var body: some View {
        VStack(alignment: .leading) {
            Image(uiImage: model.event.uiImage ?? UIImage())
                .resizable()
                .scaledToFill()
                .aspectRatio(contentMode: .fill)
                .frame(height: 250.0)
                .frame(maxWidth: UIScreen.main.bounds.size.width)
                .clipped()

            HStack(alignment: .bottom) {
                Text(model.event.title)
                    .font(.title)
                    .padding([.leading, .top])
                    .fontWeight(.semibold)

                Spacer()

                Button(action: { isDeleteConfirmShown = true }, label: {
                    Text("Delete")
                })
                .buttonStyle(.bordered)
                .padding(.horizontal)
                .alert(isPresented: $isDeleteConfirmShown) {
                    Alert(
                        title: Text("Delete event"),
                        message: Text("Are you sure you want to delete this event?"),
                        primaryButton: .default(Text("Yes")) {
                            deleteEvent()
                        },
                        secondaryButton: .cancel(Text("No"))
                    )
                }
            }

            Label(model.event.location, systemImage: "map.fill")
                .padding([.top, .leading])

            Label(model.event.getFormattedDate(), systemImage: "calendar")
                .padding([.top, .leading])

            Label(model.event.getFormattedStartTime(), systemImage: "clock.fill")
                .padding([.top, .leading])

            HStack {
                Label(model.event.getFormattedDuration(), systemImage: "hourglass")
                    .padding([.top, .leading])
            }.padding([.leading], 4)

            Spacer()

            Button(action: {}, label: {
                NavigationLink(destination: InterestedUsersView(users: model.event.interestedUsers)) {
                    HStack(content: {
                        Image(systemName: "person.3.fill")
                        Text(model.peopleInterestedString)
                    })
                }
            })
            .padding()
            .disabled(model.event.interestedUsers.isEmpty)

            HStack {
                Button(action: handleInterested) {
                    Label("I'm interested", systemImage: "bell.fill")
                        .frame(maxWidth: .infinity)
                        .frame(maxHeight: .infinity)
                }
                .frame(maxWidth: .infinity)
                .buttonStyle(.borderedProminent)
                .disabled(model.isChangingInterested || model.event.isUserInterested)
                .foregroundColor(model.event.isUserInterested ? .black : .white)
                .animation(.bouncy, value: model.event.isUserInterested)

                if model.event.isUserInterested {
                    Button(action: handleNotInterested) {
                        Image(systemName: "xmark")
                            .frame(maxHeight: .infinity)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .frame(maxHeight: .infinity)
                    .frame(width: 70)
                    .disabled(model.isChangingInterested)
                }
            }
            .padding()
            .frame(maxHeight: 100)
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    func handleInterested() {
        Task {
            await model.changeInterested(auth: environ.tokenAuth, interested: true)
        }
    }

    func handleNotInterested() {
        Task {
            await model.changeInterested(auth: environ.tokenAuth, interested: false)
        }
    }

    func deleteEvent() {
        Task {
            await model.deleteEvent(auth: environ.tokenAuth, onSuccess: {
                Task { @MainActor in
                    dismiss()
                }
            })
        }
    }
}

#Preview {
    EventDetailView(model: EventDetailViewModel(event: exampleEvent))
}
