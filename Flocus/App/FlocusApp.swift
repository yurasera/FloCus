//
//  FlocusApp.swift
//  Flocus
//
//  Created by Yuhaya Lissera on 23/06/26.
//

import SwiftUI
import SwiftData
import OSLog

@main
struct FlocusApp: App {
    private let container: ModelContainer
    
    @State private var pomodoroManager = PomodoroManager()
    @Environment(\.scenePhase) private var scenePhase
    private static let logger = Logger(subsystem: "com.yuhayalissera.Flocus", category: "App")

    init() {
        do {
            container = try ModelContainer(for: Category.self, Task.self)
            try SeedData.seedCategories(in: ModelContext(container))
        } catch {
            Self.logger.critical("Failed to initialize SwiftData container: \(error)")
            fatalError("Failed to initialize SwiftData container: \(error)") // Keep fatalError for unrecoverable startup failure
        }
        
    }

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(pomodoroManager)
        }
        .modelContainer(container)
        .onChange(of: scenePhase) { newPhase in
            handleScenePhaseChange(newPhase: newPhase)
        }
    }
    
    // MARK: - Scene Phase Management
    
    private func handleScenePhaseChange(newPhase: ScenePhase) {
        switch newPhase {
        case .active:
            pomodoroManager.restoreStateIfNeeded()
        case .background:
            pomodoroManager.saveStateWhenEnteringBackground()
        @unknown default:
            break
        }
    }
    
}
