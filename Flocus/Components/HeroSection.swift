//
//  HeroSection.swift
//  Flocus
//
//  Created by Yuhaya Lissera on 01/07/26.
//

import SwiftUI

struct HeroSection: View {
    let categories: [Category]
    var body: some View {
        VStack {
            Spacer()
            VStack(alignment: .leading, spacing: Spacing.small) {
                Text("Flocus")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Three words.")
                    .font(.callout)
                Text("Three roles.")
                    .font(.callout)
                Text("One journey.")
                    .font(.callout)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundColor(.white)
            .padding()
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(Color.brandPrimary)
    }
}

