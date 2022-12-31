//
//  WatchExerciseRun.swift
//
// Copyright 2022, 2023  OpenAlloc LLC
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.
//

import SwiftUI

import GroutLib
import GroutUI

struct WatchExerciseRun: View {
    // MARK: - Parameters

    @ObservedObject var exercise: Exercise
    @Binding var middleMode: ExerciseMiddleRowMode
    var onNextIncomplete: (Int16?) -> Void
    var hasNextIncomplete: () -> Bool
    var onEdit: (Exercise) -> Void
    var factory: Factory

    // MARK: - Views

    var body: some View {
        ExerciseRun(exercise: exercise,
                    onNextIncomplete: onNextIncomplete,
                    hasNextIncomplete: hasNextIncomplete,
                    onEdit: onEdit,
                    factory: factory) { geo, titleText, navigationRow in
            VStack {
                titleText
                    .frame(height: geo.size.height * 3 / 13)

                VStack {
                    switch middleMode {
                    case .intensity:
                        intensityView
                    case .settings:
                        settingsView
                    case .volume:
                        volumeView
                    }
                }
                .frame(height: geo.size.height * 5 / 13)

                navigationRow
                    .frame(height: geo.size.height * 5 / 13)
            }
        }
    }

    private var volumeView: some View {
        ExerciseRunMiddleRow(imageName: "dumbbell.fill",
                             imageColor: exerciseSetsColor,
                             onDetail: { onEdit(exercise) },
                             onTap: { middleMode = .intensity }) {
            TitleText("\(exercise.sets)/\(exercise.repetitions)")
                .foregroundStyle(textTintColor)
                .fontDesign(.monospaced)
        }
    }

    private var settingsView: some View {
        ExerciseRunMiddleRow(imageName: "gearshape.fill",
                             imageColor: exerciseGearColor,
                             onDetail: { onEdit(exercise) },
                             onTap: { middleMode = .volume }) {
            HStack {
                if exercise.primarySetting == 0, exercise.secondarySetting == 0 {
                    Text("None")
                        .font(.title2)
                        .foregroundStyle(exerciseGearColor)
                } else {
                    Group {
                        if exercise.primarySetting > 0 {
                            NumberImage(exercise.primarySetting, isCircle: true, disabled: isDone)
                        }
                        if exercise.secondarySetting > 0 {
                            NumberImage(exercise.secondarySetting, isCircle: false, disabled: isDone)
                        }
                    }
                    // .symbolRenderingMode(.hierarchical)
                    .imageScale(.large)
                    .font(.title)
                }
            }
        }
    }

    private var intensityView: some View {
        Stepper(value: $exercise.lastIntensity,
                in: 0.0 ... intensityMaxValue,
                step: exercise.intensityStep) {
            TitleText(
                exercise.formatIntensity(exercise.lastIntensity, withUnits: true)
            )
        }
        .symbolRenderingMode(.hierarchical)
        .disabled(isDone)
        .foregroundColor(textTintColor)
        .contentShape(Rectangle())
        .onTapGesture {
            middleMode = .settings
        }
    }

    // MARK: - Helpers

    private var textTintColor: Color {
        isDone ? completedColor : .primary
    }

    private var isDone: Bool {
        exercise.isDone
    }
}

struct WatchExerciseRun_Previews: PreviewProvider {
    struct TestHolder: View {
        var exercise: Exercise
        @State var middleMode: ExerciseMiddleRowMode = .intensity
        var body: some View {
            WatchExerciseRun(exercise: exercise,
                             middleMode: $middleMode,
                             onNextIncomplete: { _ in },
                             hasNextIncomplete: { true },
                             onEdit: { _ in },
                             factory: WatchFactory(middleMode: $middleMode))
        }
    }

    static var previews: some View {
        let ctx = PersistenceManager.preview.container.viewContext
        let routine = Routine.create(ctx, userOrder: 0)
        routine.name = "Back & Bicep"
        let e1 = Exercise.create(ctx, userOrder: 0)
        e1.name = "Lat Pulldown"
        e1.routine = routine
        e1.primarySetting = 4
        e1.secondarySetting = 6
        e1.units = Units.kilograms.rawValue
        e1.intensityStep = 7.1
        // e1.units = Units.pounds.rawValue
        return NavigationStack {
            TestHolder(exercise: e1)
        }
    }
}
