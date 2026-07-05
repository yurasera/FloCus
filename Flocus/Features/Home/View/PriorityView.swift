//
//  PriorityTasksView.swift
//  Flocus
//
//  Created by Yuhaya Lissera on 02/07/26.
//

import SwiftUI
import SwiftData

enum CategoryFilter: String, CaseIterable, Identifiable {
    case all = "All"
    case learn = "Learn"
    case projects = "Projects"
    case hobbies = "Hobbies"
    
    var id: String { rawValue }
}

enum ProgressFilter: String, CaseIterable, Identifiable {
    case active = "Active"
    case completed = "Completed"
    case archive = "Archive"
    
    var id: String { rawValue }
}

struct PriorityView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    let tasks: [Task]
    
    @State private var selectedCategory: CategoryFilter = .all
    @State private var selectedProgress: ProgressFilter = .active
    @State private var showProgressFilter = false
    
    private var filteredTasks: [Task] {
        tasks.filter { task in
            // Filter by category
            let categoryMatch: Bool
            switch selectedCategory {
            case .all:
                categoryMatch = true
            case .learn:
                categoryMatch = task.category?.name == CategoryKind.learn.title
            case .projects:
                categoryMatch = task.category?.name == CategoryKind.projects.title
            case .hobbies:
                categoryMatch = task.category?.name == CategoryKind.hobbies.title
            }
            
            // Filter by progress
            let progressMatch: Bool
            switch selectedProgress {
            case .active:
                progressMatch = task.status == .backlog || task.status == .focus
            case .completed:
                progressMatch = task.status == .completed
            case .archive:
                progressMatch = task.status == .archive
            }
            
            return categoryMatch && progressMatch
        }
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    VStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Category")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                Spacer()
                                Button {
                                    withAnimation(.snappy) {
                                        showProgressFilter.toggle()
                                    }
                                } label: {
                                    HStack(spacing: 6) {
                                        Text(selectedProgress.rawValue)
                                        Image(systemName: showProgressFilter ? "chevron.up" : "chevron.down")
                                            .font(.caption2)
                                    }
                                    .font(.subheadline.weight(.medium))
                                    .foregroundStyle(.primary)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .background(.thinMaterial, in: Capsule())
                                }
                            }
                            if showProgressFilter {
                                VStack(spacing: 8) {
                                    ForEach(ProgressFilter.allCases) { progress in
                                        Button {
                                            selectedProgress = progress
                                            withAnimation(.snappy) {
                                                showProgressFilter = false
                                            }
                                        } label: {
                                            HStack {
                                                Text(progress.rawValue)
                                                Spacer()
                                                if selectedProgress == progress {
                                                    Image(systemName: "checkmark")
                                                        .font(.caption.weight(.semibold))
                                                }
                                            }
                                            .font(.subheadline)
                                            .foregroundStyle(.primary)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 10)
                                            .background(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .fill(selectedProgress == progress ? Color.secondary.opacity(0.14) : Color.clear)
                                            )
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                                .padding(.top, 4)
                            }
                            Picker("Category", selection: $selectedCategory) {
                                ForEach(CategoryFilter.allCases) { category in
                                    Text(category.rawValue).tag(category)
                                }
                            }
                            .pickerStyle(.segmented)
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                if filteredTasks.isEmpty {
                    ContentUnavailableView(
                        "No Tasks",
                        systemImage: "checklist",
                        description: Text("Tidak ada task yang sesuai dengan filter.")
                    )
                } else {
                    ForEach(filteredTasks) { task in
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
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button(role: .destructive) {
                                if let index = tasks.firstIndex(where: { $0.id == task.id }) {
                                    deleteTasks(at: IndexSet(integer: index))
                                }
                            } label: {
                                Image(systemName: "trash.fill")
                                Text("Delete")
                            }
                            
                            Button {
                                archiveTask(task)
                            } label: {
                                Image(systemName: "archivebox.fill")
                                Text("Archive")
                            }
                            .tint(.orange)
                        }
                    }
                    .onMove(perform: moveTasks)
                }
            }
            .navigationTitle("Set Priority")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
                ToolbarItem(placement: .primaryAction) {
                    EditButton()
                }
            }
        }
    }

    private func color(for categoryName: String?) -> Color {
        switch categoryName {
        case CategoryKind.learn.title:
            return Color.brandPrimary
        case CategoryKind.projects.title:
            return Color.brandSecondary
        case CategoryKind.hobbies.title:
            return Color.brandTertiary
        default:
            return .secondary
        }
    }

    private func deleteTasks(at offsets: IndexSet) {
        for index in offsets {
            let taskToDelete = filteredTasks[index]
            modelContext.delete(taskToDelete)
        }
    }

    private func moveTasks(from source: IndexSet, to destination: Int) {
        var reordered = filteredTasks
        reordered.move(fromOffsets: source, toOffset: destination)
        for (idx, t) in reordered.enumerated() {
            t.priorityOrder = idx
        }
    }
    
    private func archiveTask(_ task: Task) {
        // Find the original task from the full tasks list
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].status = .archive
            try? modelContext.save()
        }
    }
}

#Preview("Priority Tasks") {
    let learn = Category(name: "Learn", color: "blue")
    let projects = Category(name: "Projects", color: "green")
    let hobbies = Category(name: "Hobbies", color: "yellow")

    PriorityView(tasks: [
        Task(title: "Learn SwiftData", notes: "Model, query, relationship", category: learn),
        Task(title: "Build Flocus", notes: "Priority flow", category: projects),
        Task(title: "Sketch UI", notes: "Explore glass style", category: hobbies)
    ])
}
