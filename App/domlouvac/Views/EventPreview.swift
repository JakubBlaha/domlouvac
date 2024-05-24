import SwiftUI

struct EventPreview: View {
    var event: Event

    func getFormattedStartTime() -> String {
        let formatter = DateFormatter()

        formatter.dateFormat = "dd.MM.yyyy"

        let startString = formatter.string(from: event.startTime)

        return startString
    }

    var body: some View {
        VStack {
            Image(uiImage: event.uiImage ?? UIImage())
                .resizable()
                .scaledToFill()
                .aspectRatio(contentMode: .fill)
                .frame(height: 200.0)
                .clipped()

            HStack {
                Text(event.title)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding(.leading)

                Spacer()

                VStack(alignment: .leading) {
                    Label(getFormattedStartTime(), systemImage: "calendar")
                    Label(event.location, systemImage: "map")
                }
                .padding(.horizontal)
            }
        }
        .padding(.bottom)
        .cornerRadius(15.0)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white)
                .shadow(color: .gray, radius: 5)
        )
    }
}

#Preview {
    EventPreview(event: exampleEvent)
}
