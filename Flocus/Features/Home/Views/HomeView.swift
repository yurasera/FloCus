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
    
    @State private var viewModel = HomeViewModel()

    var body: some View {
        VStack(spacing: 0) {
            if let focusTask = viewModel.focusTask(from: tasks) {
                FocusView(task: focusTask, stopFocus: stopFocus)
            } else {
                HStack(spacing: 0) {
                    VStack(spacing: 0) {
                        HeroSection(categories: categories)
                        if viewModel.isLearnVisible {
                            CategorySection(category: .learn, tasks: viewModel.learnTasks(from: tasks))
                        }
                        StatusSection(
                            learnCount: viewModel.learnTasks(from: tasks).count,
                            projectsCount: viewModel.projectTasks(from: tasks).count,
                            hobbiesCount: viewModel.hobbyTasks(from: tasks).count,
                            isLearnVisible: $viewModel.isLearnVisible,
                            isProjectsVisible: $viewModel.isProjectsVisible,
                            isHobbiesVisible: $viewModel.isHobbiesVisible
                        )
                    }
                    VStack(spacing: 0) {
                        if viewModel.isProjectsVisible {
                            CategorySection(category: .projects, tasks: viewModel.projectTasks(from: tasks))
                        }
                        if viewModel.isHobbiesVisible {
                            CategorySection(category: .hobbies, tasks: viewModel.hobbyTasks(from: tasks))
                        }
                    }
                }
                HStack(spacing: 0) {
                    VStack(spacing: 0) {
                        Button {
                            viewModel.isPresentingPriorityTasks = true
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
                            viewModel.startFocus(tasks: tasks)
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
        .sheet(isPresented: $viewModel.isPresentingPriorityTasks) {
            PriorityView(tasks: tasks)
        }
        .onAppear {
            viewModel.setContext(modelContext)
        }
    }

    private func stopFocus() {
        viewModel.stopFocus(tasks: tasks)
    }
}

#Preview {
    HomeView()
}
