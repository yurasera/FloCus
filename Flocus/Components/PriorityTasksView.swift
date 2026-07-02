//
//  PriorityTasksView.swift
//  Flocus
//
//  Created by Yuhaya Lissera on 02/07/26.
//

import SwiftUI
import SwiftData

struct PriorityTasksView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

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
                    .onDelete(perform: deleteTasks)
                    .onMove(perform: moveTasks)
                }
            }
            .navigationTitle("Set Priority")
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
            return Color.brandTertiary
        case CategoryKind.projects.title:
            return Color.brandSecondary
        case CategoryKind.hobbies.title:
            return Color.brandPrimary
        default:
            return .secondary
        }
    }

    private func deleteTasks(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(tasks[index])
        }
    }

    private func moveTasks(from source: IndexSet, to destination: Int) {
        var reorderedTasks = tasks
        reorderedTasks.move(fromOffsets: source, toOffset: destination)

        for (index, task) in reorderedTasks.enumerated() {
            task.priorityOrder = index
        }
    }
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
