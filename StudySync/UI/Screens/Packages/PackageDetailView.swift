import SwiftUI

struct PackageDetailView: View {
    @State var viewModel: PackageDetailViewModel
    @EnvironmentObject var diContainer: DIContainer
    @State private var showingStudySession = false
    @State private var showingAddGroupAlert = false
    @State private var newGroupName = ""
    
    var body: some View {
        List {
            Section {
                HStack {
                    Text("\(viewModel.package.groups.count) skupin").accessibilityIdentifier("groupCountText")
                    Spacer()
                    Button(action: { showingStudySession = true }) {
                        Image(systemName: "play.circle.fill").font(.largeTitle)
                    }
                    .foregroundStyle(Color(hex: viewModel.package.colorHex))
                    .accessibilityIdentifier("playSessionButton")
                }
            }
            
            Section("Skupiny") {
                ForEach(viewModel.package.groups) { group in
                    NavigationLink(destination: CardListView(viewModel: diContainer.makeCardListViewModel(group: group))) {
                        Text(group.name)
                    }
                    .accessibilityIdentifier("groupRow_\(group.name)")
                }
                .onDelete(perform: viewModel.deleteGroup)
            }
        }
        .navigationTitle(viewModel.package.name)
        .toolbar {
            Button(action: { showingAddGroupAlert = true }) { Image(systemName: "plus") }
                .accessibilityIdentifier("addGroupButton")
        }
        .alert("Nová skupina", isPresented: $showingAddGroupAlert) {
            TextField("Název", text: $newGroupName).accessibilityIdentifier("newGroupNameField")
            Button("Vytvořit") { viewModel.addGroup(name: newGroupName); newGroupName = "" }
                .accessibilityIdentifier("confirmAddGroupButton")
            Button("Zrušit", role: .cancel) {}
        }
        .fullScreenCover(isPresented: $showingStudySession) {
            NavigationStack { SessionView(viewModel: diContainer.makeSessionViewModel(cards: viewModel.allCards)) }
        }
    }
}
