//
//  LearnCard.swift
//  Flocus
//
//  Created by Yuhaya Lissera on 24/06/26.
//

import SwiftUI

struct LearnCard: View {
    let title: String
    let description: String
    let background: Color
    let foreground: Color

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.small) {
            Text(title)
                .font(.title3)
                .fontWeight(.bold)

            Text(description)
                .font(.caption)
        }
        .frame(maxWidth: .infinity, minHeight: Metrics.cardHeight, alignment: .leading)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: Spacing.medium)
                .fill(background)
        )
        .foregroundStyle(foreground)
    }
}
