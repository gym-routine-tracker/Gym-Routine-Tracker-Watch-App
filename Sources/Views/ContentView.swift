//
//  ContentView.swift
//
// Copyright 2022  OpenAlloc LLC
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.
//

import CoreData
import SwiftUI

import GroutLib
import GroutUI

struct ContentView: View {
    @SceneStorage("routines-router") private var routinesNavData: Data?

    @SceneStorage("middle-mode") private var middleMode: ExerciseMiddleRowMode = .intensity

    var body: some View {
        let factory = WatchFactory(middleMode: $middleMode)
        NavStack(name: "main", factory: factory, navData: $routinesNavData) {
            factory.routineList()
        }
    }
}

// TODO: four copies of each routine showing up; should be one!
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let ctx = PersistenceManager.preview.container.viewContext
        let routine = Routine.create(ctx, userOrder: 0)
        routine.name = "Back & Bicep"
        let e1 = Exercise.create(ctx, userOrder: 0)
        e1.name = "Lat Pulldown"
        e1.routine = routine
        let e2 = Exercise.create(ctx, userOrder: 1)
        e2.name = "Arm Curl"
        e2.routine = routine
        return ContentView()
            .environment(\.managedObjectContext, ctx)
    }
}
