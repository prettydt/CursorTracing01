//
//  TransactionViewModel.swift
//  AccountingApp
//
//  Created on 2025-10-30.
//

import Foundation
import Combine

class TransactionViewModel: ObservableObject {
    @Published var transactions: [Transaction] = []
    @Published var selectedMonth: Date = Date()
    
    private let dataManager = DataManager.shared
    
    init() {
        loadTransactions()
    }
    
    func loadTransactions() {
        transactions = dataManager.loadTransactions()
    }
    
    func addTransaction(_ transaction: Transaction) {
        transactions.append(transaction)
        saveTransactions()
    }
    
    func deleteTransaction(_ transaction: Transaction) {
        transactions.removeAll { $0.id == transaction.id }
        saveTransactions()
    }
    
    func updateTransaction(_ transaction: Transaction) {
        if let index = transactions.firstIndex(where: { $0.id == transaction.id }) {
            transactions[index] = transaction
            saveTransactions()
        }
    }
    
    private func saveTransactions() {
        dataManager.saveTransactions(transactions)
    }
    
    // MARK: - Statistics
    
    func getMonthlyTransactions() -> [Transaction] {
        let calendar = Calendar.current
        return transactions.filter { transaction in
            calendar.isDate(transaction.date, equalTo: selectedMonth, toGranularity: .month)
        }
    }
    
    func getTotalIncome() -> Double {
        getMonthlyTransactions()
            .filter { $0.type == .income }
            .reduce(0) { $0 + $1.amount }
    }
    
    func getTotalExpense() -> Double {
        getMonthlyTransactions()
            .filter { $0.type == .expense }
            .reduce(0) { $0 + $1.amount }
    }
    
    func getBalance() -> Double {
        getTotalIncome() - getTotalExpense()
    }
    
    func getCategoryExpenses() -> [(category: Category, amount: Double)] {
        let expenseTransactions = getMonthlyTransactions().filter { $0.type == .expense }
        let grouped = Dictionary(grouping: expenseTransactions) { $0.category }
        
        return grouped.map { (category: $0.key, amount: $0.value.reduce(0) { $0 + $1.amount }) }
            .sorted { $0.amount > $1.amount }
    }
    
    func getCategoryIncome() -> [(category: Category, amount: Double)] {
        let incomeTransactions = getMonthlyTransactions().filter { $0.type == .income }
        let grouped = Dictionary(grouping: incomeTransactions) { $0.category }
        
        return grouped.map { (category: $0.key, amount: $0.value.reduce(0) { $0 + $1.amount }) }
            .sorted { $0.amount > $1.amount }
    }
    
    func getDailyExpenses() -> [(date: Date, amount: Double)] {
        let calendar = Calendar.current
        let expenseTransactions = getMonthlyTransactions().filter { $0.type == .expense }
        let grouped = Dictionary(grouping: expenseTransactions) { transaction in
            calendar.startOfDay(for: transaction.date)
        }
        
        return grouped.map { (date: $0.key, amount: $0.value.reduce(0) { $0 + $1.amount }) }
            .sorted { $0.date < $1.date }
    }
}
