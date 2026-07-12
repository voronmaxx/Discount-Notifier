# notifier.py
import json
import csv
import random
from datetime import datetime
from typing import List, Dict, Optional

class Deal:
    def __init__(self, name: str, price: float, discount: int, category: str, link: str = ""):
        self.name = name
        self.price = price
        self.discount = discount
        self.category = category
        self.link = link

    def to_dict(self) -> Dict:
        return {
            "name": self.name,
            "price": self.price,
            "discount": self.discount,
            "category": self.category,
            "link": self.link
        }

class Notifier:
    def __init__(self):
        self.deals: List[Deal] = []
        self.categories = ["electronics", "clothing", "books", "home", "toys"]
        self._generate_mock_deals()

    def _generate_mock_deals(self):
        products = [
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
            ("LEGO Set", 59.99, 15, "toys"),
        ]
        for name, price, discount, cat in products:
            self.deals.append(Deal(name, price, discount, cat))

    def refresh(self):
        # In real implementation, parse a website here.
        self._generate_mock_deals()
        return self.deals

    def filter_by_category(self, category: str) -> List[Deal]:
        return [d for d in self.deals if d.category.lower() == category.lower()]

    def search_by_keyword(self, keyword: str) -> List[Deal]:
        kw = keyword.lower()
        return [d for d in self.deals if kw in d.name.lower()]

    def export_json(self, filename: str = "deals.json") -> bool:
        try:
            data = [d.to_dict() for d in self.deals]
            with open(filename, "w", encoding="utf-8") as f:
                json.dump(data, f, indent=2, ensure_ascii=False)
            return True
        except Exception as e:
            print(f"Export failed: {e}")
            return False

    def export_csv(self, filename: str = "deals.csv") -> bool:
        try:
            with open(filename, "w", newline="", encoding="utf-8") as f:
                writer = csv.writer(f)
                writer.writerow(["Name", "Price", "Discount%", "Category", "Link"])
                for d in self.deals:
                    writer.writerow([d.name, d.price, d.discount, d.category, d.link])
            return True
        except Exception as e:
            print(f"Export failed: {e}")
            return False

    def display_deals(self, deals: Optional[List[Deal]] = None, limit: int = 20):
        if deals is None:
            deals = self.deals
        if not deals:
            print("No deals available.")
            return
        print(f"\n📦 Deals ({len(deals)} total):")
        print("-" * 60)
        for i, d in enumerate(deals[:limit], 1):
            print(f"[{i}] 🔥 {d.name} – ${d.price:.2f} (-{d.discount}%) [{d.category}]")
        if len(deals) > limit:
            print(f"... and {len(deals) - limit} more")

def main():
    notifier = Notifier()
    print("=== Discount Notifier ===")
    while True:
        print("\n1. Show all deals")
        print("2. Filter by category")
        print("3. Search by keyword")
        print("4. Export to JSON")
        print("5. Export to CSV")
        print("6. Refresh deals")
        print("7. Exit")
        choice = input("Choose: ").strip()
        if choice == "1":
            notifier.display_deals()
        elif choice == "2":
            category = input("Enter category (electronics, clothing, books, home, toys): ").strip()
            if category:
                filtered = notifier.filter_by_category(category)
                notifier.display_deals(filtered)
            else:
                print("No category entered.")
        elif choice == "3":
            keyword = input("Enter keyword: ").strip()
            if keyword:
                found = notifier.search_by_keyword(keyword)
                notifier.display_deals(found)
            else:
                print("No keyword entered.")
        elif choice == "4":
            fname = input("Filename (default: deals.json): ").strip() or "deals.json"
            if notifier.export_json(fname):
                print(f"Exported to {fname}")
        elif choice == "5":
            fname = input("Filename (default: deals.csv): ").strip() or "deals.csv"
            if notifier.export_csv(fname):
                print(f"Exported to {fname}")
        elif choice == "6":
            notifier.refresh()
            print("Deals refreshed.")
        elif choice == "7":
            print("Goodbye!")
            break
        else:
            print("Invalid choice.")

if __name__ == "__main__":
    main()
