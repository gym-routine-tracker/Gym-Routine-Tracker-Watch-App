//
//  WatchStandardViews.swift
//  Gym Routine Tracker
//
//  Created by Reed Esau on 12/22/22.
//

import SwiftUI

import GroutLib
import GroutUI

struct WatchStandardViews: StandardViews {
    
    @Binding var middleMode: ExerciseMiddleRowMode
    
    func routineDetail(routine: Routine) -> AnyView {
        WatchRoutineDetail(routine: routine).eraseToAnyView()
    }

    func exerciseDetail(exercise: Exercise) -> AnyView {
        WatchExerciseDetail(exercise: exercise).eraseToAnyView()
    }

    func exerciseRun(exercise: Exercise,
                     nextAction: @escaping (Int16?) -> Void,
                     hasNextIncomplete: @escaping () -> Bool,
                     selectedExercise: Binding<Exercise?>) -> AnyView
    {
        WatchExerciseRun(exercise: exercise,
                         middleMode: $middleMode,
                         nextAction: nextAction,
                         hasNextIncomplete: hasNextIncomplete,
                         selectedExercise: selectedExercise).eraseToAnyView()
    }

    func navigationStack(navData: Binding<Data?>,
                          rootContent: @escaping () -> AnyView) -> AnyView
    {
        WatchNavigationStack(navData: navData,
                             middleMode: $middleMode,
                             rootContent: rootContent).eraseToAnyView()
    }
}
