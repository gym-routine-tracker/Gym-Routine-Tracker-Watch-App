//
//  WatchRoutineList.swift
//  Gym Routine Tracker
//
//  Created by Reed Esau on 12/22/22.
//

import SwiftUI

import GroutLib
import GroutUI

struct WatchRoutineList: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject private var router: MyRouter

    var standardViews: StandardViews

    var body: some View {
        RoutineList(standardViews: standardViews) {
            Group {
                addButton
                settingsButton
                aboutButton
            }
            .font(.title3)
            .tint(routineColor)
            .foregroundStyle(.tint)
        }
    }

    private var addButton: some View {
        AddRoutineButton {
            Label("Add Routine", systemImage: "plus.circle.fill")
                .symbolRenderingMode(.hierarchical)
        }
    }

    private var settingsButton: some View {
        Button(action: settingsAction) {
            Label("Settings", systemImage: "gear.circle")
                .symbolRenderingMode(.hierarchical)
        }
    }

    private var aboutButton: some View {
        Button(action: aboutAction) {
            Label(title: { Text("About") }, icon: {
                AppIcon(name: "grt_icon")
                    .frame(width: 24, height: 24)
            })
        }
    }

    private func settingsAction() {
        router.path.append(MyRoutes.settings)
    }

    private func aboutAction() {
        router.path.append(MyRoutes.about)
    }
}

// struct WatchRoutineList_Previews: PreviewProvider {
//    static var previews: some View {
//        WatchRoutineList()
//    }
// }