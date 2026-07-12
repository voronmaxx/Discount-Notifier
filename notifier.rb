# notifier.rb
require 'json'
require 'csv'

class Notifier
  def initialize
    @deals = []
    @categories = ['electronics', 'clothing', 'books', 'home', 'toys']
    generate_mock_deals
  end

  def generate_mock_deals
    products = [
      ['Wireless Headphones', 49.99, 20, 'electronics'],
      ["Men's Jacket", 89.99, 30, 'clothing'],
      ['Programming Book', 29.99, 15, 'books'],
      ['Smart Watch', 199.99, 25, 'electronics'],
      ['Running Shoes', 69.99, 10, 'clothing'],
      ['Board Game', 39.99, 5, 'toys'],
      ['Coffee Machine', 129.99, 40, 'home'],
      ['Drone', 299.99, 50, 'electronics'],
      ['Jeans', 49.99, 20, 'clothing'],
      ['Cookbook', 19.99, 10, 'books'],
      ['Robot Vacuum', 249.99, 35, 'home'],
      ['LEGO Set', 59.99, 15, 'toys']
    ]
    @deals = products.map { |name, price, discount, cat|
      { name: name, price: price, discount: discount, category: cat, link: '' }
    }
  end

  def refresh
    generate_mock_deals
  end

  def filter_by_category(category)
    @deals.select { |d| d[:category].downcase == category.downcase }
  end

  def search_by_keyword(keyword)
    kw = keyword.downcase
    @deals.select { |d| d[:name].downcase.include?(kw) }
  end

  def export_json(filename = 'deals.json')
    File.write(filename, JSON.pretty_generate(@deals))
    true
  rescue => e
    puts "Export failed: #{e.message}"
    false
  end

  def export_csv(filename = 'deals.csv')
    CSV.open(filename, 'w') do |csv|
      csv << ['Name', 'Price', 'Discount%', 'Category', 'Link']
      @deals.each do |d|
        csv << [d[:name], d[:price], d[:discount], d[:category], d[:link]]
      end
    end
    true
  rescue => e
    puts "Export failed: #{e.message}"
    false
  end

  def display_deals(deals = nil, limit = 20)
    deals ||= @deals
    if deals.empty?
      puts 'No deals available.'
      return
    end
    puts "\n📦 Deals (#{deals.size} total):"
    puts '-' * 60
    deals.first(limit).each_with_index do |d, i|
      puts "[#{i+1}] 🔥 #{d[:name]} – $#{'%.2f' % d[:price]} (-#{d[:discount]}%) [#{d[:category]}]"
    end
    if deals.size > limit
      puts "... and #{deals.size - limit} more"
    end
  end
end

def main
  notifier = Notifier.new
  puts "=== Discount Notifier ==="
  loop do
    puts "\n1. Show all deals"
    puts "2. Filter by category"
    puts "3. Search by keyword"
    puts "4. Export to JSON"
    puts "5. Export to CSV"
    puts "6. Refresh deals"
    puts "7. Exit"
    print "Choose: "
    choice = gets.chomp.strip
    case choice
    when '1'
      notifier.display_deals
    when '2'
      print "Enter category (electronics, clothing, books, home, toys): "
      cat = gets.chomp.strip
      if !cat.empty?
        filtered = notifier.filter_by_category(cat)
        notifier.display_deals(filtered)
      else
        puts "No category entered."
      end
    when '3'
      print "Enter keyword: "
      kw = gets.chomp.strip
      if !kw.empty?
        found = notifier.search_by_keyword(kw)
        notifier.display_deals(found)
      else
        puts "No keyword entered."
      end
    when '4'
      print "Filename (default: deals.json): "
      fname = gets.chomp.strip
      fname = 'deals.json' if fname.empty?
      if notifier.export_json(fname)
        puts "Exported to #{fname}"
      end
    when '5'
      print "Filename (default: deals.csv): "
      fname = gets.chomp.strip
      fname = 'deals.csv' if fname.empty?
      if notifier.export_csv(fname)
        puts "Exported to #{fname}"
      end
    when '6'
      notifier.refresh
      puts "Deals refreshed."
    when '7'
      puts "Goodbye!"
      break
    else
      puts "Invalid choice."
    end
  end
end

main if __FILE__ == $0
