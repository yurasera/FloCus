//
//  ContentView.swift
//  Flocus
//
//  Created by Yuhaya Lissera on 23/06/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        HStack(spacing: 0) {
            // Kiri: 3 bagian vertikal
            VStack(spacing: 0) {
                Color.red
                Color.orange
                Color.yellow
            }

            // Kanan: 2 bagian vertikal
            VStack(spacing: 0) {
                Color.green
                Color.blue
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    ContentView()
}
