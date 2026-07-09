//
//  FlocusPomodoroWidgetLiveActivity.swift
//  FlocusPomodoroWidget
//
//  Created by Yuhaya Lissera on 09/07/26.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct FlocusPomodoroWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: PomodoroAttributes.self) { context in
            PomodoroLockScreenView(context: context)
                .activityBackgroundTint(.black.opacity(0.92))
                .activitySystemActionForegroundColor(.white)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Label(context.state.sessionName, systemImage: "timer")
                        .font(.caption.weight(.semibold))
                }

                DynamicIslandExpandedRegion(.center) {
                    VStack(spacing: 6) {
                        Text(timerInterval: Date.now...context.state.endDate, countsDown: true)
                            .font(.system(size: 34, weight: .bold, design: .monospaced))
                            .minimumScaleFactor(0.7)

                        ProgressView(value: context.state.progress)
                            .tint(.red)
                    }
                }

                DynamicIslandExpandedRegion(.trailing) {
                    PomodoroStatusPill(state: context.state.state)
                }

                DynamicIslandExpandedRegion(.bottom) {
                    VStack(spacing: 8) {
                        Text(context.attributes.taskTitle)
                            .font(.headline)
                            .lineLimit(1)

                        HStack {
                            Text(timerInterval: Date.now...context.state.endDate, countsDown: true)
                                .font(.caption.monospacedDigit())
                            Spacer()
                            Text(progressText(context.state.progress))
                                .font(.caption.weight(.semibold))
                        }

                        ProgressView(value: context.state.progress)
                            .tint(.red)
                    }
                    .padding(.top, 4)
                }
            } compactLeading: {
                Text("🍅")
            } compactTrailing: {
                Text(timerInterval: Date.now...context.state.endDate, countsDown: true)
                    .font(.caption2.monospacedDigit())
                    .frame(width: 48)
            } minimal: {
                Text("🍅")
            }
        }
    }
}

private struct PomodoroLockScreenView: View {
    let context: ActivityViewContext<PomodoroAttributes>

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(context.state.sessionName)
                        .font(.headline)
                    Text(context.attributes.taskTitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                PomodoroStatusPill(state: context.state.state)
            }

            Text(timerInterval: Date.now...context.state.endDate, countsDown: true)
                .font(.system(size: 40, weight: .bold, design: .monospaced))
                .contentTransition(.numericText())

            ProgressView(value: context.state.progress)
                .tint(.red)
        }
        .padding()
    }
}

private struct PomodoroStatusPill: View {
    let state: PomodoroSessionState

    var body: some View {
        Text(title)
            .font(.caption.weight(.semibold))
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(.white.opacity(0.15), in: Capsule())
    }

    private var title: String {
        switch state {
        case .running: return "Running"
        case .paused: return "Paused"
        case .finished: return "Finished"
        }
    }
}

private func progressText(_ progress: Double) -> String {
    "\(Int(progress * 100))%"
}

#Preview("Notification", as: .content, using: PomodoroAttributes(taskId: "1", taskTitle: "Design Sprint", taskCategory: "Focus")) {
   FlocusPomodoroWidgetLiveActivity()
} contentStates: {
    PomodoroAttributes.ContentState(sessionName: "Focus", remainingTime: 1500, totalDuration: 1500, startDate: .now, endDate: .now.addingTimeInterval(1500), progress: 0.25, state: .running)
    PomodoroAttributes.ContentState(sessionName: "Short Break", remainingTime: 300, totalDuration: 300, startDate: .now, endDate: .now.addingTimeInterval(300), progress: 0.5, state: .paused)
}
