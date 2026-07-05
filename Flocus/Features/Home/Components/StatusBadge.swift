//
//  StatusBadge.swift
//  Flocus
//
//  Created by Yuhaya Lissera on 24/06/26.
//

import SwiftUI

struct StatusBadge: View {

    let color: Color

    var body: some View {
        Image(systemName: "checkmark.circle.fill")
            .font(.title)
            .foregroundStyle(color)
            .background(
                Circle()
                    .fill(color)
            )
            .overlay(
                Circle()
                    .stroke(.white, lineWidth: 2)
            )
    }
}
