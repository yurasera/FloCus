//
//  ContentView.swift
//  Flocus
//
//  Created by Yuhaya Lissera on 23/06/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Query private var categories: [Category]
    @Query private var tasks: [Task]
    @State private var isPresentingPriorityTasks = false

    var body: some View {
        let learnTasks = tasks.filter { $0.category?.name == CategoryKind.learn.title }
        let projectTasks = tasks.filter { $0.category?.name == CategoryKind.projects.title }
        let hobbyTasks = tasks.filter { $0.category?.name == CategoryKind.hobbies.title }
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                // Kiri: 3 bagian vertikal
                VStack(spacing: 0) {
                    HeroSection(categories: categories)
                    CategorySection(category: .learn, tasks: learnTasks)
                    StatusSection()
                }
                
                // Kanan: 2 bagian vertikal
                VStack(spacing: 0) {
                    CategorySection(category: .projects, tasks: projectTasks)
                    CategorySection(category: .hobbies, tasks: hobbyTasks)
                }
            }
            HStack(spacing: 0) {
                VStack(spacing: 0) {
                    Button {
                        isPresentingPriorityTasks = true
                    } label: {
                        HStack {
                            Image(systemName: "flag.fill")
                            Text("Set Priority")
                        }
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .foregroundStyle(Color.brandPrimary)
                        .clipShape(RoundedRectangle(cornerRadius: 24))
                        .glassEffect()
                        .tint(Color.brandPrimary)
                    }
                    Spacer()
                }
                .padding(16)
                .background(Color.brandPrimary)
                
                VStack(spacing: 0) {
                    Button {
                        // Set Priority action
                    } label: {
                        HStack {
                            Image(systemName: "timer")
                            Text("Start Focus")
                        }
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .foregroundStyle(Color.brandSecondary)
                        .clipShape(RoundedRectangle(cornerRadius: 24))
                        .glassEffect()
                    }
                    Spacer()
                }
                .padding(16)
                .background(Color.brandTertiary)
            }
            .frame(height: 96)
        }
        .ignoresSafeArea()
        .sheet(isPresented: $isPresentingPriorityTasks) {
            PriorityTasksView(tasks: tasks)
        }
    }
}

private struct PriorityTasksView: View {
    @Environment(\.dismiss) private var dismiss

    let tasks: [Task]

    var body: some View {
        NavigationStack {
            List {
                if tasks.isEmpty {
                    ContentUnavailableView(
                        "No Tasks",
                        systemImage: "checklist",
                        description: Text("Tambahkan task dulu dari setiap section.")
                    )
                } else {
                    ForEach(tasks) { task in
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Image(systemName: "circle.fill")
                                    .foregroundStyle(color(for: task.category?.name))
                                Text(task.title)
                                    .font(.headline)
                                Spacer()
                                Text(task.category?.name ?? "")
                                    .font(.caption)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.secondary.opacity(0.12))
                                    .clipShape(Capsule())
                            }

                            if !task.notes.isEmpty {
                                Text(task.notes)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .padding(.vertical, 6)
                    }
                }
            }
            .navigationTitle("Set Priority")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }

    private func color(for categoryName: String?) -> Color {
        switch categoryName {
        case CategoryKind.learn.title:
            return Color.brandTertiary
        case CategoryKind.projects.title:
            return Color.brandSecondary
        case CategoryKind.hobbies.title:
            return Color.brandPrimary
        default:
            return .secondary
        }
    }
}

// MARK: - Sections

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
        case .projects: return "Projects"
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
        let limited = Array(tasks.prefix(2))
        if limited.isEmpty {
            // Show two empty placeholder cards when there is no data
            LearnCard(
                title: "",
                description: "",
                background: headerColor,
                foreground: backgroundColor
            )
            LearnCard(
                title: "",
                description: "",
                background: headerColor,
                foreground: backgroundColor
            )
        } else {
            ForEach(limited) { task in
                LearnCard(
                    title: task.title,
                    description: task.notes,
                    background: headerColor,
                    foreground: backgroundColor
                )
            }
        }
    }
}

struct CategorySection: View {
    let category: CategoryKind
    let tasks: [Task]
    @State private var isPresentingAddTask = false
    private var headerAction: () -> Void { { isPresentingAddTask = true } }

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
        .sheet(isPresented: $isPresentingAddTask) { AddTaskSheet(category: category) }
    }
}

private struct AddTaskSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    let category: CategoryKind
    @State private var title: String = ""
    @State private var notes: String = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Title") {
                    TextField("Enter title", text: $title)
                }
                Section("Notes") {
                    TextField("Enter notes", text: $notes, axis: .vertical)
                        .lineLimit(3, reservesSpace: true)
                }
            }
            .navigationTitle("Add \(category.title) Task")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                        .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }

    private func save() {
        let categoryName: String
        switch category {
        case .learn: categoryName = "Learn"
        case .projects: categoryName = "Projects"
        case .hobbies: categoryName = "Hobbies"
        }

        // Fetch Category seeded by SeedData matching the name
        let descriptor = FetchDescriptor<Category>(predicate: #Predicate { $0.name == categoryName })
        let matchedCategory = try? modelContext.fetch(descriptor).first

        let newTask = Task(title: title, notes: notes, category: matchedCategory)
        modelContext.insert(newTask)
        dismiss()
    }
}

#Preview {
    ContentView()
}

#Preview("Priority Tasks") {
    let learn = Category(name: "Learn", color: "blue")
    let projects = Category(name: "Projects", color: "green")
    let hobbies = Category(name: "Hobbies", color: "yellow")

    PriorityTasksView(tasks: [
        Task(title: "Learn SwiftData", notes: "Model, query, relationship", category: learn),
        Task(title: "Build Flocus", notes: "Priority flow", category: projects),
        Task(title: "Sketch UI", notes: "Explore glass style", category: hobbies)
    ])
}
