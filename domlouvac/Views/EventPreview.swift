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
            AsyncImage(url: URL(string: event.imageUrl)) {image in
                image.resizable().aspectRatio(contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
            } placeholder: {
                Color.blue
            }
                .frame(height: 200.0)
                .clipped()
            
            HStack {
                Text(event.name)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding(.leading)
                
                Spacer()
                
                VStack (alignment: .leading) {
                    Label(getFormattedStartTime(), systemImage: "calendar")
                    Label(event.locationName, systemImage: "map")
                }
                .padding(.horizontal)
            }
        }
        .padding(.bottom)
        .cornerRadius(15.0)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white)
                .shadow(color: .gray, radius: 10)
        )
    }
}

#Preview {
    EventPreview(event: events[0])
}
