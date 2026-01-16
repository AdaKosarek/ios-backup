import SwiftUI
import Charts

struct StatisticsView: View {
    @State var viewModel: StatisticsViewModel
    
    // Animace pro graf
    @State private var animateChart = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    
                    // 1. Přepínač období
                    rangePicker
                    
                    // 2. Hlavní graf (Velká karta)
                    mainChartCard
                    
                    // 3. Mřížka statistik
                    statsGrid
                }
                .padding()
            }
            .background(Color(UIColor.systemGroupedBackground))
            .navigationTitle("Přehled")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        withAnimation {
                            viewModel.generateMockData()
                            animateChart = false
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                animateChart = true
                            }
                        }
                    }) {
                        Label("Demo Data", systemImage: "wand.and.stars")
                            .symbolEffect(.bounce, value: viewModel.totalXP)
                    }
                }
            }
            .onAppear {
                viewModel.refreshData()
                animateChart = true
            }
        }
    }
    
    // MARK: - Components
    
    private var rangePicker: some View {
        Picker("Range", selection: $viewModel.selectedRange) {
            ForEach(StatsRange.allCases, id: \.self) { range in
                Text(range.rawValue).tag(range)
            }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal, 4)
    }
    
    private var mainChartCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading) {
                    Text("Aktivita")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                    
                    // Dynamický součet pro vybrané období
                    Text("\(viewModel.chartData.reduce(0) { $0 + $1.value }) karet")
                        .font(.system(.title, design: .rounded))
                        .bold()
                        .contentTransition(.numericText())
                }
                Spacer()
                
                // Ikonka grafu
                Image(systemName: "chart.bar.fill")
                    .foregroundStyle(.blue.gradient)
                    .font(.title2)
            }
            
            // Samotný graf
            Chart(viewModel.chartData) { item in
                // Sloupce
                BarMark(
                    x: .value("Den", item.label),
                    y: .value("Karty", animateChart ? item.value : 0)
                )
                .foregroundStyle(
                    LinearGradient(
                        colors: [item.color, item.color.opacity(0.6)],
                        startPoint: .bottom,
                        endPoint: .top
                    )
                )
                .cornerRadius(6)
                // Zobrazení hodnoty nad sloupcem (pokud je místo)
                .annotation(position: .top, alignment: .center) {
                    if item.value > 0 && viewModel.selectedRange == .week {
                        Text("\(item.value)")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
                
                // Čára průměru (volitelné, vypadá to "profi")
                if let avg = calculateAverage(), avg > 0 {
                    RuleMark(y: .value("Průměr", avg))
                        .lineStyle(StrokeStyle(lineWidth: 2, dash: [5]))
                        .foregroundStyle(.gray.opacity(0.3))
                        .annotation(position: .leading, alignment: .bottom) {
                            Text("Ø \(Int(avg))")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                }
            }
            .frame(height: 220)
            .chartYAxis(.hidden) // Skryjeme osu Y pro čistší vzhled
            .chartXAxis {
                AxisMarks { _ in
                    AxisValueLabel()
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(20)
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
    }
    
    private var statsGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
            
            BentoCard(
                title: "Streak",
                value: "\(viewModel.streakDays)",
                unit: "dní",
                icon: "flame.fill",
                gradient: Gradient(colors: [.orange, .red])
            )
            
            BentoCard(
                title: "Zkušenosti",
                value: "\(viewModel.totalXP)",
                unit: "XP",
                icon: "star.fill",
                gradient: Gradient(colors: [.yellow, .orange])
            )
            
            BentoCard(
                title: "Přesnost",
                value: String(format: "%.0f", viewModel.overallAccuracy),
                unit: "%",
                icon: "target",
                gradient: Gradient(colors: [.blue, .purple])
            )
            
            BentoCard(
                title: "Celkem",
                value: "\(viewModel.totalCardsStudied)",
                unit: "karet",
                icon: "rectangle.stack.fill",
                gradient: Gradient(colors: [.green, .mint])
            )
        }
    }
    
    // Pomocná funkce pro průměr v grafu
    private func calculateAverage() -> Double? {
        let total = viewModel.chartData.reduce(0) { $0 + $1.value }
        return viewModel.chartData.isEmpty ? nil : Double(total) / Double(viewModel.chartData.count)
    }
}

// MARK: - Moderní "Bento" Karta
struct BentoCard: View {
    let title: String
    let value: String
    let unit: String
    let icon: String
    let gradient: Gradient
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundStyle(.white)
                    .frame(width: 36, height: 36)
                    .background(LinearGradient(gradient: gradient, startPoint: .topLeading, endPoint: .bottomTrailing))
                    .clipShape(Circle())
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 2) {
                HStack(alignment: .lastTextBaseline, spacing: 2) {
                    Text(value)
                        .font(.system(.title, design: .rounded))
                        .fontWeight(.bold)
                        .contentTransition(.numericText())
                    
                    Text(unit)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundStyle(.secondary)
                }
                
                Text(title)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.03), radius: 8, x: 0, y: 4)
    }
}
