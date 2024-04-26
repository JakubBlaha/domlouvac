//
//  GroupsView.swift
//  domlouvac
//
//  Created by Jakub Bláha on 25.04.2024.
//

import SwiftUI

struct GroupsView: View {
    var body: some View {
        NavigationView {
            List(groups) {group in
                GroupListItemView()
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
        }
    }
}

#Preview {
    GroupsView()
}
