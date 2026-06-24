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
                HeroSection()
                LearnSection()
                StatusSection()
            }

            // Kanan: 2 bagian vertikal
            VStack(spacing: 0) {
                ImpactSection()
                BuildSection()
            }
        }
        .ignoresSafeArea()
    }
}

// MARK: - Sections

struct HeroSection: View {
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

struct LearnSection: View {
    private var headerAction: () -> Void { { print("Add tapped") } }

    var body: some View {
        VStack {
            Spacer()
            VStack(alignment: .leading, spacing: Spacing.small) {
                SectionHeader(title: "Learn", color: Color.brandTertiary, action: headerAction)

                LearnCard(
                    title: "Sketch",
                    description: "Belajar membuat design system.",
                    background: Color.brandTertiary,
                    foreground: Color.brandPrimary
                )
                
                LearnCard(
                    title: "Xcode",
                    description: "Create new project.",
                    background: Color.brandTertiary,
                    foreground: Color.brandPrimary
                )
            }
            .foregroundColor(.white)
            .padding()
        }
        .frame(maxWidth: .infinity)
        .background(Color.brandPrimary)
    }
}

struct ImpactSection: View {
    private var headerAction: () -> Void { { print("Add tapped") } }

    var body: some View {
        VStack {
            Spacer()
            VStack(alignment: .leading, spacing: Spacing.small) {
                SectionHeader(title: "Impact", color: Color.brandTertiary, action: headerAction)

                LearnCard(
                    title: "Klinik",
                    description: "Report Opname Data Obat Frontend and Backend.",
                    background: Color.brandTertiary,
                    foreground: Color.brandPrimary
                )
                
                LearnCard(
                    title: "Hospital",
                    description: "Pengesahan pasien invoice hilangkan nomor tagihan.",
                    background: Color.brandTertiary,
                    foreground: Color.brandPrimary
                )
            }
            .foregroundColor(.white)
            .padding()
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(Color.brandSecondary)
    }
}

struct BuildSection: View {
    private var headerAction: () -> Void { { print("Add tapped") } }

    var body: some View {
        VStack {
            Spacer()
            VStack(alignment: .leading, spacing: Spacing.small) {
                SectionHeader(title: "Build", color: Color.brandSecondary, action: headerAction)

                LearnCard(
                    title: "Flocus",
                    description: "Focus app to help me focus in my task.",
                    background: Color.brandSecondary,
                    foreground: Color.brandTertiary
                )
                
                LearnCard(
                    title: "FloFeed",
                    description: "Need to get feedback from my course, so i can learn.",
                    background: Color.brandSecondary,
                    foreground: Color.brandTertiary
                )
                
            }
            .foregroundColor(.white)
            .padding()
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(Color.brandTertiary)
    }
}

struct StatusSection: View {
    var body: some View {
        VStack {
            Spacer()
            HStack(spacing: Spacing.medium) {
                StatusBadge(color: Color.brandPrimary)
                StatusBadge(color: Color.brandSecondary)
                StatusBadge(color: Color.brandTertiary)
            }
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(Color.brandPrimary)
    }
}

#Preview {
    ContentView()
}
