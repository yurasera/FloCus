//
//  CategoryKind.swift
//  Flocus
//
//  Created by Yuhaya Lissera on 06/07/26.
//

import SwiftUI

enum CategoryKind {
    case learn
    case projects
    case hobbies

    var title: String {
        switch self {
        case .learn: return "Learn"
        case .projects: return "Projects"
        case .hobbies: return "Hobbies"
        }
    }

    // Header title color for SectionHeader
    var headerColor: Color {
        switch self {
        case .learn: return Color.brandTertiary
        case .projects: return Color.brandTertiary
        case .hobbies: return Color.brandPrimary
        }
    }

    // Background color of the section container
    var backgroundColor: Color {
        switch self {
        case .learn: return Color.brandPrimary
        case .projects: return Color.brandSecondary
        case .hobbies: return Color.brandTertiary
        }
    }

    // Cards to display for each category from model tasks.
    @ViewBuilder
    func cards(for tasks: [Task]) -> some View {
        let limited = Array(tasks.prefix(2))
        if limited.isEmpty {
            // Show two empty placeholder cards when there is no data
                HomeCategoryCard(
                title: "",
                description: "",
                background: headerColor,
                foreground: backgroundColor,
                task: nil
            )
                HomeCategoryCard(
                title: "",
                description: "",
                background: headerColor,
                foreground: backgroundColor,
                task: nil
            )
        } else {
            ForEach(limited) { task in
                    HomeCategoryCard(
                    title: task.title,
                    description: task.notes,
                    background: headerColor,
                    foreground: backgroundColor,
                    task: task
                )
            }
        }
    }
}
