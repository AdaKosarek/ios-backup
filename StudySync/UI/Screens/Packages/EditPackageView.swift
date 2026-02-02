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
        @Bindable var vm = viewModel
        
        NavigationStack {
            ZStack {
                // Pozadí
                BackgroundBlob()
                    .ignoresSafeArea()
                    .opacity(0.3)
                
                Form {
                    Section("pack_name") {
                        TextField("eg_maths", text: $vm.name)
                            .accessibilityIdentifier("packageNameField")
                    }
                    
                    Section("add_color") {
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
                    Button("action_cancle") { dismiss() }
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
