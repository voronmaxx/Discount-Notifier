// notifier.go
package main

import (
	"bufio"
	"encoding/csv"
	"encoding/json"
	"fmt"
	"os"
	"strconv"
	"strings"
)

type Deal struct {
	Name     string  `json:"name"`
	Price    float64 `json:"price"`
	Discount int     `json:"discount"`
	Category string  `json:"category"`
	Link     string  `json:"link"`
}

type Notifier struct {
	deals     []Deal
	categories []string
}

func NewNotifier() *Notifier {
	n := &Notifier{
		categories: []string{"electronics", "clothing", "books", "home", "toys"},
	}
	n.generateMockDeals()
	return n
}

func (n *Notifier) generateMockDeals() {
	products := []struct {
		name     string
		price    float64
		discount int
		category string
	}{
		{"Wireless Headphones", 49.99, 20, "electronics"},
		{"Men's Jacket", 89.99, 30, "clothing"},
		{"Programming Book", 29.99, 15, "books"},
		{"Smart Watch", 199.99, 25, "electronics"},
		{"Running Shoes", 69.99, 10, "clothing"},
		{"Board Game", 39.99, 5, "toys"},
		{"Coffee Machine", 129.99, 40, "home"},
		{"Drone", 299.99, 50, "electronics"},
		{"Jeans", 49.99, 20, "clothing"},
		{"Cookbook", 19.99, 10, "books"},
		{"Robot Vacuum", 249.99, 35, "home"},
		{"LEGO Set", 59.99, 15, "toys"},
	}
	n.deals = []Deal{}
	for _, p := range products {
		n.deals = append(n.deals, Deal{
			Name:     p.name,
			Price:    p.price,
			Discount: p.discount,
			Category: p.category,
			Link:     "",
		})
	}
}

func (n *Notifier) refresh() {
	n.generateMockDeals()
}

func (n *Notifier) filterByCategory(category string) []Deal {
	var result []Deal
	for _, d := range n.deals {
		if strings.EqualFold(d.Category, category) {
			result = append(result, d)
		}
	}
	return result
}

func (n *Notifier) searchByKeyword(keyword string) []Deal {
	var result []Deal
	kw := strings.ToLower(keyword)
	for _, d := range n.deals {
		if strings.Contains(strings.ToLower(d.Name), kw) {
			result = append(result, d)
		}
	}
	return result
}

func (n *Notifier) exportJSON(filename string) bool {
	data, err := json.MarshalIndent(n.deals, "", "  ")
	if err != nil {
		fmt.Println("Export failed:", err)
		return false
	}
	if err := os.WriteFile(filename, data, 0644); err != nil {
		fmt.Println("Write error:", err)
		return false
	}
	return true
}

func (n *Notifier) exportCSV(filename string) bool {
	file, err := os.Create(filename)
	if err != nil {
		fmt.Println("Create error:", err)
		return false
	}
	defer file.Close()
	writer := csv.NewWriter(file)
	defer writer.Flush()
	writer.Write([]string{"Name", "Price", "Discount%", "Category", "Link"})
	for _, d := range n.deals {
		writer.Write([]string{
			d.Name,
			strconv.FormatFloat(d.Price, 'f', 2, 64),
			strconv.Itoa(d.Discount),
			d.Category,
			d.Link,
		})
	}
	return true
}

func (n *Notifier) displayDeals(deals []Deal, limit int) {
	if deals == nil {
		deals = n.deals
	}
	if len(deals) == 0 {
		fmt.Println("No deals available.")
		return
	}
	fmt.Printf("\n📦 Deals (%d total):\n", len(deals))
	fmt.Println(strings.Repeat("-", 60))
	for i, d := range deals {
		if i >= limit {
			fmt.Printf("... and %d more\n", len(deals)-limit)
			break
		}
		fmt.Printf("[%d] 🔥 %s – $%.2f (-%d%%) [%s]\n", i+1, d.Name, d.Price, d.Discount, d.Category)
	}
}

func main() {
	notifier := NewNotifier()
	scanner := bufio.NewScanner(os.Stdin)
	fmt.Println("=== Discount Notifier ===")
	for {
		fmt.Println("\n1. Show all deals")
		fmt.Println("2. Filter by category")
		fmt.Println("3. Search by keyword")
		fmt.Println("4. Export to JSON")
		fmt.Println("5. Export to CSV")
		fmt.Println("6. Refresh deals")
		fmt.Println("7. Exit")
		fmt.Print("Choose: ")
		scanner.Scan()
		choice := strings.TrimSpace(scanner.Text())
		switch choice {
		case "1":
			notifier.displayDeals(nil, 20)
		case "2":
			fmt.Print("Enter category (electronics, clothing, books, home, toys): ")
			scanner.Scan()
			cat := strings.TrimSpace(scanner.Text())
			if cat != "" {
				filtered := notifier.filterByCategory(cat)
				notifier.displayDeals(filtered, 20)
			} else {
				fmt.Println("No category entered.")
			}
		case "3":
			fmt.Print("Enter keyword: ")
			scanner.Scan()
			kw := strings.TrimSpace(scanner.Text())
			if kw != "" {
				found := notifier.searchByKeyword(kw)
				notifier.displayDeals(found, 20)
			} else {
				fmt.Println("No keyword entered.")
			}
		case "4":
			fmt.Print("Filename (default: deals.json): ")
			scanner.Scan()
			fname := strings.TrimSpace(scanner.Text())
			if fname == "" {
				fname = "deals.json"
			}
			if notifier.exportJSON(fname) {
				fmt.Printf("Exported to %s\n", fname)
			}
		case "5":
			fmt.Print("Filename (default: deals.csv): ")
			scanner.Scan()
			fname := strings.TrimSpace(scanner.Text())
			if fname == "" {
				fname = "deals.csv"
			}
			if notifier.exportCSV(fname) {
				fmt.Printf("Exported to %s\n", fname)
			}
		case "6":
			notifier.refresh()
			fmt.Println("Deals refreshed.")
		case "7":
			fmt.Println("Goodbye!")
			return
		default:
			fmt.Println("Invalid choice.")
		}
	}
}
