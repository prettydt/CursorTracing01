//
//  TransactionDetailView.swift
//  AccountingApp
//
//  Created on 2025-10-30.
//

import SwiftUI

struct TransactionDetailView: View {
    @EnvironmentObject var viewModel: TransactionViewModel
    @Environment(\.dismiss) var dismiss
    let transaction: Transaction
    
    @State private var showDeleteAlert = false
    
    var body: some View {
        List {
            Section {
                HStack {
                    Text("金额")
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(String(format: "¥%.2f", transaction.amount))
                        .font(.headline)
                        .foregroundColor(transaction.type == .income ? .green : .red)
                }
                
                HStack {
                    Text("类型")
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(transaction.type.rawValue)
                }
                
                HStack {
                    Text("分类")
                        .foregroundColor(.secondary)
                    Spacer()
                    HStack {
                        Text(transaction.category.icon)
                        Text(transaction.category.name)
                    }
                }
            }
            
            Section {
                HStack {
                    Text("日期")
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(dateString)
                }
                
                HStack {
                    Text("账户")
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(transaction.account)
                }
            }
            
            if !transaction.note.isEmpty {
                Section(header: Text("备注")) {
                    Text(transaction.note)
                }
            }
            
            Section {
                Button(role: .destructive) {
                    showDeleteAlert = true
                } label: {
                    HStack {
                        Spacer()
                        Text("删除此交易")
                        Spacer()
                    }
                }
            }
        }
        .navigationTitle("交易详情")
        .navigationBarTitleDisplayMode(.inline)
        .alert("删除交易", isPresented: $showDeleteAlert) {
            Button("取消", role: .cancel) { }
            Button("删除", role: .destructive) {
                viewModel.deleteTransaction(transaction)
                dismiss()
            }
        } message: {
            Text("确定要删除这笔交易吗？此操作无法撤销。")
        }
    }
    
    private var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter.string(from: transaction.date)
    }
}

#Preview {
    NavigationView {
        TransactionDetailView(
            transaction: Transaction(
                amount: 100,
                type: .expense,
                category: Category.expenseCategories[0],
                note: "午餐"
            )
        )
        .environmentObject(TransactionViewModel())
    }
}
