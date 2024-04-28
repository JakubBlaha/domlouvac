import SwiftUI

struct GroupsView: View {
    @EnvironmentObject var environ: EnvironModel
    @ObservedObject var model = GroupsViewModel()

    var body: some View {
        NavigationView {
            List(model.myGroups) { group in
                NavigationLink {
                    GroupDetailView(group: group)
                } label: {
                    GroupListItemView(group: group)
                }
            }
            .navigationTitle("Your Groups")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: CreateGroupView()) {
                        Text("New Group")
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: JoinGroupView()) {
                        Text("Join")
                    }
                }
            }
        }.onAppear {
            Task {
                await self.model.fetchMyGroups(auth: try! environ.tokenAuth)
            }
        }
    }
}

#Preview {
    GroupsView()
}
