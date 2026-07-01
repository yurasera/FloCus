//
//  Task.swift
//  Flocus
//
//  Created by Yuhaya Lissera on 01/07/26.
//

import SwiftUI
import SwiftData

@Model
final class Task {

    var title: String
    var notes: String
    var category: Category?
    var status: TaskStatus
    var createdAt: Date
    var completedAt: Date?

    init(
        title: String,
        notes: String
    ) {
        self.title = title
        self.notes = notes
        self.status = .backlog
        self.createdAt = .now
        self.completedAt = nil
    }

}
