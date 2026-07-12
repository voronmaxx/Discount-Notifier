// Notifier.cs
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text.Json;
using System.Text.Json.Serialization;

class Deal
{
    public string Name { get; set; }
    public double Price { get; set; }
    public int Discount { get; set; }
    public string Category { get; set; }
    public string Link { get; set; }
}

class Notifier
{
    private List<Deal> deals = new List<Deal>();
    private readonly string[] categories = { "electronics", "clothing", "books", "home", "toys" };

    public Notifier()
    {
        GenerateMockDeals();
    }

    private void GenerateMockDeals()
    {
        var products = new (string name, double price, int discount, string category)[]
        {
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
        };
        deals = products.Select(p => new Deal { Name = p.name, Price = p.price, Discount = p.discount, Category = p.category, Link = "" }).ToList();
    }

    public void Refresh() => GenerateMockDeals();

    public List<Deal> FilterByCategory(string category)
    {
        return deals.Where(d => d.Category.Equals(category, StringComparison.OrdinalIgnoreCase)).ToList();
    }

    public List<Deal> SearchByKeyword(string keyword)
    {
        return deals.Where(d => d.Name.Contains(keyword, StringComparison.OrdinalIgnoreCase)).ToList();
    }

    public bool ExportJSON(string filename)
    {
        try
        {
            var options = new JsonSerializerOptions { WriteIndented = true };
            string json = JsonSerializer.Serialize(deals, options);
            File.WriteAllText(filename, json);
            return true;
        }
        catch (Exception e)
        {
            Console.WriteLine($"Export failed: {e.Message}");
            return false;
        }
    }

    public bool ExportCSV(string filename)
    {
        try
        {
            using var writer = new StreamWriter(filename);
            writer.WriteLine("Name,Price,Discount%,Category,Link");
            foreach (var d in deals)
            {
                writer.WriteLine($"\"{d.Name}\",{d.Price},{d.Discount},\"{d.Category}\",\"{d.Link}\"");
            }
            return true;
        }
        catch (Exception e)
        {
            Console.WriteLine($"Export failed: {e.Message}");
            return false;
        }
    }

    public void DisplayDeals(List<Deal> deals = null, int limit = 20)
    {
        if (deals == null) deals = this.deals;
        if (deals.Count == 0)
        {
            Console.WriteLine("No deals available.");
            return;
        }
        Console.WriteLine($"\n📦 Deals ({deals.Count} total):");
        Console.WriteLine(new string('-', 60));
        for (int i = 0; i < Math.Min(deals.Count, limit); i++)
        {
            var d = deals[i];
            Console.WriteLine($"[{i+1}] 🔥 {d.Name} – ${d.Price:F2} (-{d.Discount}%) [{d.Category}]");
        }
        if (deals.Count > limit)
            Console.WriteLine($"... and {deals.Count - limit} more");
    }

    static void Main()
    {
        var notifier = new Notifier();
        Console.WriteLine("=== Discount Notifier ===");
        while (true)
        {
            Console.WriteLine("\n1. Show all deals");
            Console.WriteLine("2. Filter by category");
            Console.WriteLine("3. Search by keyword");
            Console.WriteLine("4. Export to JSON");
            Console.WriteLine("5. Export to CSV");
            Console.WriteLine("6. Refresh deals");
            Console.WriteLine("7. Exit");
            Console.Write("Choose: ");
            string choice = Console.ReadLine()?.Trim() ?? "";
            switch (choice)
            {
                case "1":
                    notifier.DisplayDeals();
                    break;
                case "2":
                    Console.Write("Enter category (electronics, clothing, books, home, toys): ");
                    string cat = Console.ReadLine()?.Trim() ?? "";
                    if (!string.IsNullOrEmpty(cat))
                    {
                        var filtered = notifier.FilterByCategory(cat);
                        notifier.DisplayDeals(filtered);
                    }
                    else
                    {
                        Console.WriteLine("No category entered.");
                    }
                    break;
                case "3":
                    Console.Write("Enter keyword: ");
                    string kw = Console.ReadLine()?.Trim() ?? "";
                    if (!string.IsNullOrEmpty(kw))
                    {
                        var found = notifier.SearchByKeyword(kw);
                        notifier.DisplayDeals(found);
                    }
                    else
                    {
                        Console.WriteLine("No keyword entered.");
                    }
                    break;
                case "4":
                    Console.Write("Filename (default: deals.json): ");
                    string fname = Console.ReadLine()?.Trim() ?? "deals.json";
                    if (string.IsNullOrEmpty(fname)) fname = "deals.json";
                    if (notifier.ExportJSON(fname))
                        Console.WriteLine($"Exported to {fname}");
                    break;
                case "5":
                    Console.Write("Filename (default: deals.csv): ");
                    fname = Console.ReadLine()?.Trim() ?? "deals.csv";
                    if (string.IsNullOrEmpty(fname)) fname = "deals.csv";
                    if (notifier.ExportCSV(fname))
                        Console.WriteLine($"Exported to {fname}");
                    break;
                case "6":
                    notifier.Refresh();
                    Console.WriteLine("Deals refreshed.");
                    break;
                case "7":
                    Console.WriteLine("Goodbye!");
                    return;
                default:
                    Console.WriteLine("Invalid choice.");
                    break;
            }
        }
    }
}
