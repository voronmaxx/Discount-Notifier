// Notifier.java
import java.io.*;
import java.nio.file.*;
import java.util.*;
import java.util.stream.Collectors;
import com.google.gson.*;

class Deal {
    String name;
    double price;
    int discount;
    String category;
    String link;
}

public class Notifier {
    private List<Deal> deals = new ArrayList<>();
    private final String[] categories = {"electronics", "clothing", "books", "home", "toys"};
    private final Gson gson = new GsonBuilder().setPrettyPrinting().create();

    public Notifier() {
        generateMockDeals();
    }

    private void generateMockDeals() {
        String[][] products = {
            {"Wireless Headphones", "49.99", "20", "electronics"},
            {"Men's Jacket", "89.99", "30", "clothing"},
            {"Programming Book", "29.99", "15", "books"},
            {"Smart Watch", "199.99", "25", "electronics"},
            {"Running Shoes", "69.99", "10", "clothing"},
            {"Board Game", "39.99", "5", "toys"},
            {"Coffee Machine", "129.99", "40", "home"},
            {"Drone", "299.99", "50", "electronics"},
            {"Jeans", "49.99", "20", "clothing"},
            {"Cookbook", "19.99", "10", "books"},
            {"Robot Vacuum", "249.99", "35", "home"},
            {"LEGO Set", "59.99", "15", "toys"}
        };
        deals.clear();
        for (String[] p : products) {
            Deal d = new Deal();
            d.name = p[0];
            d.price = Double.parseDouble(p[1]);
            d.discount = Integer.parseInt(p[2]);
            d.category = p[3];
            d.link = "";
            deals.add(d);
        }
    }

    public void refresh() {
        generateMockDeals();
    }

    public List<Deal> filterByCategory(String category) {
        return deals.stream().filter(d -> d.category.equalsIgnoreCase(category)).collect(Collectors.toList());
    }

    public List<Deal> searchByKeyword(String keyword) {
        return deals.stream().filter(d -> d.name.toLowerCase().contains(keyword.toLowerCase())).collect(Collectors.toList());
    }

    public boolean exportJSON(String filename) {
        try {
            String json = gson.toJson(deals);
            Files.write(Paths.get(filename), json.getBytes());
            return true;
        } catch (Exception e) {
            System.out.println("Export failed: " + e.getMessage());
            return false;
        }
    }

    public boolean exportCSV(String filename) {
        try (PrintWriter pw = new PrintWriter(filename)) {
            pw.println("Name,Price,Discount%,Category,Link");
            for (Deal d : deals) {
                pw.printf("\"%s\",%.2f,%d,\"%s\",\"%s\"%n", d.name, d.price, d.discount, d.category, d.link);
            }
            return true;
        } catch (Exception e) {
            System.out.println("Export failed: " + e.getMessage());
            return false;
        }
    }

    public void displayDeals(List<Deal> deals, int limit) {
        if (deals == null) deals = this.deals;
        if (deals.isEmpty()) {
            System.out.println("No deals available.");
            return;
        }
        System.out.printf("%n📦 Deals (%d total):%n", deals.size());
        System.out.println(new String(new char[60]).replace('\0', '-'));
        int count = 0;
        for (Deal d : deals) {
            if (count >= limit) {
                System.out.printf("... and %d more%n", deals.size() - limit);
                break;
            }
            System.out.printf("[%d] 🔥 %s – $%.2f (-%d%%) [%s]%n", ++count, d.name, d.price, d.discount, d.category);
        }
    }

    public static void main(String[] args) throws IOException {
        Notifier notifier = new Notifier();
        BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
        System.out.println("=== Discount Notifier ===");
        while (true) {
            System.out.println("\n1. Show all deals");
            System.out.println("2. Filter by category");
            System.out.println("3. Search by keyword");
            System.out.println("4. Export to JSON");
            System.out.println("5. Export to CSV");
            System.out.println("6. Refresh deals");
            System.out.println("7. Exit");
            System.out.print("Choose: ");
            String choice = reader.readLine().trim();
            switch (choice) {
                case "1":
                    notifier.displayDeals(null, 20);
                    break;
                case "2":
                    System.out.print("Enter category (electronics, clothing, books, home, toys): ");
                    String cat = reader.readLine().trim();
                    if (!cat.isEmpty()) {
                        List<Deal> filtered = notifier.filterByCategory(cat);
                        notifier.displayDeals(filtered, 20);
                    } else {
                        System.out.println("No category entered.");
                    }
                    break;
                case "3":
                    System.out.print("Enter keyword: ");
                    String kw = reader.readLine().trim();
                    if (!kw.isEmpty()) {
                        List<Deal> found = notifier.searchByKeyword(kw);
                        notifier.displayDeals(found, 20);
                    } else {
                        System.out.println("No keyword entered.");
                    }
                    break;
                case "4":
                    System.out.print("Filename (default: deals.json): ");
                    String fname = reader.readLine().trim();
                    if (fname.isEmpty()) fname = "deals.json";
                    if (notifier.exportJSON(fname)) {
                        System.out.println("Exported to " + fname);
                    }
                    break;
                case "5":
                    System.out.print("Filename (default: deals.csv): ");
                    fname = reader.readLine().trim();
                    if (fname.isEmpty()) fname = "deals.csv";
                    if (notifier.exportCSV(fname)) {
                        System.out.println("Exported to " + fname);
                    }
                    break;
                case "6":
                    notifier.refresh();
                    System.out.println("Deals refreshed.");
                    break;
                case "7":
                    System.out.println("Goodbye!");
                    return;
                default:
                    System.out.println("Invalid choice.");
            }
        }
    }
}
