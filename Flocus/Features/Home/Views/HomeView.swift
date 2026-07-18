//
//  ContentView.swift
//  Flocus
//
//  Created by Yuhaya Lissera on 23/06/26.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var categories: [Category]
    @Query(sort: \Task.priorityOrder) private var tasks: [Task]
    @State private var isPresentingPriorityTasks = false
    @State private var isLearnVisible: Bool = true
    @State private var isProjectsVisible: Bool = true
    @State private var isHobbiesVisible: Bool = true

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
                FocusView(task: focusTask, stopFocus: stopFocus)
            } else {
                HStack(spacing: 0) {
                    // Kiri: 3 bagian vertikal
                    VStack(spacing: 0) {
                        HeroSection(categories: categories)
                        if isLearnVisible {
                            CategorySection(category: .learn, tasks: learnTasks)
                        }
                        StatusSection(
                            learnCount: learnTasks.count,
                            projectsCount: projectTasks.count,
                            hobbiesCount: hobbyTasks.count,
                            isLearnVisible: $isLearnVisible,
                            isProjectsVisible: $isProjectsVisible,
                            isHobbiesVisible: $isHobbiesVisible
                        )
                    }
                    
                    // Kanan: 2 bagian vertikal
                    VStack(spacing: 0) {
                        if isProjectsVisible {
                            CategorySection(category: .projects, tasks: projectTasks)
                        }
                        if isHobbiesVisible {
                            CategorySection(category: .hobbies, tasks: hobbyTasks)
                        }
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
            PriorityView(tasks: tasks)
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

#Preview {
    HomeView()
}
