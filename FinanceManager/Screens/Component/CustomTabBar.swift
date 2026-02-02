//
//  CustomTapBar.swift
//  FinanceManager
//
//  Created by mp on 24.06.2025.
//

import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    @Binding var isSheetPresented: Bool

    var body: some View {
        HStack {
            tabButton(index: 0, label: "Home", systemImage: "house.fill")
            tabButton(index: 1, label: "Overview", systemImage: "list.bullet.rectangle.fill")
            plusButton
            tabButton(index: 2, label: "Statistics", systemImage: "chart.pie.fill")
            tabButton(index: 3, label: "Settings", systemImage: "gearshape.fill")
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 25)
        .background(
            Color(.systemBackground)
                .shadow(color: Color.black.opacity(0.1), radius: 5, y: -2)
        )
    }

    private func tabButton(index: Int, label: String, systemImage: String) -> some View {
        Button(action: {
            selectedTab = index
        }) {
            VStack(spacing: 4) {
                Image(systemName: systemImage)
                    .font(.system(size: 20))
                    .foregroundColor(selectedTab == index ? Color.purple : Color.gray)
                Text(label)
                    .font(.caption2)
                    .foregroundColor(selectedTab == index ? Color.purple : Color.gray)
            }
            .frame(maxWidth: .infinity)
        }
    }

    private var plusButton: some View {
        Button(action: {
            isSheetPresented = true
        }) {
            ZStack {
                Circle()
                    .fill(Color.purple)
                    .frame(width: 56, height: 56)
                    .shadow(color: .black.opacity(0.2), radius: 5, y: 4)
                Image(systemName: "plus")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(.white)
            }
            .offset(y: -20)
        }
    }
}
