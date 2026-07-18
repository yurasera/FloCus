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
    
    @State private var pomodoroManager = PomodoroManager()
    @Environment(\.scenePhase) private var scenePhase

    init() {
        do {
            container = try ModelContainer(for: Category.self, Task.self)
            try SeedData.seedCategories(in: ModelContext(container))
        } catch {
            fatalError("Failed to initialize SwiftData container: \(error)")
        }
        
        // Request notification permission
        requestNotificationPermission()
    }

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(pomodoroManager)
        }
        .modelContainer(container)
        .onChange(of: scenePhase) { oldPhase, newPhase in
            handleScenePhaseChange(oldPhase: oldPhase, newPhase: newPhase)
        }
    }
    
    // MARK: - Scene Phase Management
    
    private func handleScenePhaseChange(oldPhase: ScenePhase, newPhase: ScenePhase) {
        switch newPhase {
        case .active:
            // App kembali aktif - restore timer state
            pomodoroManager.restoreStateIfNeeded()
            
        case .background:
            // App masuk background - save current state
            pomodoroManager.saveStateWhenEnteringBackground()
            
        case .inactive:
            // Transisi state, tidak perlu action khusus
            break
            
        @unknown default:
            break
        }
    }
    
    // MARK: - Notification Permission
    
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error requesting notification permission: \(error.localizedDescription)")
            }
        }
    }
}
