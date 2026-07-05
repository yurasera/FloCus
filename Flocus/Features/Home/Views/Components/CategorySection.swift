//
//  CategorySection.swift
//  Flocus
//
//  Created by Yuhaya Lissera on 06/07/26.
//

import SwiftUI
import SwiftData

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
        .sheet(isPresented: $isPresentingAddTask) {
            AddTaskSheet(category: category)
        }
    }
}
