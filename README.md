# Case Farm Helper

iOS app designed to help track weekly CS2 case drops across multiple accounts. It provides a clean, visual way to manage your accounts, log weekly drops, record trades and purchases, and analyze your inventory over time.

Key Features:
- **Account Management**: Add your existing accounts manually or batch import them from Steam. Editable case inventory
- **Case Tracking**: Log weekly case drops per account. Identify accounts that haven't yet received their drops
- **Inventory Management**: Record trades and purchases, track case counts per account
- **Analytics**: Statistics for your inventory, drop rates, purchases. Inventory valuation and price tracking

Techincal Implementation:
- **SwiftUI & MVVM** - Modern iOS development
- **JSON Persistence** - Custom serialization/deserialization with DTO pattern
- **Steam API Integration** - Automated profile data fetching via Steam Web API
- **Case Price API** - Real-time market price fetching using async/await
- **File Picker** - CSV/txt with document picker
- **Progress Tracking** - Real-time import status with SwiftUI state management

Tech Stack:
- **Language**: Swift
- **UI**: SwiftUI
- **Architecture**: MVVM with EnvironmentalObject
- **Charts**: SwitfUI Charts framework
- **Persistence**: Custom JSON with Codable
- **Networking**: URLSession with async/await
