//
//  SeedData.swift
//  Flocus
//
//  Created by Yuhaya Lissera on 01/07/26.
//

import SwiftData

@MainActor
enum SeedData {

    static func seedCategories(in context: ModelContext) throws {

        let descriptor = FetchDescriptor<Category>()

        let categories = try context.fetch(descriptor)

        guard categories.isEmpty else {
            return
        }

        context.insert(Category(name: "Learn", color: "blue"))
        context.insert(Category(name: "Projects", color: "green"))
        context.insert(Category(name: "Hobbies", color: "yellow"))

        try context.save()
    }

}
