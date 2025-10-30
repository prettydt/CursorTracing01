# 记账本 - iOS 记账应用

一个功能完整的 iOS 记账应用，使用 SwiftUI 构建，支持收支管理、数据统计和图表分析。

## ✨ 功能特性

### 📊 核心功能
- **收支记录** - 快速记录收入和支出
- **分类管理** - 预设多种收支分类（餐饮、交通、购物等）
- **账户管理** - 支持现金、银行卡、支付宝、微信等多种账户
- **月度统计** - 自动计算月度收入、支出和结余
- **数据可视化** - 分类占比、每日趋势图表展示

### 🎨 界面设计
- 现代化的 iOS 原生设计
- 直观的导航和操作流程
- 优雅的数据展示方式
- 流畅的动画效果

### 💾 数据管理
- 本地数据持久化存储
- 支持数据搜索和筛选
- 交易记录详情查看
- 一键清空所有数据

## 📱 应用截图

### 主要界面
- **首页** - 显示月度财务概览和最近交易
- **账单** - 按日期分组的详细交易列表
- **统计** - 分类统计和趋势图表
- **我的** - 用户信息和数据管理

## 🛠️ 技术栈

- **语言**: Swift
- **框架**: SwiftUI
- **最低版本**: iOS 16.0+
- **架构**: MVVM (Model-View-ViewModel)
- **数据持久化**: UserDefaults + JSON

## 📂 项目结构

```
AccountingApp/
├── Models/
│   └── Transaction.swift          # 数据模型
├── ViewModels/
│   └── TransactionViewModel.swift # 视图模型和业务逻辑
├── Services/
│   └── DataManager.swift          # 数据持久化服务
├── Views/
│   ├── ContentView.swift          # 主视图和标签栏
│   ├── DashboardView.swift        # 首页仪表板
│   ├── TransactionListView.swift # 交易列表
│   ├── AddTransactionView.swift  # 添加交易
│   ├── TransactionDetailView.swift # 交易详情
│   ├── StatisticsView.swift      # 统计分析
│   └── SettingsView.swift        # 设置页面
└── AccountingApp.swift            # 应用入口
```

## 🚀 如何使用

### 在 Xcode 中创建项目

1. **打开 Xcode**，选择 "Create a new Xcode project"

2. **选择模板**:
   - iOS → App
   - 点击 Next

3. **配置项目**:
   - Product Name: `AccountingApp`
   - Interface: `SwiftUI`
   - Language: `Swift`
   - Storage: `None` (我们使用自定义持久化)

4. **导入源代码**:
   - 将本仓库中的 `AccountingApp/` 文件夹内的所有文件复制到 Xcode 项目中
   - 确保文件按照相同的目录结构组织

5. **运行应用**:
   - 选择目标设备（模拟器或真机）
   - 点击 Run (⌘R)

### 快速开始

1. **添加交易**
   - 点击首页的"记收入"或"记支出"按钮
   - 输入金额、选择分类、添加备注
   - 点击"保存"

2. **查看账单**
   - 切换到"账单"标签
   - 按日期查看所有交易记录
   - 点击任意记录查看详情或删除

3. **查看统计**
   - 切换到"统计"标签
   - 查看分类占比和支出趋势
   - 切换"支出"/"收入"查看不同类型的统计

4. **月份切换**
   - 在首页或统计页面点击左右箭头切换月份
   - 查看不同月份的财务数据

## 📊 数据模型

### Transaction (交易)
```swift
- id: UUID              // 唯一标识
- amount: Double        // 金额
- type: TransactionType // 类型（收入/支出）
- category: Category    // 分类
- note: String          // 备注
- date: Date           // 日期时间
- account: String      // 账户
```

### Category (分类)
```swift
- name: String              // 名称
- icon: String             // 图标（Emoji）
- type: TransactionType    // 类型
```

## 🎯 预设分类

### 支出分类
- 🍜 餐饮
- 🚗 交通
- 🛍️ 购物
- 🎮 娱乐
- 🏥 医疗
- 📚 教育
- 🏠 住房
- 📱 通讯
- 💰 其他

### 收入分类
- 💼 工资
- 🎁 奖金
- 📈 投资
- 💻 兼职
- 🧧 红包
- 💰 其他

## 🔧 自定义配置

### 修改默认分类
编辑 `Transaction.swift` 中的 `Category.expenseCategories` 和 `Category.incomeCategories`

### 修改默认账户
编辑 `AddTransactionView.swift` 中的账户选择器选项

### 添加新功能
- 在 `TransactionViewModel.swift` 中添加业务逻辑
- 在 `Views/` 目录中添加新的视图
- 通过 `DataManager.swift` 扩展数据持久化能力

## 📝 待优化功能

- [ ] 支持预算设置和提醒
- [ ] 添加多账本功能
- [ ] 支持数据导出（CSV/Excel）
- [ ] 添加更多图表类型
- [ ] 支持自定义分类
- [ ] 添加周期性交易（如月付账单）
- [ ] 支持数据云同步
- [ ] 添加面容/指纹解锁

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

## 📄 许可证

MIT License

## 👨‍💻 作者

初体验 Cursor - 2025

---

**注意**: 这是一个示例应用，主要用于学习和演示目的。在生产环境中使用前，建议增强数据安全性和错误处理机制。
