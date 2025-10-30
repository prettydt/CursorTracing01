//
//  TransactionListView.swift
//  AccountingApp
//
//  Created on 2025-10-30.
//

import SwiftUI

struct TransactionListView: View {
    @EnvironmentObject var viewModel: TransactionViewModel
    @State private var showAddTransaction = false
    @State private var searchText = ""
    
    var filteredTransactions: [Transaction] {
        let transactions = viewModel.getMonthlyTransactions()
        if searchText.isEmpty {
            return transactions
        } else {
            return transactions.filter { transaction in
                transaction.note.localizedCaseInsensitiveContains(searchText) ||
                transaction.category.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var groupedTransactions: [(String, [Transaction])] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: filteredTransactions) { transaction in
            calendar.startOfDay(for: transaction.date)
        }
        
        return grouped.map { (key, value) in
            let formatter = DateFormatter()
            formatter.dateFormat = "MM月dd日 EEEE"
            return (formatter.string(from: key), value.sorted { $0.date > $1.date })
        }
        .sorted { $0.0 > $1.0 }
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(groupedTransactions, id: \.0) { date, transactions in
                    Section(header: Text(date)) {
                        ForEach(transactions) { transaction in
                            NavigationLink(destination: TransactionDetailView(transaction: transaction)) {
                                TransactionRowView(transaction: transaction)
                            }
                        }
                        .onDelete { indexSet in
                            indexSet.forEach { index in
                                viewModel.deleteTransaction(transactions[index])
                            }
                        }
                    }
                }
            }
            .navigationTitle("账单")
            .searchable(text: $searchText, prompt: "搜索交易记录")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showAddTransaction = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAddTransaction) {
                AddTransactionView()
            }
        }
    }
}

struct TransactionRowView: View {
    let transaction: Transaction
    
    var body: some View {
        HStack(spacing: 12) {
            // Category Icon
            Text(transaction.category.icon)
                .font(.title2)
                .frame(width: 50, height: 50)
                .background(Circle().fill(Color.gray.opacity(0.1)))
            
            // Transaction Info
            VStack(alignment: .leading, spacing: 4) {
                Text(transaction.category.name)
                    .font(.headline)
                
                if !transaction.note.isEmpty {
                    Text(transaction.note)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
            }
            
            Spacer()
            
            // Amount
            Text(String(format: "%@%.2f", transaction.type == .income ? "+" : "-", transaction.amount))
                .font(.headline)
                .foregroundColor(transaction.type == .income ? .green : .primary)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    TransactionListView()
        .environmentObject(TransactionViewModel())
}
