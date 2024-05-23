import SwiftUI

struct EventDetailView: View {
    @EnvironmentObject var environ: EnvironModel
    @StateObject var model: EventDetailViewModel

    var body: some View {
        VStack(alignment: .leading) {
            AsyncImage(url: URL(string: "http://picsum.photos/400"))
                .frame(height: 300.0)
                .frame(maxWidth: UIScreen.main.bounds.width)
                .clipped()

            Text(model.event.title)
                .font(.title)
                .padding([.leading, .top])
                .fontWeight(.semibold)

            Label(model.event.location, systemImage: "map.fill")
                .padding([.top, .leading])

            Label(model.event.getFormattedDate(), systemImage: "calendar")
                .padding([.top, .leading])

            Label(model.event.getFormattedStartTime(), systemImage: "clock.fill")
                .padding([.top, .leading])

            Spacer()

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
}

#Preview {
    EventDetailView(model: EventDetailViewModel(event: exampleEvent))
}
