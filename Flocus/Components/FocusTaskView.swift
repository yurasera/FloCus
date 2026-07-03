//
//  FocusTaskView.swift
//  Flocus
//
//  Created by Yuhaya Lissera on 02/07/26.
//

import SwiftUI
internal import Combine

struct FocusTaskView: View {
    let task: Task
    let stopFocus: () -> Void
    @State private var now = Date()
    @State private var pomodoroRemaining = 0
    @State private var isPomodoroRunning = false
    @State private var pomodoroType = ""

    private let focusTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    private let pomodoroTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

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

                if isPomodoroRunning {

                    Text(pomodoroType)
                        .font(.headline)

                    Text(pomodoroTimeText)
                        .font(.system(size: 48, weight: .bold, design: .monospaced))

                    Button("Stop Pomodoro") {
                        stopPomodoro()
                    }
                    .font(.headline)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .glassEffect()

                } else {
                    HStack(spacing: 8){
                        Button("25 min") {
                            startPomodoro(minutes: 25, title: "Task")
                        }
                        .font(.caption)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .clipShape(RoundedRectangle(cornerRadius: 24))
                        .glassEffect()
                        
                        Button("5 min") {
                            startPomodoro(minutes: 5, title: "Quick Break")
                        }
                        .font(.caption)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .clipShape(RoundedRectangle(cornerRadius: 24))
                        .glassEffect()
                        
                        Button("15 min") {
                            startPomodoro(minutes: 15, title: "Long Break")
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
        .onReceive(focusTimer) { date in
            now = date
        }
        .onReceive(pomodoroTimer) { _ in
            guard isPomodoroRunning else { return }

            if pomodoroRemaining > 0 {
                pomodoroRemaining -= 1
            } else {
                stopPomodoro()
            }
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
    
    private func startPomodoro(minutes: Int, title: String) {
        pomodoroRemaining = minutes * 60
        pomodoroType = title
        isPomodoroRunning = true
    }

    private func stopPomodoro() {
        isPomodoroRunning = false
        pomodoroRemaining = 0
        pomodoroType = ""
    }

    private var pomodoroTimeText: String {
        let minutes = pomodoroRemaining / 60
        let seconds = pomodoroRemaining % 60

        return String(format: "%02d:%02d", minutes, seconds)
    }
}
