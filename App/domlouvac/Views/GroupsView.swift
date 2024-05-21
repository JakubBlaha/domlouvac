import SwiftUI

struct GroupsView: View {
    @EnvironmentObject var environ: EnvironModel
    @ObservedObject var model = GroupsViewModel()

    @State var needsUpdate = false

    var body: some View {
        VStack {
            NavigationView {
                List(model.myGroups) { group in
                    NavigationLink {
                        GroupDetailView(group: group).onDisappear(perform: refresh)
                    } label: {
                        GroupListItemView(group: group)
                    }
                    .navigationTitle("Your Groups")
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
            await self.model.fetchMyGroups(auth: try! environ.tokenAuth)
        }
    }
}

#Preview {
    GroupsView()
}
