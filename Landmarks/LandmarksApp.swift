//
//  LandmarksApp.swift
//  Landmarks
//
//  Created by Chidi Nna on 2/3/25.
//

import SwiftUI


@main
struct LandmarksApp: App {
    @State private var modelData = ModelData()


    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(modelData)
        }
    }
}
