import SwiftUI
import Charts

struct StatisticsView: View {
    @State var viewModel: StatisticsViewModel
    
    // Interaktivita grafu
    @State private var rawSelectedDate: Date? = nil
    @State private var animateChart = false
    
    // Helper: Najde vybraný bod v grafu
    var selectedItem: StatisticsViewModel.ChartPoint? {
        guard let rawSelectedDate else { return nil }
        return viewModel.findChartItem(for: rawSelectedDate)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    
                    // 1. Přepínač období
                    rangePicker
                    
                    // 2. Interaktivní Graf
                    interactiveChartCard
                    
                    // 3. Mřížka statistik
                    statsGridSection
                }
                .padding()
            }
            .background(Color(UIColor.systemGroupedBackground))
            .navigationTitle("Statistiky")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        withAnimation {
                            viewModel.generateMockData()
                            // Restart animace
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
    
    // MARK: - Komponenty
    
    private var rangePicker: some View {
        Picker("Range", selection: $viewModel.selectedRange) {
            ForEach(StatsRange.allCases, id: \.self) { range in
                Text(range.rawValue).tag(range)
            }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal, 4)
    }
    
    private var interactiveChartCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Hlavička grafu (Text se mění při dotyku)
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text("Aktivita")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                    
                    if let selectedItem {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("\(selectedItem.value) karet")
                                .font(.system(.title, design: .rounded))
                                .bold()
                                .foregroundStyle(selectedItem.color)
                            
                            Text(selectedItem.date.formatted(date: .abbreviated, time: .omitted))
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .contentTransition(.numericText())
                    } else {
                        // Výchozí stav (Součet)
                        Text("\(viewModel.chartData.reduce(0) { $0 + $1.value }) karet")
                            .font(.system(.title, design: .rounded))
                            .bold()
                            .contentTransition(.numericText())
                    }
                }
                Spacer()
            }
            
            // --- GRAF ---
            Chart {
                // 1. Přerušovaná čára cíle
                RuleMark(y: .value("Cíl", viewModel.dailyGoal))
                    .lineStyle(StrokeStyle(lineWidth: 2, dash: [5, 5]))
                    .foregroundStyle(.gray.opacity(0.5))
                    .annotation(position: .leading, alignment: .bottom) {
                        Text("Cíl")
                            .font(.caption2)
                            .foregroundStyle(.gray)
                    }

                // 2. Sloupce
                ForEach(viewModel.chartData) { item in
                    BarMark(
                        x: .value("Den", item.date, unit: .day),
                        y: .value("Karty", animateChart ? item.value : 0)
                    )
                    .foregroundStyle(
                        // Zprůhlednění nevybraných
                        selectedItem != nil && selectedItem != item
                            ? item.color.opacity(0.3).gradient
                            : item.color.gradient
                    )
                    .cornerRadius(6)
                }
                
                // 3. Kurzoru při výběru
                if let selectedItem {
                    RuleMark(x: .value("Selected", selectedItem.date, unit: .day))
                        .foregroundStyle(Color.gray.opacity(0.1))
                        .zIndex(-1)
                        .annotation(position: .top, overflowResolution: .init(x: .fit, y: .disabled)) {
                            VStack {
                                Text("\(selectedItem.value)")
                                    .font(.caption)
                                    .bold()
                                    .foregroundStyle(.white)
                            }
                            .padding(.vertical, 4)
                            .padding(.horizontal, 8)
                            .background(Color.black.opacity(0.8))
                            .clipShape(Capsule())
                        }
                }
            }
            .frame(height: 220)
            .chartXSelection(value: $rawSelectedDate) // Interaktivita
            .chartXAxis {
                AxisMarks(values: .automatic) { value in
                    if viewModel.selectedRange == .month {
                        AxisGridLine()
                        AxisTick()
                        // Pro měsíc zobrazíme datum jen občas, aby to nebylo přeplácané
                        if let date = value.as(Date.self) {
                            AxisValueLabel { Text(date, format: .dateTime.day()) }
                        }
                    } else if viewModel.selectedRange == .year {
                        AxisValueLabel(format: .dateTime.month(.narrow))
                    } else {
                        AxisValueLabel(format: .dateTime.weekday())
                    }
                }
            }
            .chartYAxis(.hidden)
        }
        .padding(20)
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
    }
    
    private var statsGridSection: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
            
            // 1. Série (Streak)
            StatCard(
                title: "Série",
                value: "\(viewModel.streakDays)",
                unit: "dní",
                icon: "flame.fill",
                color: .orange
            )
            
            // 2. Trend (Oproti minulu)
            let isPositive = viewModel.trendPercentage >= 0
            StatCard(
                title: "Trend",
                value: "\(isPositive ? "+" : "")\(Int(viewModel.trendPercentage))",
                unit: "%",
                icon: isPositive ? "chart.line.uptrend.xyaxis" : "chart.line.downtrend.xyaxis",
                color: isPositive ? .green : .red
            )
            
            // 3. Pravidelnost (Consistency)
            StatCard(
                title: "Pravidelnost",
                value: String(format: "%.0f", viewModel.consistency),
                unit: "%",
                icon: "chart.pie.fill",
                color: .purple
            )
            
            // 4. Úspěšnost
            StatCard(
                title: "Úspěšnost",
                value: String(format: "%.0f", viewModel.overallAccuracy),
                unit: "%",
                icon: "target",
                color: .blue
            )
            
            // 5. XP
            StatCard(
                title: "Zkušenosti",
                value: "\(viewModel.totalXP)",
                unit: "XP",
                icon: "star.fill",
                color: .yellow
            )
            
            // 6. Celkem karet
            StatCard(
                title: "Celkem",
                value: "\(viewModel.totalCardsStudied)",
                unit: "karet",
                icon: "rectangle.stack.fill",
                color: .gray
            )
        }
    }
}
