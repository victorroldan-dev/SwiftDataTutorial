//
//  SwiftDataTutorialApp.swift
//  SwiftDataTutorial
//
//

import SwiftUI
import SwiftData

@main
struct SwiftDataTutorialApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [CountryModel.self])
    }
}
