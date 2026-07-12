// notifier.swift
import Foundation

struct Deal: Codable {
    let name: String
    let price: Double
    let discount: Int
    let category: String
    let link: String
}

class Notifier {
    private var deals: [Deal] = []
    private let categories = ["electronics", "clothing", "books", "home", "toys"]

    init() {
        generateMockDeals()
    }

    func generateMockDeals() {
        let productData: [(String, Double, Int, String)] = [
            ("Wireless Headphones", 49.99, 20, "electronics"),
            ("Men's Jacket", 89.99, 30, "clothing"),
            ("Programming Book", 29.99, 15, "books"),
            ("Smart Watch", 199.99, 25, "electronics"),
            ("Running Shoes", 69.99, 10, "clothing"),
            ("Board Game", 39.99, 5, "toys"),
            ("Coffee Machine", 129.99, 40, "home"),
            ("Drone", 299.99, 50, "electronics"),
            ("Jeans", 49.99, 20, "clothing"),
            ("Cookbook", 19.99, 10, "books"),
            ("Robot Vacuum", 249.99, 35, "home"),
            ("LEGO Set", 59.99, 15, "toys")
        ]
        deals = productData.map { Deal(name: $0.0, price: $0.1, discount: $0.2, category: $0.3, link: "") }
    }

    func refresh() {
        generateMockDeals()
    }

    func filterByCategory(_ category: String) -> [Deal] {
        return deals.filter { $0.category.lowercased() == category.lowercased() }
    }

    func searchByKeyword(_ keyword: String) -> [Deal] {
        let kw = keyword.lowercased()
        return deals.filter { $0.name.lowercased().contains(kw) }
    }

    func exportJSON(filename: String) -> Bool {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(deals)
            try data.write(to: URL(fileURLWithPath: filename))
            return true
        } catch {
            print("Export failed: \(error)")
            return false
        }
    }

    func exportCSV(filename: String) -> Bool {
        var lines = ["Name,Price,Discount%,Category,Link"]
        for d in deals {
            lines.append("\"\(d.name)\",\(d.price),\(d.discount),\"\(d.category)\",\"\(d.link)\"")
        }
        do {
            try lines.joined(separator: "\n").write(toFile: filename, atomically: true, encoding: .utf8)
            return true
        } catch {
            print("Export failed: \(error)")
            return false
        }
    }

    func displayDeals(_ deals: [Deal]? = nil, limit: Int = 20) {
        let display = deals ?? self.deals
        if display.isEmpty {
            print("No deals available.")
            return
        }
        print("\n📦 Deals (\(display.count) total):")
        print(String(repeating: "-", count: 60))
        for (i, d) in display.prefix(limit).enumerated() {
            print("[\(i+1)] 🔥 \(d.name) – $\(String(format: "%.2f", d.price)) (-\(d.discount)%) [\(d.category)]")
        }
        if display.count > limit {
            print("... and \(display.count - limit) more")
        }
    }
}

func main() {
    let notifier = Notifier()
    print("=== Discount Notifier ===")
    while true {
        print("\n1. Show all deals")
        print("2. Filter by category")
        print("3. Search by keyword")
        print("4. Export to JSON")
        print("5. Export to CSV")
        print("6. Refresh deals")
        print("7. Exit")
        print("Choose: ", terminator: "")
        guard let choice = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines) else { continue }
        switch choice {
        case "1":
            notifier.displayDeals()
        case "2":
            print("Enter category (electronics, clothing, books, home, toys): ", terminator: "")
            guard let cat = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines) else { break }
            if !cat.isEmpty {
                let filtered = notifier.filterByCategory(cat)
                notifier.displayDeals(filtered)
            } else {
                print("No category entered.")
            }
        case "3":
            print("Enter keyword: ", terminator: "")
            guard let kw = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines) else { break }
            if !kw.isEmpty {
                let found = notifier.searchByKeyword(kw)
                notifier.displayDeals(found)
            } else {
                print("No keyword entered.")
            }
        case "4":
            print("Filename (default: deals.json): ", terminator: "")
            var fname = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "deals.json"
            if fname.isEmpty { fname = "deals.json" }
            if notifier.exportJSON(filename: fname) {
                print("Exported to \(fname)")
            }
        case "5":
            print("Filename (default: deals.csv): ", terminator: "")
            var fname = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "deals.csv"
            if fname.isEmpty { fname = "deals.csv" }
            if notifier.exportCSV(filename: fname) {
                print("Exported to \(fname)")
            }
        case "6":
            notifier.refresh()
            print("Deals refreshed.")
        case "7":
            print("Goodbye!")
            return
        default:
            print("Invalid choice.")
        }
    }
}

main()
