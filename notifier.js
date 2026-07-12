// notifier.js
const fs = require('fs');
const readline = require('readline');

const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout
});

class Notifier {
    constructor() {
        this.deals = [];
        this.categories = ['electronics', 'clothing', 'books', 'home', 'toys'];
        this.generateMockDeals();
    }

    generateMockDeals() {
        const products = [
            { name: 'Wireless Headphones', price: 49.99, discount: 20, category: 'electronics' },
            { name: "Men's Jacket", price: 89.99, discount: 30, category: 'clothing' },
            { name: 'Programming Book', price: 29.99, discount: 15, category: 'books' },
            { name: 'Smart Watch', price: 199.99, discount: 25, category: 'electronics' },
            { name: 'Running Shoes', price: 69.99, discount: 10, category: 'clothing' },
            { name: 'Board Game', price: 39.99, discount: 5, category: 'toys' },
            { name: 'Coffee Machine', price: 129.99, discount: 40, category: 'home' },
            { name: 'Drone', price: 299.99, discount: 50, category: 'electronics' },
            { name: 'Jeans', price: 49.99, discount: 20, category: 'clothing' },
            { name: 'Cookbook', price: 19.99, discount: 10, category: 'books' },
            { name: 'Robot Vacuum', price: 249.99, discount: 35, category: 'home' },
            { name: 'LEGO Set', price: 59.99, discount: 15, category: 'toys' }
        ];
        this.deals = products.map(p => ({ ...p, link: '' }));
    }

    refresh() {
        this.generateMockDeals();
    }

    filterByCategory(category) {
        return this.deals.filter(d => d.category.toLowerCase() === category.toLowerCase());
    }

    searchByKeyword(keyword) {
        const kw = keyword.toLowerCase();
        return this.deals.filter(d => d.name.toLowerCase().includes(kw));
    }

    exportJSON(filename) {
        try {
            fs.writeFileSync(filename, JSON.stringify(this.deals, null, 2));
            return true;
        } catch (e) {
            console.error('Export failed:', e.message);
            return false;
        }
    }

    exportCSV(filename) {
        try {
            const lines = ['Name,Price,Discount%,Category,Link'];
            this.deals.forEach(d => {
                lines.push(`"${d.name}",${d.price},${d.discount},"${d.category}","${d.link}"`);
            });
            fs.writeFileSync(filename, lines.join('\n'));
            return true;
        } catch (e) {
            console.error('Export failed:', e.message);
            return false;
        }
    }

    displayDeals(deals, limit = 20) {
        if (!deals) deals = this.deals;
        if (!deals.length) {
            console.log('No deals available.');
            return;
        }
        console.log(`\n📦 Deals (${deals.length} total):`);
        console.log('-'.repeat(60));
        deals.slice(0, limit).forEach((d, i) => {
            console.log(`[${i+1}] 🔥 ${d.name} – $${d.price.toFixed(2)} (-${d.discount}%) [${d.category}]`);
        });
        if (deals.length > limit) {
            console.log(`... and ${deals.length - limit} more`);
        }
    }
}

function ask(question) {
    return new Promise(resolve => rl.question(question, resolve));
}

async function main() {
    const notifier = new Notifier();
    console.log('=== Discount Notifier ===');
    while (true) {
        console.log('\n1. Show all deals');
        console.log('2. Filter by category');
        console.log('3. Search by keyword');
        console.log('4. Export to JSON');
        console.log('5. Export to CSV');
        console.log('6. Refresh deals');
        console.log('7. Exit');
        const choice = await ask('Choose: ');
        switch (choice.trim()) {
            case '1':
                notifier.displayDeals();
                break;
            case '2': {
                const cat = await ask('Enter category (electronics, clothing, books, home, toys): ');
                if (cat.trim()) {
                    const filtered = notifier.filterByCategory(cat.trim());
                    notifier.displayDeals(filtered);
                } else {
                    console.log('No category entered.');
                }
                break;
            }
            case '3': {
                const kw = await ask('Enter keyword: ');
                if (kw.trim()) {
                    const found = notifier.searchByKeyword(kw.trim());
                    notifier.displayDeals(found);
                } else {
                    console.log('No keyword entered.');
                }
                break;
            }
            case '4': {
                let fname = await ask('Filename (default: deals.json): ');
                fname = fname.trim() || 'deals.json';
                if (notifier.exportJSON(fname)) {
                    console.log(`Exported to ${fname}`);
                }
                break;
            }
            case '5': {
                let fname = await ask('Filename (default: deals.csv): ');
                fname = fname.trim() || 'deals.csv';
                if (notifier.exportCSV(fname)) {
                    console.log(`Exported to ${fname}`);
                }
                break;
            }
            case '6':
                notifier.refresh();
                console.log('Deals refreshed.');
                break;
            case '7':
                console.log('Goodbye!');
                rl.close();
                return;
            default:
                console.log('Invalid choice.');
        }
    }
}

main().catch(console.error);
