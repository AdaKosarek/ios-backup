import SwiftUI
import Charts

struct StatisticsView: View {
    @State var viewModel: StatisticsViewModel
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // 1. Sekce s filtrem
                    filterSection
                    
                    // 2. Sekce s grafem (vyčleněna pro lepší výkon kompilátoru)
                    chartSection
                    
                    // 3. Sekce s kartičkami (vyčleněna)
                    statsGridSection
                }
                .padding(.top)
            }
            .navigationTitle("Statistiky")
            .background(Color(UIColor.systemGroupedBackground)) // Světle šedé pozadí
            .onAppear {
                viewModel.refreshData()
            }
        }
    }
    
    // MARK: - Subviews (Rozdělení pro kompilátor)
    
    private var filterSection: some View {
        Picker("Období", selection: $viewModel.selectedRange) {
            ForEach(StatsRange.allCases, id: \.self) { range in
                Text(range.rawValue).tag(range)
            }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal)
    }
    
    private var chartSection: some View {
        VStack(alignment: .leading) {
            Text("Aktivita")
                .font(.headline)
            
            Text("Zelená znamená splněný cíl")
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(.bottom, 5)
            
            Chart(viewModel.chartData) { item in
                BarMark(
                    x: .value("Čas", item.label),
                    y: .value("Karty", item.value)
                )
                .foregroundStyle(item.isGoalMet ? Color.green.gradient : Color.gray.opacity(0.3).gradient)
                .cornerRadius(4)
            }
            .frame(height: 200)
            .chartXAxis {
                AxisMarks { value in
                    // Jednoduchá logika pro popisky osy X
                    AxisValueLabel()
                }
            }
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .padding(.horizontal)
    }
    
    private var statsGridSection: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
            StatSmallCard(
                title: "Streak",
                value: "\(viewModel.streakDays) dní",
                subValue: "Drž to!",
                icon: "flame.fill",
                color: .orange
            )
            
            StatSmallCard(
                title: "Přesnost",
                value: String(format: "%.0f %%", viewModel.overallAccuracy),
                subValue: "Celková",
                icon: "target",
                color: .blue
            )
            
            StatSmallCard(
                title: "Celkem XP",
                value: "\(viewModel.totalXP)",
                subValue: "Zkušenosti",
                icon: "star.fill",
                color: .yellow
            )
            
            // Zde můžeš přidat další, např. Cards Done
            StatSmallCard(
                title: "Hotovo",
                value: "\(viewModel.sessions.reduce(0) { $0 + $1.totalCards })",
                subValue: "Karet celkem",
                icon: "checkmark.circle.fill",
                color: .green
            )
        }
        .padding(.horizontal)
        .padding(.bottom, 20)
    }
}

// MARK: - Chybějící komponenta StatSmallCard
// Tato struktura musí být MIMO strukturu StatisticsView (nebo uvnitř, ale správně uzavřená).
// Zde je na konci souboru, což je nejbezpečnější.

struct StatSmallCard: View {
    let title: String
    let value: String
    let subValue: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundStyle(color)
                    .font(.title2)
                    .padding(8)
                    .background(color.opacity(0.15))
                    .clipShape(Circle())
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(value)
                    .font(.title2)
                    .bold()
                    // Identifikátor pro UI testy
                    .accessibilityIdentifier("value_\(title)")
                
                Text(subValue)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(.top, 4)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(UIColor.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
