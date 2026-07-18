//
//  FocusView.swift
//  Flocus
//
//  Created by Yuhaya Lissera on 02/07/26.
//

import SwiftUI
import UserNotifications
internal import Combine

struct FocusView: View {
    let task: Task
    let stopFocus: () -> Void
    
    @Environment(PomodoroManager.self) private var pomodoroManager
    @State private var viewModel = FocusViewModel()

    private let focusTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack(spacing: 0) {
            FocusHeader(
                categoryName: task.category?.name,
                focusDurationText: viewModel.focusDurationText(for: task),
                viewModel: viewModel
            )
            .padding(.top, 48)

            Spacer()

            FocusTaskInfo(task: task)

            Spacer()

            FocusTimerSection(
                task: task,
                pomodoroManager: pomodoroManager,
                viewModel: viewModel
            )
            .padding(.top, 24)

            Spacer()

            FocusActionButton(action: stopFocus)
                .padding(.bottom, 48)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(32)
        .background(viewModel.backgroundColor(for: task.category?.name))
        .foregroundStyle(viewModel.textColor(for: task.category?.name))
        .onAppear {
            // ViewModel initializes haptics in init
        }
        .onReceive(focusTimer) { date in
            viewModel.now = date
        }
    }
}

private struct FocusHeader: View {
    let categoryName: String?
    let focusDurationText: String
    let viewModel: FocusViewModel
    
    var body: some View {
        HStack(spacing: 8) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Focus")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .textCase(.uppercase)
                    .foregroundStyle(.secondary)
                Text(categoryName ?? "Uncategorized")
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
    }
}

private struct FocusTaskInfo: View {
    let task: Task
    
    var body: some View {
        VStack(spacing: 12) {
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
        }
    }
}

private struct FocusTimerSection: View {
    let task: Task
    let pomodoroManager: PomodoroManager
    let viewModel: FocusViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            if pomodoroManager.isRunning {
                Text(pomodoroManager.currentTask?.title ?? "")
                    .font(.headline)
                    .multilineTextAlignment(.center)

                Text(viewModel.formatTime(pomodoroManager.remainingTime))
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
                HStack(spacing: 8) {
                    FocusTimerButton(
                        label: "25 min",
                        duration: 25 * 60,
                        task: task,
                        pomodoroManager: pomodoroManager,
                        viewModel: viewModel
                    )
                    
                    FocusTimerButton(
                        label: "5 min",
                        duration: 5 * 60,
                        task: task,
                        pomodoroManager: pomodoroManager,
                        viewModel: viewModel
                    )
                    
                    FocusTimerButton(
                        label: "15 min",
                        duration: 15 * 60,
                        task: task,
                        pomodoroManager: pomodoroManager,
                        viewModel: viewModel
                    )
                }
            }
        }
    }
}

private struct FocusTimerButton: View {
    let label: String
    let duration: Int
    let task: Task
    let pomodoroManager: PomodoroManager
    let viewModel: FocusViewModel
    
    var body: some View {
        Button(label) {
            viewModel.requestNotificationPermission()
            pomodoroManager.startPomodoro(for: task, duration: TimeInterval(duration))
            viewModel.playStartHaptic()
            viewModel.playStartSound()
        }
        .font(.caption)
        .padding(.horizontal, 24)
        .padding(.vertical, 12)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .glassEffect()
    }
}

private struct FocusActionButton: View {
    let action: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Button("Stop Focus", action: action)
                .font(.headline)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .clipShape(RoundedRectangle(cornerRadius: 24))
                .glassEffect()
        }
    }
}

#Preview {
    FocusView(task: Task(title: "Test", notes: "Test notes", category: nil), stopFocus: {})
}
