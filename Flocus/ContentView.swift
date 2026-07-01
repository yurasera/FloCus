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
    var body: some View {
        HStack(spacing: 0) {
            // Kiri: 3 bagian vertikal
            VStack(spacing: 0) {
                HeroSection(categories: categories)
                CategorySection(category: .learn)
                StatusSection()
            }

            // Kanan: 2 bagian vertikal
            VStack(spacing: 0) {
                CategorySection(category: .projects)
                CategorySection(category: .hobbies)
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

    // Cards to display for each category. Reuse existing sample content.
    @ViewBuilder
    var cards: some View {
        switch self {
        case .learn:
            LearnCard(
                title: "SwiftData",
                description: "Belajar penerapan SwiftData di Flocus.",
                background: Color.brandTertiary,
                foreground: Color.brandPrimary
            )
            LearnCard(
                title: "Prime App",
                description: "Create workout body understanding app using SwiftUI and SwiftData for project.",
                background: Color.brandTertiary,
                foreground: Color.brandPrimary
            )

        case .projects:
            LearnCard(
                title: "CV",
                description: "Update CV using new tech stack and ATS version.",
                background: Color.brandTertiary,
                foreground: Color.brandSecondary
            )
            LearnCard(
                title: "Klinik",
                description: "Deploy latest feature to dev server.",
                background: Color.brandTertiary,
                foreground: Color.brandSecondary
            )

        case .hobbies:
            LearnCard(
                title: "Gizi",
                description: "Create prototype for a healthy app in figma.",
                background: Color.brandSecondary,
                foreground: Color.brandTertiary
            )
            LearnCard(
                title: "Record Video",
                description: "Find a way to record video Git and Github.",
                background: Color.brandSecondary,
                foreground: Color.brandTertiary
            )
        }
    }
}

struct CategorySection: View {
    let category: CategoryKind
    private var headerAction: () -> Void { { print("Add tapped") } }

    var body: some View {
        VStack {
            Spacer()
            VStack(alignment: .leading, spacing: Spacing.small) {
                SectionHeader(title: category.title, color: category.headerColor, action: headerAction)
                category.cards
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
