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
            AsyncImage(url: URL(string: "http://picsum.photos/400"))
                .frame(height: 300.0)
                .frame(maxWidth: UIScreen.main.bounds.width)
                .clipped()

            Text(event.title)
                .font(.title)
                .padding([.leading, .top])
                .fontWeight(.semibold)

            Label(event.location, systemImage: "map.fill")
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
                            .frame(maxHeight: .infinity)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .frame(maxHeight: .infinity)
                    .frame(width: 60)
                }
            }
            .padding()
            .frame(maxHeight: 100)
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
    EventDetailView(event: exampleEvent)
}
