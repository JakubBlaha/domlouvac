import SwiftUI

enum Tab {
    case events, users
}

struct GroupDetailView: View {
    @ObservedObject var model: GroupViewDetailModel
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var environ: EnvironModel

    @State var isPresentingLeaveConfirm = false
    @State var selectedTab: Tab = .events

    init(group: GroupListModel, initialTab: Tab = .events) {
        model = GroupViewDetailModel(group: group)
        selectedTab = initialTab
    }

    var body: some View {
        VStack {
            VStack {
                HStack {
                    Text(model.group.name).font(.system(size: 48)).fontWeight(.bold).foregroundColor(.white).padding(.horizontal)
                    Spacer()
//                        .toolbar(.hidden, for: .tabBar)
                        .navigationBarTitleDisplayMode(.inline)
                }

                HStack {
                    Text("Code: " + model.group.code).font(.title3).padding(.horizontal).foregroundStyle(Color(.white)).fontWeight(.bold)
                    Spacer()
                }
            }.padding().background {
                Color(.systemBlue)
            }

            HStack {
                Button("Events") {
                    selectedTab = .events
                }
                .buttonStyle(PlainButtonStyle())
                .foregroundColor(selectedTab == .events ? .blue : .gray)
                .fontWeight(.semibold)
                .padding(10)

                Button("Users") {
                    selectedTab = .users
                }
                .buttonStyle(PlainButtonStyle())
                .fontWeight(.semibold)
                .foregroundColor(selectedTab == .users ? .blue : .gray)
                .padding(10)

                Spacer()

                // New event button
                if selectedTab == .events {
                    Button {
                    } label: {
                        NavigationLink {
                            CreateEventView(group: model.group)
                        } label: {
                            Image(systemName: "plus").frame(maxHeight: .infinity)
                        }.frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .frame(maxWidth: .infinity)
                    .frame(height: 40)
                    .frame(width: 40)
                    .backgroundStyle(Color(.white))
                } else {
                    // Leave group button
                    Button {
                        isPresentingLeaveConfirm = true
                    } label: {
                        HStack {
                            Text("Leave")
                                .frame(maxHeight: .infinity)
                                .fontWeight(.semibold)
                        }.frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .frame(maxWidth: .infinity)
                    .frame(height: 30)
                    .frame(width: 80)
                    .backgroundStyle(Color(.white))
                    .confirmationDialog("Really leave group?", isPresented: $isPresentingLeaveConfirm) {
                        Button("Leave group", role: .destructive) {
                            Task {
                                await model.leaveGroup(auth: try! environ.tokenAuth)

                                if model.isSuccess {
                                    dismiss()
                                }
                            }
                        }
                    }
                }
            }
            .padding()

            if selectedTab == .events {
                EventList(events: model.events)
            } else {
                List(model.group.users) { user in
                    UserListItemView(user: user)
                }
            }

            Spacer()
        }
        .onAppear(perform: refreshEvents)
    }

    func refreshEvents() {
        Task {
            await model.refreshEvents(auth: environ.tokenAuth)
        }
    }
}

#Preview {
    GroupDetailView(group: GroupListModel(id: UUID(), code: "123123", name: "My Group", users: [
        UserModel(id: UUID(), name: "John Doe"),
        UserModel(id: UUID(), name: "John Doe"),
    ]))
}

#Preview {
    GroupDetailView(group: GroupListModel(id: UUID(), code: "123123", name: "Cosi Kdesi", users: [
        UserModel(id: UUID(), name: "John Doe"),
        UserModel(id: UUID(), name: "John Doe"),
    ]), initialTab: .users)
}
