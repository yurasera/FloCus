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

    init(learnCount: Int = 0, projectsCount: Int = 0, hobbiesCount: Int = 0) {
        self.learnCount = learnCount
        self.projectsCount = projectsCount
        self.hobbiesCount = hobbiesCount
    }

    var body: some View {
        VStack {
            Spacer()
            HStack(spacing: Spacing.medium) {
                // Learn
                StatusBadge(color: Color.brandPrimary, count: learnCount)
                // Projects
                StatusBadge(color: Color.brandSecondary, count: projectsCount)
                // Hobbies
                StatusBadge(color: Color.brandTertiary, count: hobbiesCount)
            }
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(Color.brandPrimary)
    }
}
