//
//  StatusSection.swift
//  Flocus
//
//  Created by Yuhaya Lissera on 06/07/26.
//
import SwiftUI

struct StatusSection: View {
    let learnCount: Int
    let projectsCount: Int
    let hobbiesCount: Int

    @Binding var isLearnVisible: Bool
    @Binding var isProjectsVisible: Bool
    @Binding var isHobbiesVisible: Bool

    init(
        learnCount: Int = 0,
        projectsCount: Int = 0,
        hobbiesCount: Int = 0,
        isLearnVisible: Binding<Bool>,
        isProjectsVisible: Binding<Bool>,
        isHobbiesVisible: Binding<Bool>
    ) {
        self.learnCount = learnCount
        self.projectsCount = projectsCount
        self.hobbiesCount = hobbiesCount
        _isLearnVisible = isLearnVisible
        _isProjectsVisible = isProjectsVisible
        _isHobbiesVisible = isHobbiesVisible
    }

    var body: some View {
        VStack {
            Spacer()
            VStack(spacing: Spacing.medium) {
                HStack(spacing: Spacing.medium) {
                    // Learn
                    Button {
                        withAnimation(.snappy) { isLearnVisible.toggle() }
                    } label: {
                        StatusBadge(color: Color.brandPrimary, count: learnCount)
                    }
                    .buttonStyle(.plain)

                    // Projects
                    Button {
                        withAnimation(.snappy) { isProjectsVisible.toggle() }
                    } label: {
                        StatusBadge(color: Color.brandSecondary, count: projectsCount)
                    }
                    .buttonStyle(.plain)

                    // Hobbies
                    Button {
                        withAnimation(.snappy) { isHobbiesVisible.toggle() }
                    } label: {
                        StatusBadge(color: Color.brandTertiary, count: hobbiesCount)
                    }
                    .buttonStyle(.plain)
                }
            }
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(Color.brandPrimary)
    }
}
