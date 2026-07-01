//
//  ContentView.swift
//  Flocus
//
//  Created by Yuhaya Lissera on 23/06/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext)
    private var context
    @Query private var categories: [Category]
    @Query private var tasks: [Task]
    var body: some View {
        HStack(spacing: 0) {
            // Kiri: 3 bagian vertikal
            VStack(spacing: 0) {
                HeroSection(categories: categories)
                CategorySection(category: .learn, tasks: tasks)
                StatusSection()
            }

            // Kanan: 2 bagian vertikal
            VStack(spacing: 0) {
                CategorySection(category: .projects, tasks: tasks)
                CategorySection(category: .hobbies, tasks: tasks)
            }
        }
        .ignoresSafeArea()
        .task {
            do {
                try SeedData.seedCategories(in: context)
            } catch {
                print("Seed failed:", error)
            }
        }
    }
}

// MARK: - Sections

struct HeroSection: View {
    let categories: [Category]
    var body: some View {
        VStack {
            Spacer()
            VStack(alignment: .leading, spacing: Spacing.small) {
                Text("Flocus")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Three words.")
                    .font(.callout)
                Text("Three roles.")
                    .font(.callout)
                Text("One journey.")
                    .font(.callout)
                Text("Categories: \(categories.count)")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundColor(.white)
            .padding()
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(Color.brandPrimary)
    }
}

struct StatusSection: View {
    var body: some View {
        VStack {
            Spacer()
            HStack(spacing: Spacing.medium) {
                StatusBadge(color: Color.brandPrimary)
                StatusBadge(color: Color.brandSecondary)
                StatusBadge(color: Color.brandTertiary)
            }
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(Color.brandPrimary)
    }
}

// MARK: - Generic Category Section

enum CategoryKind {
    case learn
    case projects
    case hobbies

    var title: String {
        switch self {
        case .learn: return "Learn"
        case .projects: return "Project"
        case .hobbies: return "Hobbies"
        }
    }

    // Header title color for SectionHeader
    var headerColor: Color {
        switch self {
        case .learn: return Color.brandTertiary
        case .projects: return Color.brandTertiary
        case .hobbies: return Color.brandSecondary
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
        ForEach(tasks) { task in
            LearnCard(
                title: task.title,
                description: task.notes,
                background: headerColor,
                foreground: backgroundColor
            )
        }
    }
}

struct CategorySection: View {
    let category: CategoryKind
    let tasks: [Task]
    private var headerAction: () -> Void { { print("Add tapped") } }

    var body: some View {
        VStack {
            Spacer()
            VStack(alignment: .leading, spacing: Spacing.small) {
                SectionHeader(title: category.title, color: category.headerColor, action: headerAction)
                category.cards(for: tasks)
            }
            .foregroundColor(.white)
            .padding()
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(category.backgroundColor)
    }
}

#Preview {
    ContentView()
}
