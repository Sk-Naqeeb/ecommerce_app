import 'package:flutter/material.dart';

void main() => runApp(const SwiftCartApp());

class Product {
  final String name;
  final double price;

  Product(this.name, this.price);
}

class SwiftCartApp extends StatelessWidget {
  const SwiftCartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SwiftCart',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
      ),
      home: const LandingPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final List<Product> cart = [];
  final List<Product> wishlist = [];

  final List<String> baseCategories = [
    'Sneakers',
    'Smartwatch',
    'Sunglasses',
    'Headphones',
    'Backpack',
  ];

  final Map<String, List<Product>> baseProducts = {
    'Sneakers': List.generate(10, (i) => Product('Sneaker ${i + 1}', 49.99 + i)),
    'Smartwatch': List.generate(5, (i) => Product('Smartwatch ${i + 1}', 99.99 + i * 10)),
    'Sunglasses': List.generate(4, (i) => Product('Sunglass ${i + 1}', 59.99 + i * 5)),
    'Headphones': List.generate(6, (i) => Product('Headphone ${i + 1}', 79.99 + i * 8)),
    'Backpack': List.generate(5, (i) => Product('Backpack ${i + 1}', 39.99 + i * 7)),
  };

  final Map<String, Map<String, List<Product>>> browseCategories = {
    'Electronics': {
      'Smartphones': List.generate(3, (i) => Product('Smartphone ${i + 1}', 699.99 + i * 50)),
      'TVs': List.generate(3, (i) => Product('TV ${i + 1}', 999.99 + i * 100)),
      'Laptops': List.generate(3, (i) => Product('Laptop ${i + 1}', 1099.99 + i * 150)),
    },
    'Fashion': {
      'T-Shirts': List.generate(3, (i) => Product('T-Shirt ${i + 1}', 19.99 + i * 5)),
      'Jeans': List.generate(3, (i) => Product('Jeans ${i + 1}', 49.99 + i * 10)),
    },
    'Cosmetics': {
      'Lipsticks': List.generate(2, (i) => Product('Lipstick ${i + 1}', 14.99 + i * 2)),
      'Perfumes': List.generate(2, (i) => Product('Perfume ${i + 1}', 29.99 + i * 5)),
    },
    'Home Appliances': {
      'Microwave Ovens': List.generate(2, (i) => Product('Microwave Oven ${i + 1}', 299.99 + i * 50)),
      'Vacuum Cleaners': List.generate(2, (i) => Product('Vacuum Cleaner ${i + 1}', 199.99 + i * 30)),
    },
  };

  void openProductList(String title, List<Product> items) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductListPage(
          category: title,
          products: items,
          cart: cart,
          wishlist: wishlist,
        ),
      ),
    );
  }

  void openSubcategory(String mainCategory, Map<String, List<Product>> subcategories) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SubcategoryPage(
          category: mainCategory,
          subcategories: subcategories,
          cart: cart,
          wishlist: wishlist,
        ),
      ),
    );
  }

  void openCart() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CartPage(cart: cart),
      ),
    );
  }

  void openWishlist() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => WishlistPage(wishlist: wishlist),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SwiftCart', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: const Icon(Icons.favorite_border), onPressed: openWishlist),
          IconButton(icon: const Icon(Icons.shopping_cart_outlined), onPressed: openCart),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text("Shop by Category", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.2,
              physics: const NeverScrollableScrollPhysics(),
              children: baseCategories.map((name) {
                return GestureDetector(
                  onTap: () => openProductList(name, baseProducts[name]!),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      const Icon(Icons.shopping_bag_outlined, size: 40, color: Colors.blueAccent),
                      const SizedBox(height: 10),
                      Text(name, textAlign: TextAlign.center),
                    ]),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
            const Text("Browse by Category", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Column(
              children: browseCategories.entries.map((entry) {
                return ListTile(
                  title: Text(entry.key),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => openSubcategory(entry.key, entry.value),
                );
              }).toList(),
            ),
          ]),
        ),
      ),
    );
  }
}

class SubcategoryPage extends StatelessWidget {
  final String category;
  final Map<String, List<Product>> subcategories;
  final List<Product> cart;
  final List<Product> wishlist;

  const SubcategoryPage({super.key, required this.category, required this.subcategories, required this.cart, required this.wishlist});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(category)),
      body: ListView(
        children: subcategories.entries.map((entry) {
          return ListTile(
            title: Text(entry.key),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProductListPage(
                    category: entry.key,
                    products: entry.value,
                    cart: cart,
                    wishlist: wishlist,
                  ),
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}

class ProductListPage extends StatelessWidget {
  final String category;
  final List<Product> products;
  final List<Product> cart;
  final List<Product> wishlist;

  const ProductListPage({super.key, required this.category, required this.products, required this.cart, required this.wishlist});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(category)),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: products.length,
        itemBuilder: (_, index) {
          final product = products[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              title: Text(product.name),
              subtitle: Text("\$${product.price.toStringAsFixed(2)}"),
              trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                IconButton(
                  icon: const Icon(Icons.favorite_border),
                  onPressed: () {
                    if (!wishlist.contains(product)) wishlist.add(product);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${product.name} added to wishlist')));
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.add_shopping_cart),
                  onPressed: () {
                    cart.add(product);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${product.name} added to cart')));
                  },
                ),
              ]),
            ),
          );
        },
      ),
    );
  }
}

class CartPage extends StatelessWidget {
  final List<Product> cart;

  const CartPage({super.key, required this.cart});

  @override
  Widget build(BuildContext context) {
    double total = cart.fold(0, (sum, p) => sum + p.price);

    return Scaffold(
      appBar: AppBar(title: const Text("Cart")),
      body: cart.isEmpty
          ? const Center(child: Text("Your cart is empty."))
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cart.length,
              itemBuilder: (_, index) {
                final product = cart[index];
                return ListTile(
                  title: Text(product.name),
                  subtitle: Text("\$${product.price.toStringAsFixed(2)}"),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      cart.removeAt(index);
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (_) => CartPage(cart: cart)));
                    },
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text("Total: \$${total.toStringAsFixed(2)}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                ElevatedButton(onPressed: () {}, child: const Text("Buy Now")),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class WishlistPage extends StatelessWidget {
  final List<Product> wishlist;

  const WishlistPage({super.key, required this.wishlist});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Wishlist")),
      body: wishlist.isEmpty
          ? const Center(child: Text("Your wishlist is empty."))
          : ListView.builder(
        itemCount: wishlist.length,
        itemBuilder: (_, index) {
          final product = wishlist[index];
          return ListTile(
            title: Text(product.name),
            subtitle: Text("\$${product.price.toStringAsFixed(2)}"),
          );
        },
      ),
    );
  }
}
