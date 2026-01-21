//
//  EditPackageView.swift
//  StudySync
//
//  Created by Miroslav Musil on 18.12.2025.
//

import SwiftUI

struct EditPackageView: View {
    @State var viewModel: EditPackageViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        // Vytvoříme bindable verzi pro TextFieldy
        @Bindable var vm = viewModel
        
        NavigationStack {
            ZStack {
                // Pozadí
                BackgroundBlob()
                    .ignoresSafeArea()
                    .opacity(0.3)
                
                Form {
                    Section("Název balíčku") {
                        TextField("Např. Matematika", text: $vm.name)
                            .accessibilityIdentifier("packageNameField")
                    }
                    
                    Section("Barva") {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 40))], spacing: 10) {
                            ForEach(viewModel.availableColors, id: \.self) { colorName in
                                Circle()
                                    .fill(viewModel.mapColor(colorName).gradient)
                                    .frame(width: 40, height: 40)
                                    .overlay {
                                        if viewModel.selectedColorHex == colorName {
                                            Image(systemName: "checkmark")
                                                .foregroundStyle(.white)
                                                .bold()
                                        }
                                    }
                                    .onTapGesture {
                                        withAnimation {
                                            viewModel.selectedColorHex = colorName
                                        }
                                    }
                                    .accessibilityIdentifier("color_\(colorName)")
                            }
                        }
                        .padding(.vertical, 5)
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle(viewModel.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Zrušit") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(viewModel.buttonTitle) {
                        viewModel.save()
                        dismiss()
                    }
                    .disabled(viewModel.name.isEmpty)
                    .accessibilityIdentifier("savePackageButton")
                }
            }
        }
    }
}
