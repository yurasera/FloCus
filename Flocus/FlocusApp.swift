//
//  FlocusApp.swift
//  Flocus
//
//  Created by Yuhaya Lissera on 23/06/26.
//

import SwiftUI
import SwiftData

@main
struct FlocusApp: App {
    private let container: ModelContainer

    init() {
        do {
            container = try ModelContainer(for: Category.self, Task.self)
            try SeedData.seedCategories(in: ModelContext(container))
        } catch {
            fatalError("Failed to initialize SwiftData container: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(container)
    }
}
