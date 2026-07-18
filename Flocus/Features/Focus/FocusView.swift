//
//  FocusView.swift
//  Flocus
//
//  Created by Yuhaya Lissera on 02/07/26.
//

import SwiftUI
import CoreHaptics
import AudioToolbox
internal import Combine

struct FocusView: View {
    let task: Task
    let stopFocus: () -> Void
    
    @Environment(PomodoroManager.self) private var pomodoroManager
    @State private var now = Date()
    @State private var hapticEngine: CHHapticEngine?

    private let focusTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 8) {
                VStack(alignment: .leading, spacing: 8){
                    Text("Focus")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .textCase(.uppercase)
                        .foregroundStyle(.secondary)
                    Text(task.category?.name ?? "Uncategorized")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .textCase(.uppercase)
                        .foregroundStyle(.secondary)
                }
                Spacer()

                Text(focusDurationText)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .textCase(.uppercase)
                    .foregroundStyle(.secondary)
            }
            .padding(.top, 48)

            Spacer()

            Text(task.title)
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)

            if !task.notes.isEmpty {
                Text(task.notes)
                    .font(.title3)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            VStack(spacing: 16) {

                if pomodoroManager.isRunning {

                    Text(pomodoroManager.currentTask?.title ?? "")
                        .font(.headline)
                        .multilineTextAlignment(.center)

                    Text(formatTime(pomodoroManager.remainingTime))
                        .font(.system(size: 48, weight: .bold, design: .monospaced))

                    Button("Stop Pomodoro") {
                        pomodoroManager.stopPomodoro()
                    }
                    .font(.headline)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .glassEffect()

                } else {
                    HStack(spacing: 8){
                        Button("25 min") {
                            requestNotificationPermission()
                            pomodoroManager.startPomodoro(for: task, duration: 25 * 60)
                            playStartHaptic()
                            playStartSound()
                        }
                        .font(.caption)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .clipShape(RoundedRectangle(cornerRadius: 24))
                        .glassEffect()
                        
                        Button("5 min") {
                            requestNotificationPermission()
                            pomodoroManager.startPomodoro(for: task, duration: 5 * 60)
                            playStartHaptic()
                            playStartSound()
                        }
                        .font(.caption)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .clipShape(RoundedRectangle(cornerRadius: 24))
                        .glassEffect()
                        
                        Button("15 min") {
                            requestNotificationPermission()
                            pomodoroManager.startPomodoro(for: task, duration: 15 * 60)
                            playStartHaptic()
                            playStartSound()
                        }
                        .font(.caption)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .clipShape(RoundedRectangle(cornerRadius: 24))
                        .glassEffect()
                    }
                }
            }
            .padding(.top, 24)

            Spacer()

            VStack(spacing: 16) {

                Button("Stop Focus", action: stopFocus)
                    .font(.headline)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .glassEffect()
            }
            .padding(.bottom, 48)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(32)
        .background(color(for: task.category?.name))
        .foregroundStyle(textColor(for: task.category?.name))
        .onAppear {
            prepareHaptics()
        }
        .onReceive(focusTimer) { date in
            now = date
        }
    }
    
    private func color(for categoryName: String?) -> Color {
        switch categoryName {
        case CategoryKind.learn.title:
            return Color.brandPrimary
        case CategoryKind.projects.title:
            return Color.brandSecondary
        case CategoryKind.hobbies.title:
            return Color.brandTertiary
        default:
            return .secondary
        }
    }
    
    private func textColor(for categoryName: String?) -> Color {
        switch categoryName {
        case CategoryKind.learn.title:
            return Color.brandTertiary
        case CategoryKind.projects.title:
            return Color.brandTertiary
        case CategoryKind.hobbies.title:
            return Color.brandPrimary
        default:
            return .secondary
        }
    }

    private var focusDurationText: String {
        let startDate = task.focusStartedAt ?? task.createdAt
        let duration = max(0, Int(now.timeIntervalSince(startDate)))
        let hours = duration / 3600
        let minutes = (duration % 3600) / 60
        let seconds = duration % 60

        if hours > 0 {
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        }

        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    private func formatTime(_ timeInterval: TimeInterval) -> String {
        let minutes = Int(timeInterval) / 60
        let seconds = Int(timeInterval) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    private func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {
            return
        }

        do {
            hapticEngine = try CHHapticEngine()
            try hapticEngine?.start()
        } catch {
            print("Failed to start haptic engine: \(error)")
        }
    }
    
    private func playStartHaptic() {

        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics,
              let engine = hapticEngine else {
            return
        }

        do {

            let event = CHHapticEvent(
                eventType: .hapticContinuous,
                parameters: [
                    CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0),
                    CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.5)
                ],
                relativeTime: 0,
                duration: 0.8
            )

            let pattern = try CHHapticPattern(events: [event], parameters: [])

            let player = try engine.makePlayer(with: pattern)

            try player.start(atTime: 0)

        } catch {
            print(error)
        }
    }

    private func playFinishHaptic() {

        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics,
              let engine = hapticEngine else {
            return
        }

        do {

            let events = [

                CHHapticEvent(
                    eventType: .hapticContinuous,
                    parameters: [
                        CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0),
                        CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.8)
                    ],
                    relativeTime: 0,
                    duration: 1.0
                ),

                CHHapticEvent(
                    eventType: .hapticTransient,
                    parameters: [],
                    relativeTime: 1.1
                )
            ]

            let pattern = try CHHapticPattern(events: events, parameters: [])

            let player = try engine.makePlayer(with: pattern)

            try player.start(atTime: 0)

        } catch {
            print(error)
        }
    }
    
    private func playStartSound() {
        AudioServicesPlaySystemSound(1113)
    }

    private func playFinishSound() {
        AudioServicesPlaySystemSound(1005)
    }
    
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error requesting notification permission: \(error.localizedDescription)")
            }
        }
    }
}
