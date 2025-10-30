//
//  AddTransactionView.swift
//  AccountingApp
//
//  Created on 2025-10-30.
//

import SwiftUI

struct AddTransactionView: View {
    @EnvironmentObject var viewModel: TransactionViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var amount: String = ""
    @State private var selectedType: TransactionType = .expense
    @State private var selectedCategory: Category = Category.expenseCategories[0]
    @State private var note: String = ""
    @State private var date: Date = Date()
    @State private var account: String = "现金"
    
    var categories: [Category] {
        selectedType == .expense ? Category.expenseCategories : Category.incomeCategories
    }
    
    var body: some View {
        NavigationView {
            Form {
                // Type Selector
                Section {
                    Picker("类型", selection: $selectedType) {
                        Text("支出").tag(TransactionType.expense)
                        Text("收入").tag(TransactionType.income)
                    }
                    .pickerStyle(.segmented)
                    .onChange(of: selectedType) { newType in
                        selectedCategory = newType == .expense ? 
                            Category.expenseCategories[0] : 
                            Category.incomeCategories[0]
                    }
                }
                
                // Amount
                Section(header: Text("金额")) {
                    HStack {
                        Text("¥")
                            .font(.title)
                            .foregroundColor(.secondary)
                        TextField("0.00", text: $amount)
                            .keyboardType(.decimalPad)
                            .font(.title)
                    }
                }
                
                // Category Selection
                Section(header: Text("分类")) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(categories, id: \.name) { category in
                                CategoryButton(
                                    category: category,
                                    isSelected: selectedCategory == category
                                ) {
                                    selectedCategory = category
                                }
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
                
                // Date
                Section(header: Text("日期")) {
                    DatePicker("选择日期", selection: $date, displayedComponents: [.date, .hourAndMinute])
                }
                
                // Account
                Section(header: Text("账户")) {
                    Picker("账户", selection: $account) {
                        Text("现金").tag("现金")
                        Text("银行卡").tag("银行卡")
                        Text("支付宝").tag("支付宝")
                        Text("微信").tag("微信")
                    }
                }
                
                // Note
                Section(header: Text("备注")) {
                    TextField("添加备注", text: $note)
                }
            }
            .navigationTitle("添加交易")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("取消") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("保存") {
                        saveTransaction()
                    }
                    .disabled(amount.isEmpty || Double(amount) == nil)
                }
            }
        }
    }
    
    private func saveTransaction() {
        guard let amountValue = Double(amount) else { return }
        
        let transaction = Transaction(
            amount: amountValue,
            type: selectedType,
            category: selectedCategory,
            note: note,
            date: date,
            account: account
        )
        
        viewModel.addTransaction(transaction)
        dismiss()
    }
}

struct CategoryButton: View {
    let category: Category
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Text(category.icon)
                    .font(.title)
                Text(category.name)
                    .font(.caption)
                    .foregroundColor(isSelected ? .white : .primary)
            }
            .frame(width: 70, height: 70)
            .background(isSelected ? Color.blue : Color.gray.opacity(0.1))
            .cornerRadius(12)
        }
    }
}

#Preview {
    AddTransactionView()
        .environmentObject(TransactionViewModel())
}
