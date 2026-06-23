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
                ZStack {
                    Color.brandPrimary

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Flocus")
                            .font(.largeTitle)
                            .fontWeight(.bold)

                        Text("Three words.")
                            .font(.title3)

                        Text("Three roles.")
                            .font(.title3)
                        Text("One journey.")
                            .font(.title3)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.white)
                    .padding()
                }

                ZStack {
                    Color.brandPrimary

                    VStack(alignment: .leading, spacing: 8) {
                        HStack(){
                            Text("Learn")
                                .font(.title)
                                .fontWeight(.bold)
                            
                            Spacer()

                            Button(action: {
                                print("Add tapped")
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.title3)
                            }
                        }

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
                

                ZStack {
                    Color.brandPrimary

                    HStack(spacing: 16) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.title)
                            .foregroundStyle(Color.brandPrimary)
                            .background(
                                    Circle()
                                        .fill(Color.brandPrimary)
                                )
                            .overlay(
                                Circle()
                                    .stroke(Color.white, lineWidth: 2)
                            )
                        
                        Image(systemName: "checkmark.circle.fill")
                            .font(.title)
                            .foregroundStyle(Color.brandSecondary)
                            .background(
                                    Circle()
                                        .fill(Color.brandSecondary)
                                )
                            .overlay(
                                Circle()
                                    .stroke(Color.white, lineWidth: 2)
                            )
                        
                        Image(systemName: "checkmark.circle.fill")
                            .font(.title)
                            .foregroundStyle(Color.brandTertiary)
                            .background(
                                    Circle()
                                        .fill(Color.brandTertiary)
                                )
                            .overlay(
                                Circle()
                                    .stroke(Color.white, lineWidth: 2)
                            )
                    }
                }
            }

            // Kanan: 2 bagian vertikal
            VStack(spacing: 0) {
                ZStack {
                    Color.brandSecondary

                    VStack(alignment: .leading, spacing: 8) {
                        HStack(){
                            Text("Impact")
                                .font(.title)
                                .fontWeight(.bold)
                            
                            Spacer()

                            Button(action: {
                                print("Add tapped")
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.title3)
                            }
                        }

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
                }

                ZStack {
                    Color.brandTertiary

                    VStack(alignment: .leading, spacing: 8) {
                        HStack(){
                            Text("Build")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundStyle(Color.brandPrimary)
                            
                            Spacer()

                            Button(action: {
                                print("Add tapped")
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.title3)
                                    .foregroundStyle(Color.brandPrimary)
                            }
                        }

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
                }
            }
        }
        .ignoresSafeArea()
    }
}

struct LearnCard: View {
    let title: String
    let description: String
    let background: Color
    let foreground: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.title3)
                .fontWeight(.bold)

            Text(description)
                .font(.caption)
        }
        .frame(maxWidth: .infinity, minHeight: 70, alignment: .leading)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(background)
        )
        .foregroundStyle(foreground)
    }
}

#Preview {
    ContentView()
}
