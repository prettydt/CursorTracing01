//
//  DashboardView.swift
//  AccountingApp
//
//  Created on 2025-10-30.
//

import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var viewModel: TransactionViewModel
    @State private var showAddTransaction = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Month Selector
                    MonthSelectorView()
                        .padding(.horizontal)
                    
                    // Balance Card
                    BalanceCardView()
                        .padding(.horizontal)
                    
                    // Quick Add Buttons
                    HStack(spacing: 15) {
                        QuickAddButton(title: "记收入", icon: "plus.circle.fill", color: .green) {
                            showAddTransaction = true
                        }
                        
                        QuickAddButton(title: "记支出", icon: "minus.circle.fill", color: .red) {
                            showAddTransaction = true
                        }
                    }
                    .padding(.horizontal)
                    
                    // Recent Transactions
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("最近交易")
                                .font(.headline)
                            Spacer()
                            NavigationLink(destination: TransactionListView()) {
                                Text("查看全部")
                                    .font(.subheadline)
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding(.horizontal)
                        
                        ForEach(viewModel.getMonthlyTransactions().prefix(5)) { transaction in
                            TransactionRowView(transaction: transaction)
                                .padding(.horizontal)
                        }
                    }
                    .padding(.vertical)
                }
                .padding(.vertical)
            }
            .navigationTitle("记账")
            .background(Color(.systemGroupedBackground))
            .sheet(isPresented: $showAddTransaction) {
                AddTransactionView()
            }
        }
    }
}

struct BalanceCardView: View {
    @EnvironmentObject var viewModel: TransactionViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 8) {
                Text("本月结余")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text(String(format: "¥%.2f", viewModel.getBalance()))
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(viewModel.getBalance() >= 0 ? .green : .red)
            }
            
            Divider()
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("收入")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text(String(format: "¥%.2f", viewModel.getTotalIncome()))
                        .font(.headline)
                        .foregroundColor(.green)
                }
                
                Spacer()
                
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 1)
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("支出")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text(String(format: "¥%.2f", viewModel.getTotalExpense()))
                        .font(.headline)
                        .foregroundColor(.red)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}

struct QuickAddButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                Text(title)
                    .font(.headline)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(color.opacity(0.1))
            .foregroundColor(color)
            .cornerRadius(12)
        }
    }
}

struct MonthSelectorView: View {
    @EnvironmentObject var viewModel: TransactionViewModel
    
    var body: some View {
        HStack {
            Button(action: previousMonth) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.blue)
            }
            
            Spacer()
            
            Text(monthYearString)
                .font(.headline)
            
            Spacer()
            
            Button(action: nextMonth) {
                Image(systemName: "chevron.right")
                    .foregroundColor(.blue)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
    
    private var monthYearString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年 MM月"
        return formatter.string(from: viewModel.selectedMonth)
    }
    
    private func previousMonth() {
        if let newDate = Calendar.current.date(byAdding: .month, value: -1, to: viewModel.selectedMonth) {
            viewModel.selectedMonth = newDate
        }
    }
    
    private func nextMonth() {
        if let newDate = Calendar.current.date(byAdding: .month, value: 1, to: viewModel.selectedMonth) {
            viewModel.selectedMonth = newDate
        }
    }
}

#Preview {
    DashboardView()
        .environmentObject(TransactionViewModel())
}
