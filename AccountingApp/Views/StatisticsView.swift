//
//  StatisticsView.swift
//  AccountingApp
//
//  Created on 2025-10-30.
//

import SwiftUI
import Charts

struct StatisticsView: View {
    @EnvironmentObject var viewModel: TransactionViewModel
    @State private var selectedSegment = 0
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Month Selector
                    MonthSelectorView()
                        .padding(.horizontal)
                    
                    // Segment Control
                    Picker("", selection: $selectedSegment) {
                        Text("支出").tag(0)
                        Text("收入").tag(1)
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                    
                    // Statistics Summary
                    StatisticsSummaryView(selectedSegment: selectedSegment)
                        .padding(.horizontal)
                    
                    // Category Breakdown
                    CategoryBreakdownView(selectedSegment: selectedSegment)
                        .padding(.horizontal)
                    
                    // Daily Trend (only for expenses)
                    if selectedSegment == 0 {
                        DailyTrendView()
                            .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("统计")
            .background(Color(.systemGroupedBackground))
        }
    }
}

struct StatisticsSummaryView: View {
    @EnvironmentObject var viewModel: TransactionViewModel
    let selectedSegment: Int
    
    var totalAmount: Double {
        selectedSegment == 0 ? viewModel.getTotalExpense() : viewModel.getTotalIncome()
    }
    
    var averageDaily: Double {
        let days = Calendar.current.range(of: .day, in: .month, for: viewModel.selectedMonth)?.count ?? 30
        return totalAmount / Double(days)
    }
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(selectedSegment == 0 ? "总支出" : "总收入")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text(String(format: "¥%.2f", totalAmount))
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(selectedSegment == 0 ? .red : .green)
                }
                
                Spacer()
            }
            
            Divider()
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("日均")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(String(format: "¥%.2f", averageDaily))
                        .font(.headline)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("交易笔数")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("\(viewModel.getMonthlyTransactions().filter { $0.type == (selectedSegment == 0 ? .expense : .income) }.count)")
                        .font(.headline)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}

struct CategoryBreakdownView: View {
    @EnvironmentObject var viewModel: TransactionViewModel
    let selectedSegment: Int
    
    var categoryData: [(category: Category, amount: Double)] {
        selectedSegment == 0 ? viewModel.getCategoryExpenses() : viewModel.getCategoryIncome()
    }
    
    var totalAmount: Double {
        categoryData.reduce(0) { $0 + $1.amount }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("分类明细")
                .font(.headline)
            
            VStack(spacing: 12) {
                ForEach(categoryData, id: \.category) { item in
                    CategoryBarView(
                        category: item.category,
                        amount: item.amount,
                        percentage: totalAmount > 0 ? item.amount / totalAmount : 0,
                        color: selectedSegment == 0 ? .red : .green
                    )
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
        }
    }
}

struct CategoryBarView: View {
    let category: Category
    let amount: Double
    let percentage: Double
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                HStack(spacing: 8) {
                    Text(category.icon)
                        .font(.title3)
                    Text(category.name)
                        .font(.subheadline)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 2) {
                    Text(String(format: "¥%.2f", amount))
                        .font(.headline)
                    Text(String(format: "%.1f%%", percentage * 100))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.1))
                        .frame(height: 8)
                        .cornerRadius(4)
                    
                    Rectangle()
                        .fill(color)
                        .frame(width: geometry.size.width * percentage, height: 8)
                        .cornerRadius(4)
                }
            }
            .frame(height: 8)
        }
    }
}

struct DailyTrendView: View {
    @EnvironmentObject var viewModel: TransactionViewModel
    
    var dailyData: [(date: Date, amount: Double)] {
        viewModel.getDailyExpenses()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("每日支出趋势")
                .font(.headline)
            
            if dailyData.isEmpty {
                Text("暂无数据")
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(16)
            } else {
                VStack {
                    Chart {
                        ForEach(dailyData, id: \.date) { item in
                            BarMark(
                                x: .value("日期", item.date, unit: .day),
                                y: .value("金额", item.amount)
                            )
                            .foregroundStyle(.red.gradient)
                        }
                    }
                    .frame(height: 200)
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
            }
        }
    }
}

#Preview {
    StatisticsView()
        .environmentObject(TransactionViewModel())
}
