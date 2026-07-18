//
//  HomeDashboard.swift
//  Flocus
//
//  Created by Yuhaya Lissera on 18/07/26.
//

import SwiftUI
import SwiftData

struct HomeDashboard: View {
    let categories: [Category]
    let learnTasks: [Task]
    let projectTasks: [Task]
    let hobbyTasks: [Task]
    
    @Binding var isLearnVisible: Bool
    @Binding var isProjectsVisible: Bool
    @Binding var isHobbiesVisible: Bool
    
    var body: some View {
        HStack(spacing: 0) {
            // Left side: 3 vertical sections
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
            
            // Right side: 2 vertical sections
            VStack(spacing: 0) {
                if isProjectsVisible {
                    CategorySection(category: .projects, tasks: projectTasks)
                }
                if isHobbiesVisible {
                    CategorySection(category: .hobbies, tasks: hobbyTasks)
                }
            }
        }
    }
}
