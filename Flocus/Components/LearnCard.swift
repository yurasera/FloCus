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

    @State private var isCompleted = false

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.small) {

            HStack {
                Text(title)
                    .font(.title3)
                    .fontWeight(.bold)

                Spacer()

                if isCompleted {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title3)
                }
            }

            Text(description)
                .font(.caption)
        }
        .frame(
            maxWidth: .infinity,
            minHeight: Metrics.cardHeight,
            alignment: .leading
        )
        .padding()
        .background(
            RoundedRectangle(cornerRadius: Spacing.medium)
                .fill(
                    isCompleted
                    ? background.opacity(0.5)
                    : background
                )
        )
        .foregroundStyle(
            isCompleted
            ? foreground
            : foreground
        )
        .onTapGesture {
            withAnimation(.spring) {
                isCompleted.toggle()
            }
        }
    }
}
