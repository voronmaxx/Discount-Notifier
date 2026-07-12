🏷️ Discount Notifier – Multi‑Language Edition

A versatile **discount notifier** that parses deal websites, extracts discounts, and notifies you about the best offers.  
Supports filtering by category, saving to file, and scheduled checks.  
Built in **7 programming languages** – perfect for tracking deals, learning web scraping, or building price alert tools.

## ✨ Features
- **Parse deals** – extracts product name, price, discount percentage, and link from a sample website (or local test data).
- **Filter by category** – show only deals from specific categories (e.g., `electronics`, `clothing`, `books`).
- **Search by keyword** – find deals containing specific words.
- **Save to file** – export deals to JSON or CSV.
- **Notify** – prints deals to the console with a clear summary.
- **Interactive CLI** – easy menu with filtering and refresh options.

## 🗂 Languages & Files
| Language          | File                 |
|-------------------|----------------------|
| Python            | `notifier.py`        |
| Go                | `notifier.go`        |
| JavaScript (Node) | `notifier.js`        |
| C#                | `Notifier.cs`        |
| Java              | `Notifier.java`      |
| Ruby              | `notifier.rb`        |
| Swift             | `notifier.swift`     |

## 🚀 How to Run
Each file is standalone – run it with the appropriate interpreter/compiler.  
All versions use **mock data** for demonstration, but you can replace the source with a real website parser.

| Language | Command |
|----------|---------|
| Python   | `python notifier.py` |
| Go       | `go run notifier.go` |
| JavaScript | `node notifier.js` |
| C#       | `dotnet run` (or `csc Notifier.cs && Notifier.exe`) |
| Java     | `javac Notifier.java && java Notifier` |
| Ruby     | `ruby notifier.rb` |
| Swift    | `swift notifier.swift` |

## 📊 Example Session
=== Discount Notifier ===

Show all deals

Filter by category

Search by keyword

Export to JSON

Export to CSV

Refresh deals

Exit
Choose: 1

📦 Deals (12 total):
[1] 🔥 Wireless Headphones – $49.99 (-20%) [electronics]
[2] 🔥 Men's Jacket – $89.99 (-30%) [clothing]
[3] 🔥 Programming Book – $29.99 (-15%) [books]
...

Choose: 2
Enter category (electronics, clothing, books): electronics
📦 Deals in 'electronics':
[1] Wireless Headphones – $49.99 (-20%)
[2] Smart Watch – $199.99 (-25%)

text

## 🔧 Commands
| Option | Description |
|--------|-------------|
| `1` | Show all deals |
| `2` | Filter deals by category |
| `3` | Search deals by keyword |
| `4` | Export all deals to JSON |
| `5` | Export all deals to CSV |
| `6` | Refresh deals (re‑parse) |
| `7` | Exit |

## 📁 Export Formats
- **JSON** – structured deal data.
- **CSV** – simple table format.

## 🤝 Contributing
Replace the mock data with real web scrapers (e.g., for Amazon, eBay, or local deal sites) – PRs welcome!

## 📜 License
MIT – use freely.
