//
//  EventDetailView.swift
//  domlouvac
//
//  Created by Jakub Bláha on 24.04.2024.
//

import SwiftUI

struct EventDetailView: View {
    @StateObject var viewModel: EventDetailViewModel = EventDetailViewModel()
    var event: Event

    var body: some View {
        VStack(alignment: .leading) {
            AsyncImage(url: URL(string: event.imageUrl))
                .frame(height: 300.0)
                .frame(maxWidth: UIScreen.main.bounds.width)
                .clipped()

            Text(event.name)
                .font(.title)
                .padding([.leading, .top])
                .fontWeight(.semibold)

            Label(event.locationName, systemImage: "map.fill")
                .padding([.top, .leading])

            Label(event.getFormattedDate(), systemImage: "calendar")
                .padding([.top, .leading])

            Label(event.getFormattedStartTime(), systemImage: "clock.fill")
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

                if viewModel.isInterested {
                    Button(action: handleNoLongerInterested) {
                        Image(systemName: "xmark")
                            .frame(maxHeight: /*@START_MENU_TOKEN@*/ .infinity/*@END_MENU_TOKEN@*/)
                            .frame(maxWidth: /*@START_MENU_TOKEN@*/ .infinity/*@END_MENU_TOKEN@*/)
                    }
                    .buttonStyle(.bordered)
                    .frame(maxHeight: .infinity)
                    .frame(width: 60)
                }
            }
            .padding(.horizontal)
            .frame(maxHeight: 60)
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    func handleInterested() {
        viewModel.isInterested = true
    }

    func handleNoLongerInterested() {
        viewModel.isInterested = false
    }
}

#Preview {
    EventDetailView(event: events[0])
}
