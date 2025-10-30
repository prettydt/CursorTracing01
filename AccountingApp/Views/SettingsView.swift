//
//  SettingsView.swift
//  AccountingApp
//
//  Created on 2025-10-30.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var viewModel: TransactionViewModel
    @State private var showDeleteAlert = false
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("账户信息")) {
                    HStack {
                        Image(systemName: "person.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(.blue)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("用户")
                                .font(.headline)
                            Text("记账达人")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding(.leading, 8)
                    }
                    .padding(.vertical, 8)
                }
                
                Section(header: Text("统计")) {
                    HStack {
                        Label("总交易笔数", systemImage: "list.bullet")
                        Spacer()
                        Text("\(viewModel.transactions.count)")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Label("记账天数", systemImage: "calendar")
                        Spacer()
                        Text("\(calculateDaysOfRecord())")
                            .foregroundColor(.secondary)
                    }
                }
                
                Section(header: Text("数据管理")) {
                    Button(action: {
                        showDeleteAlert = true
                    }) {
                        HStack {
                            Label("清空所有数据", systemImage: "trash")
                                .foregroundColor(.red)
                        }
                    }
                }
                
                Section(header: Text("关于")) {
                    HStack {
                        Text("版本")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                    
                    Link(destination: URL(string: "https://github.com")!) {
                        HStack {
                            Text("反馈建议")
                            Spacer()
                            Image(systemName: "arrow.up.forward")
                                .font(.caption)
                        }
                    }
                }
            }
            .navigationTitle("我的")
            .alert("清空数据", isPresented: $showDeleteAlert) {
                Button("取消", role: .cancel) { }
                Button("清空", role: .destructive) {
                    clearAllData()
                }
            } message: {
                Text("此操作将删除所有交易记录，且无法恢复。确定要继续吗？")
            }
        }
    }
    
    private func calculateDaysOfRecord() -> Int {
        guard let firstDate = viewModel.transactions.map({ $0.date }).min() else {
            return 0
        }
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: firstDate, to: Date())
        return (components.day ?? 0) + 1
    }
    
    private func clearAllData() {
        viewModel.transactions.removeAll()
        DataManager.shared.saveTransactions([])
    }
}

#Preview {
    SettingsView()
        .environmentObject(TransactionViewModel())
}
