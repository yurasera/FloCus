//
//  PomodoroManager.swift
//  Flocus
//
//  Created by Yuhaya Lissera on 05/07/26.
//

import SwiftUI
import SwiftData
import UserNotifications

@Observable
final class PomodoroManager {
    // MARK: - Published Properties
    var isRunning = false
    var remainingTime: TimeInterval = 0
    var currentTask: Task?
    
    // MARK: - Private Properties
    private var timer: Timer?
    private let defaults = UserDefaults.standard
    
    // MARK: - Keys for UserDefaults
    private let startDateKey = "pomodoroStartDate"
    private let endDateKey = "pomodoroEndDate"
    private let durationKey = "pomodoroDuration"
    private let taskIdKey = "pomodoroTaskId"
    private let isRunningKey = "pomodoroIsRunning"
    
    // MARK: - Constants
    let defaultDuration: TimeInterval = 25 * 60 // 25 minutes
    
    // MARK: - Initialization
    init() {
        restoreStateIfNeeded()
    }
    
    // MARK: - Public Methods
    
    /// Start Pomodoro timer untuk task tertentu
    func startPomodoro(for task: Task, duration: TimeInterval? = nil) {
        stopPomodoro() // Stop timer yang sedang berjalan jika ada
        
        let duration = duration ?? defaultDuration
        let now = Date()
        let endDate = now.addingTimeInterval(duration)
        
        // Save to UserDefaults
        defaults.set(now, forKey: startDateKey)
        defaults.set(endDate, forKey: endDateKey)
        defaults.set(duration, forKey: durationKey)
        defaults.set(task.persistentModelID.hashValue, forKey: taskIdKey)
        defaults.set(true, forKey: isRunningKey)
        
        // Update state
        currentTask = task
        isRunning = true
        remainingTime = duration
        
        // Update task status
        task.status = .focus
        task.focusStartedAt = now
        try? task.modelContext?.save()
        
        // Schedule local notification
        scheduleCompletionNotification(duration: duration)
        
        // Start UI update timer (only for foreground)
        startUIUpdateTimer()
    }
    
    /// Stop Pomodoro timer
    func stopPomodoro() {
        timer?.invalidate()
        timer = nil
        isRunning = false
        
        // Clear UserDefaults
        defaults.removeObject(forKey: startDateKey)
        defaults.removeObject(forKey: endDateKey)
        defaults.removeObject(forKey: durationKey)
        defaults.removeObject(forKey: taskIdKey)
        defaults.removeObject(forKey: isRunningKey)
        
        // Cancel pending notifications
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    /// Complete Pomodoro session
    func completePomodoro() {
        stopPomodoro()
        
        if let task = currentTask {
            task.status = .completed
            task.completedAt = .now
            try? task.modelContext?.save()
        }
        
        currentTask = nil
        remainingTime = 0
    }
    
    /// Handle app entering background - save current state
    func saveStateWhenEnteringBackground() {
        guard isRunning else { return }
        // State sudah disimpan di startPomodoro, tidak perlu save lagi
    }
    
    /// Handle app becoming active - restore dan update timer
    func restoreStateIfNeeded() {
        guard let endDateData = defaults.object(forKey: endDateKey) as? Date else {
            return
        }
        
        let endDate = endDateData
        let now = Date()
        
        // Cek apakah sesi sudah selesai
        if now >= endDate {
            // Sesi sudah selesai
            completePomodoro()
            
            // Trigger haptic
            triggerCompletionHaptic()
            
            // Show notification jika aplikasi masih di background saat itu
            showCompletionNotification()
            
            return
        }
        
        // Restore state
        if let startDateData = defaults.object(forKey: startDateKey) as? Date,
           let duration = defaults.object(forKey: durationKey) as? TimeInterval,
           let isRunningData = defaults.bool(forKey: isRunningKey) as? Bool,
           isRunningData {
            
            isRunning = true
            remainingTime = endDate.timeIntervalSince(now)
            
            // Start UI update timer
            startUIUpdateTimer()
        }
    }
    
    /// Update remaining time saat aplikasi active
    func updateRemainingTime() {
        guard isRunning,
              let endDateData = defaults.object(forKey: endDateKey) as? Date else {
            return
        }
        
        let remaining = endDateData.timeIntervalSince(Date())
        
        if remaining <= 0 {
            completePomodoro()
            triggerCompletionHaptic()
        } else {
            remainingTime = remaining
        }
    }
    
    // MARK: - Private Methods
    
    private func startUIUpdateTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            self?.updateRemainingTime()
        }
    }
    
    private func scheduleCompletionNotification(duration: TimeInterval) {
        let content = UNMutableNotificationContent()
        content.title = "Pomodoro Selesai"
        content.body = "Sesi fokus Anda telah selesai. Bagus!"
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: duration, repeats: false)
        let request = UNNotificationRequest(identifier: "pomodoroCompletion", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            }
        }
    }
    
    private func showCompletionNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Pomodoro Selesai"
        content.body = "Sesi fokus Anda telah selesai!"
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "pomodoroCompleted", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    private func triggerCompletionHaptic() {
        let impact = UIImpactFeedbackGenerator(style: .heavy)
        impact.impactOccurred()
    }
    
    deinit {
        timer?.invalidate()
    }
}
