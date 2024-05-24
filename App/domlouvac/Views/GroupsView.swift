import SwiftUI

struct GroupsView: View {
    @EnvironmentObject var environ: EnvironModel
    @ObservedObject var model = GroupsViewModel()

    @State var needsUpdate = false

    var body: some View {
        VStack {
            NavigationView {
                VStack {
                    if model.myGroups.isEmpty {
                        Text("No groups to show.")
                            .fontWeight(.medium)
                            .foregroundColor(.gray)
                    } else {
                        List(model.myGroups, id: \.self.id) { group in
                            NavigationLink {
                                GroupDetailView(group: group)
                            } label: {
                                GroupListItemView(group: group)
                            }
                            .navigationTitle("Your Groups")
                        }
                    }
                }
                .onAppear(perform: refresh)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: CreateGroupView().onDisappear(perform: refresh)) {
                            Text("New Group")
                        }
                    }

                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: JoinGroupView().onDisappear(perform: refresh)) {
                            Text("Join")
                        }
                    }
                }
            }
        }
    }

    func refresh() {
        Task {
            await self.model.fetchMyGroups(auth: environ.tokenAuth)
        }
    }
}

#Preview {
    GroupsView()
}
