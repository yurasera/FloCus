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

    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 8) {
                Text("Focus")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .textCase(.uppercase)
                    .foregroundStyle(.secondary)

                Text(focusDurationText)
                    .font(.title2)
                    .fontWeight(.bold)
                    .monospacedDigit()
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

            Spacer()

            VStack(spacing: 16) {
                Text(task.category?.name ?? "Uncategorized")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .textCase(.uppercase)
                    .foregroundStyle(.secondary)

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
        .background(Color.brandPrimary)
        .foregroundStyle(.white)
        .onReceive(timer) { date in
            now = date
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
}
