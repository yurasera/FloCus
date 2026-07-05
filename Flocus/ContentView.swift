//
//  ContentView.swift
//  Flocus
//
//  Created by Yuhaya Lissera on 23/06/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var categories: [Category]
    @Query(sort: \Task.priorityOrder) private var tasks: [Task]
    @State private var isPresentingPriorityTasks = false

    var body: some View {
        let learnTasks = tasks.filter {
            $0.category?.name == CategoryKind.learn.title &&
            $0.status != .archive
        }

        let projectTasks = tasks.filter {
            $0.category?.name == CategoryKind.projects.title &&
            $0.status != .archive
        }

        let hobbyTasks = tasks.filter {
            $0.category?.name == CategoryKind.hobbies.title &&
            $0.status != .archive
        }
        VStack(spacing: 0) {
            if let focusTask {
                FocusTaskView(task: focusTask, stopFocus: stopFocus)
            } else {
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
                            .foregroundStyle(Color.brandTertiary)
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
                            startFocus()
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
        }
        .ignoresSafeArea()
        .sheet(isPresented: $isPresentingPriorityTasks) {
            PriorityTasksView(tasks: tasks)
        }
    }

    private var focusTask: Task? {
        tasks.first { $0.status == .focus }
    }

    private func startFocus() {
        guard let priorityTask = tasks.first(where: { $0.status == .backlog }) else {
            return
        }

        for task in tasks {
            switch task.status {
            case .completed:
                break

            case .focus:
                task.status = .backlog
                task.focusStartedAt = nil

            case .backlog:
                break

            case .archive:
                break
            }
        }

        priorityTask.status = .focus
        priorityTask.focusStartedAt = .now

        try? modelContext.save()
    }

    private func stopFocus() {
        focusTask?.status = .backlog
        focusTask?.focusStartedAt = nil
        try? modelContext.save()
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
                foreground: backgroundColor,
                task: nil
            )
            LearnCard(
                title: "",
                description: "",
                background: headerColor,
                foreground: backgroundColor,
                task: nil
            )
        } else {
            ForEach(limited) { task in
                LearnCard(
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

