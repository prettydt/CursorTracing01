//
//  DataManager.swift
//  AccountingApp
//
//  Created on 2025-10-30.
//

import Foundation

class DataManager {
    static let shared = DataManager()
    
    private let transactionsKey = "transactions"
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    private init() {
        encoder.dateEncodingStrategy = .iso8601
        decoder.dateDecodingStrategy = .iso8601
    }
    
    func saveTransactions(_ transactions: [Transaction]) {
        if let encoded = try? encoder.encode(transactions) {
            UserDefaults.standard.set(encoded, forKey: transactionsKey)
        }
    }
    
    func loadTransactions() -> [Transaction] {
        guard let data = UserDefaults.standard.data(forKey: transactionsKey),
              let transactions = try? decoder.decode([Transaction].self, from: data) else {
            return generateSampleData()
        }
        return transactions
    }
    
    private func generateSampleData() -> [Transaction] {
        let calendar = Calendar.current
        let now = Date()
        
        return [
            Transaction(
                amount: 8500,
                type: .income,
                category: Category.incomeCategories[0],
                note: "月工资",
                date: calendar.date(byAdding: .day, value: -25, to: now) ?? now
            ),
            Transaction(
                amount: 45.5,
                type: .expense,
                category: Category.expenseCategories[0],
                note: "午餐",
                date: calendar.date(byAdding: .day, value: -2, to: now) ?? now
            ),
            Transaction(
                amount: 1200,
                type: .expense,
                category: Category.expenseCategories[2],
                note: "买衣服",
                date: calendar.date(byAdding: .day, value: -5, to: now) ?? now
            ),
            Transaction(
                amount: 30,
                type: .expense,
                category: Category.expenseCategories[1],
                note: "地铁卡充值",
                date: calendar.date(byAdding: .day, value: -1, to: now) ?? now
            ),
            Transaction(
                amount: 2000,
                type: .income,
                category: Category.incomeCategories[1],
                note: "项目奖金",
                date: calendar.date(byAdding: .day, value: -10, to: now) ?? now
            )
        ]
    }
}
