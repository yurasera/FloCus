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
                    title: "SwiftData",
                    description: "Belajar penerapan SwiftData di Flocus.",
                    background: Color.brandTertiary,
                    foreground: Color.brandPrimary
                )
                
                LearnCard(
                    title: "Prime App",
                    description: "Create workout body understanding app using SwiftUI and SwiftData for project.",
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
                SectionHeader(title: "Project", color: Color.brandTertiary, action: headerAction)

//                LearnCard(
//                    title: "New Porto",
//                    description: "Create new repository using new tech stack.",
//                    background: Color.brandTertiary,
//                    foreground: Color.brandPrimary
//                )
                
                LearnCard(
                    title: "CV",
                    description: "Update CV using new tech stack and ATS version.",
                    background: Color.brandTertiary,
                    foreground: Color.brandSecondary
                )
                
                LearnCard(
                    title: "Klinik",
                    description: "Deploy latest feature to dev server.",
                    background: Color.brandTertiary,
                    foreground: Color.brandSecondary
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
                SectionHeader(title: "Hobbies", color: Color.brandSecondary, action: headerAction)

                LearnCard(
                    title: "Gizi",
                    description: "Create prototype for a healthy app in figma.",
                    background: Color.brandSecondary,
                    foreground: Color.brandTertiary
                )
//                LearnCard(
//                    title: "Git",
//                    description: "Create git flow poster for learning.",
//                    background: Color.brandSecondary,
//                    foreground: Color.brandTertiary
//                )
                
                LearnCard(
                    title: "Record Video",
                    description: "Find a way to record video Git and Github.",
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
