//
//  Transaction.swift
//  AccountingApp
//
//  Created on 2025-10-30.
//

import Foundation

enum TransactionType: String, Codable, CaseIterable {
    case income = "收入"
    case expense = "支出"
}

struct Transaction: Identifiable, Codable, Equatable {
    var id: UUID
    var amount: Double
    var type: TransactionType
    var category: Category
    var note: String
    var date: Date
    var account: String
    
    init(id: UUID = UUID(),
         amount: Double,
         type: TransactionType,
         category: Category,
         note: String = "",
         date: Date = Date(),
         account: String = "现金") {
        self.id = id
        self.amount = amount
        self.type = type
        self.category = category
        self.note = note
        self.date = date
        self.account = account
    }
    
    var signedAmount: Double {
        type == .income ? amount : -amount
    }
}

struct Category: Codable, Equatable, Hashable {
    var name: String
    var icon: String
    var type: TransactionType
    
    static let expenseCategories: [Category] = [
        Category(name: "餐饮", icon: "🍜", type: .expense),
        Category(name: "交通", icon: "🚗", type: .expense),
        Category(name: "购物", icon: "🛍️", type: .expense),
        Category(name: "娱乐", icon: "🎮", type: .expense),
        Category(name: "医疗", icon: "🏥", type: .expense),
        Category(name: "教育", icon: "📚", type: .expense),
        Category(name: "住房", icon: "🏠", type: .expense),
        Category(name: "通讯", icon: "📱", type: .expense),
        Category(name: "其他", icon: "💰", type: .expense)
    ]
    
    static let incomeCategories: [Category] = [
        Category(name: "工资", icon: "💼", type: .income),
        Category(name: "奖金", icon: "🎁", type: .income),
        Category(name: "投资", icon: "📈", type: .income),
        Category(name: "兼职", icon: "💻", type: .income),
        Category(name: "红包", icon: "🧧", type: .income),
        Category(name: "其他", icon: "💰", type: .income)
    ]
}
