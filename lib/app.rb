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
    t = Time.now();
    t.strftime("The date is %m/%d/%y")
    print_line_separator;
    puts "Today's date #{t}";
    print_line_separator;
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

def get_average_price(prices)
    return prices.inject(:+) / prices.size;
end

def print_sales_prices(sales,prices)

    # Calcalate and print the total amount of sales
    puts "*The total amount of sales are #{sales}";
    # Calculate and print the average price the toy sold for
    if (!prices.nil?)
      puts "*Average Price $#{get_average_price(prices)}" ;
    else
      puts "purchases prices are not present in the json file";
    end

end

def get_discounts(discounts,purchase_price,toy_full_price)

    discount = ((purchase_price / toy_full_price)) * 100;
    discountPerc = 100 - discount;
    discounts.push(discountPerc);

end

def print_discounts(discounts)
     # Calculate and print the average discount based off the average sales price
    avg_discount = discounts.inject(:+).to_f / discounts.size;
    avg_discount = avg_discount
    puts "*Average Discounts %#{avg_discount.round(2)}" ;
end

def print_purchase_information(sales,prices,discounts)

    print_sales_prices(sales,prices)
    print_discounts(discounts)
    

end

def process_purchase_information(toy)
    sales = 0;
    prices = [];
    discounts = [];
    toy["purchases"].each do |purchase|
      
      if (!purchase["price"].nil?)
        sales = sales + purchase["price"];
        prices.push(purchase["price"]);     
        get_discounts(discounts,purchase["price"].to_f,
          toy["full-price"].to_f);
      end
    end

    print_purchase_information(sales,prices,discounts)
    
end

def print_toy_main_infomation(toy)
    puts "*Toy's name #{toy["title"]}";
    # Print the retail price of the toy
    puts "*Retail price of toy: $#{toy["full-price"]}";
    # Calculate and print the total number of purchases
    puts "*Total purchases for the toy #{toy["title"]} are #{toy["purchases"].size}";
end


def print_report(toy)
    print_toy_main_infomation(toy)
    process_purchase_information(toy)
end

def create_products_report
    $products_hash["items"].each do |toy|
      print_line_separator
      print_report(toy)
      # I get all the Brands Names from the Products Data Structure
      # to filter below and create a new data Structure from it
      $brands.push(toy["brand"]);
    end
    print_line_separator
end

def print_brands_header
    puts " _                         _     "
    puts "| |                       | |    "
    puts "| |__  _ __ __ _ _ __   __| |___ "
    puts "| '_ \\| '__/ _` | '_ \\ / _` / __|"
    puts "| |_) | | | (_| | | | | (_| \\__ \\"
    puts "|_.__/|_|  \\__,_|_| |_|\\__,_|___/"
    puts
end

def print_brand_information(name,actualStock,prices,totalSalesVolume)
    # Print the name of the brand
    puts "*Toy's Brand Name #{name}";
    # Print the number of the brand's toys we stock
    puts "*Toy's Brand Stock #{actualStock}";
    # Calculate and print the average price the toy sold for
    puts "*Average Price for the Brand #{name} - $#{get_average_price(prices).round(3)}" ;
    # Calculate and print the total sales volume of all the brand's toys combined
    puts "*The total sales volume of all toys for the brand #{name} is: $ #{totalSalesVolume.inject(:+).round(2)}" ;
end

def process_brands_information(brandStructure)
    prices = [];
    sales = [];
    totalSalesVolume = [];
  
    #Setup an stock counter in order to count the stock for the brands
    actualStock = 0;
    brandStructure.each do |brand|
      # Count the number of the brand's toys we stock
      actualStock = actualStock + brand["stock"]
      # Added the full price to the prices array in order to
      # get the average bellow
      prices.push(brand["full-price"].to_f);
      #Calculate the total sales for this brand
      brand["purchases"].each{ |p| totalSalesVolume.push(p["price"]) }
    end

    print_brand_information(brandStructure[0]["brand"],
      actualStock,prices,totalSalesVolume)
    
end
def create_brands_report

    brandStructure = [];
    repeatedBrandNameArray = [];
    $brands.each do |brandName|
      #checked if we repeated a brandName by see if the brandName String
      # Inside the repeatedBrandNameArray
      if !(repeatedBrandNameArray.include? brandName)
        print_line_separator;
        #I select all the Brands from the Products Data Structure
        brandStructure = $products_hash["items"].select {|item| item["brand"] == brandName}
        if (brandStructure.size > 0)
          process_brands_information(brandStructure);
        end
      end
      #added the brand name in the repeatedBrandNameArray to check,in the next iteration,
      #if the brandName exist
      repeatedBrandNameArray.push(brandName)
    end
    print_line_separator

end

def create_report
  $brands = [];
  print_date_time;
  print_products_header;
  create_products_report;
  print_brands_header;
  create_brands_report;

end

def start
  setup_files # load, read, parse, and create the files
  create_report # create the report!
end

start # call start method to trigger report generation