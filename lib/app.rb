require 'json'
# Print "Sales Report" in ascii art

# Print today's date

# Print "Products" in ascii art

# For each product in the data set:
	# Print the name of the toy
	# Print the retail price of the toy
	# Calculate and print the total number of purchases
  # Calcalate and print the total amount of sales
  # Calculate and print the average price the toy sold for
  # Calculate and print the average discount based off the average sales price

# Print "Brands" in ascii art

# For each brand in the data set:
	# Print the name of the brand
	# Count and print the number of the brand's toys we stock
	# Calculate and print the average price of the brand's toys
	# Calculate and print the total sales volume of all the brand's toys combined
# Get path to products.json, read the file into a string,
# and transform the string into a usable hash
def setup_files
    path = File.join(File.dirname(__FILE__), '../data/products.json')
    file = File.read(path)
    $products_hash = JSON.parse(file)
    $report_file = File.new("report.txt", "w+")
end

def print_line_separator
    puts '-' * 20
end

def print_date_time
    # Print today's date
    t = Time.now()
    t.strftime("The date is %m/%d/%y")
    print_line_separator
    puts "Today's date #{t}";
    print_line_separator
end

def print_products_header
    puts "                     _            _       "
    puts "                    | |          | |      "
    puts " _ __  _ __ ___   __| |_   _  ___| |_ ___ "
    puts "| '_ \\| '__/ _ \\ / _` | | | |/ __| __/ __|"
    puts "| |_) | | | (_) | (_| | |_| | (__| |_\\__ \\"
    puts "| .__/|_|  \\___/ \\__,_|\\__,_|\\___|\\__|___/"
    puts "| |                                       "
    puts "|_|                                       "
end

def prepare_purchase_information(toy)
    toy["purchases"].each do |purchase|
      sales = sales + purchase["price"];
      prices.push(purchase["price"]);
      discount= ((purchase["price"].to_f/toy["full-price"].to_f))*100 ;
      discountPerc = 100 - discount
    

      discounts.push(discountPerc);
    end

end

def print_toy_main_infomation(toy)
    puts "*Toy's name #{toy["title"]}";
    # Print the retail price of the toy
    puts "*Retail price of toy: $#{toy["full-price"]}";
    # Calculate and print the total number of purchases
    puts "*Total purchases for the toy #{toy["title"]} are #{toy["purchases"].size}";
end


def print_report(toy)
    prices = [];
    discounts = [];
    sales = 0;
    total_sales = total_sales + toy["purchases"].size;
    print_toy_main_infomation(toy)
    prepare_purchase_information(toy)

end

def create_products_report
    products_hash["items"].each do |toy|
      print_line_separator
      print_report(toy)
      print_line_separator
    end
end

def create_report
  print_date_time;
  print_products_header;
  create_products_report;


end

def start
  setup_files # load, read, parse, and create the files
  create_report # create the report!
end

start # call start method to trigger report generation