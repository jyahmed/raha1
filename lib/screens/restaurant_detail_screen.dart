import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/restaurant.dart';
import '../models/product.dart';
import '../providers/favorites_provider.dart';
import '../providers/cart_provider.dart';

class RestaurantDetailScreen extends StatefulWidget {
  final Restaurant restaurant;

  const RestaurantDetailScreen({super.key, required this.restaurant});

  @override
  State<RestaurantDetailScreen> createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen> {
  String selectedCategory = 'المفضلة';

  // بيانات وهمية للوجبات
  final List<Product> allProducts = [
    // المفضلة
    Product(
      id: 1,
      name: 'سلطة الدار اسبيشل',
      description: 'سلطة طازجة مع الخضار المتنوعة والصوص الخاص',
      price: 1700,
      image:
          'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?ixlib=rb-4.0.3',
      restaurantId: 1,
      categories: ['المفضلة', 'سلطات'],
      isFavorite: true,
    ),
    Product(
      id: 2,
      name: 'سلطة الدار عادي',
      description: 'سلطة كلاسيكية بالخضار الطازجة',
      price: 1400,
      image:
          'https://images.unsplash.com/photo-1540420773420-3366772f4999?ixlib=rb-4.0.3',
      restaurantId: 1,
      categories: ['المفضلة', 'سلطات'],
      isFavorite: true,
    ),
    Product(
      id: 3,
      name: 'حمص',
      description: 'حمص طازج مع زيت الزيتون والطحينة',
      price: 650,
      image:
          'https://images.unsplash.com/photo-1571197119282-7c4e2b8b8d4c?ixlib=rb-4.0.3',
      restaurantId: 1,
      categories: ['المفضلة', 'مقبلات'],
      isFavorite: true,
    ),
    Product(
      id: 4,
      name: 'متبل',
      description: 'متبل باذنجان مشوي مع الطحينة والثوم',
      price: 650,
      image:
          'https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?ixlib=rb-4.0.3',
      restaurantId: 1,
      categories: ['المفضلة', 'مقبلات'],
      isFavorite: true,
    ),
    Product(
      id: 5,
      name: 'سلطة عربي',
      description: 'سلطة عربية تقليدية بالخضار المقطعة',
      price: 400,
      image:
          'https://images.unsplash.com/photo-1505253213348-cd54c92b37ed?ixlib=rb-4.0.3',
      restaurantId: 1,
      categories: ['المفضلة', 'سلطات'],
      isFavorite: true,
    ),
    // قسم اللحوم
    Product(
      id: 6,
      name: 'كباب لحم',
      description: 'كباب لحم مشوي على الفحم',
      price: 2500,
      image:
          'https://images.unsplash.com/photo-1529692236671-f1f6cf9683ba?ixlib=rb-4.0.3',
      restaurantId: 1,
      categories: ['قسم اللحوم'],
    ),
    Product(
      id: 7,
      name: 'شاورما لحم',
      description: 'شاورما لحم طازجة مع الخضار',
      price: 1800,
      image:
          'https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?ixlib=rb-4.0.3',
      restaurantId: 1,
      categories: ['قسم اللحوم'],
    ),
  ];

  List<String> get categories {
    Set<String> categorySet = {'المفضلة'};
    for (var product in allProducts) {
      categorySet.addAll(product.categories);
    }
    categorySet.remove('المفضلة');
    return ['المفضلة', ...categorySet.toList()];
  }

  List<Product> get filteredProducts {
    if (selectedCategory == 'المفضلة') {
      return allProducts.where((product) => product.isFavorite).toList();
    }
    return allProducts
        .where((product) => product.categories.contains(selectedCategory))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FA),
      body: CustomScrollView(
        slivers: [
          // App Bar مع صورة المطعم
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                widget.restaurant.image,
                fit: BoxFit.cover,
              ),
            ),
          ),

          // معلومات المطعم
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        widget.restaurant.name,
                        style: GoogleFonts.cairo(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      const Spacer(),
                      // تقييم المطعم
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 20,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${widget.restaurant.rating}',
                            style: GoogleFonts.cairo(
                              color: isDark ? Colors.white : Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            ' (${widget.restaurant.reviews})',
                            style: GoogleFonts.cairo(
                              color: isDark ? Colors.white70 : Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'الأسعار مطابقة للمطعم',
                    style: GoogleFonts.cairo(
                      color: isDark ? Colors.white70 : Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF2A2A2A)
                          : const Color(0xFFF0F0F0),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          color: Colors.blueAccent,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'الطلب يستغرق ${widget.restaurant.deliveryTime} دقيقة',
                          style: GoogleFonts.cairo(
                            color: isDark ? Colors.white : Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: widget.restaurant.isOpen
                                ? Colors.green
                                : Colors.red,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            widget.restaurant.isOpen ? 'مفتوح' : 'مغلق',
                            style: GoogleFonts.cairo(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // أقسام الوجبات - التبويبات
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'الأقسام',
                    style: GoogleFonts.cairo(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 50,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        final isSelected = selectedCategory == category;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedCategory = category;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(left: 8),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFFFFC72C)
                                  : (isDark
                                      ? const Color(0xFF1E1E1E)
                                      : Colors.white),
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFFFFC72C)
                                    : (isDark
                                        ? const Color(0xFF333333)
                                        : Colors.grey[300]!),
                                width: 1,
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: const Color(0xFFFFC72C)
                                            .withOpacity(0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ]
                                  : [],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _getCategoryIcon(category, isSelected, isDark),
                                const SizedBox(width: 8),
                                Text(
                                  category,
                                  style: GoogleFonts.cairo(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: isSelected
                                        ? const Color(0xFF153A6B)
                                        : (isDark
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // قائمة الوجبات
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final product = filteredProducts[index];
                  return _buildProductCard(product, isDark);
                },
                childCount: filteredProducts.length,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Consumer<CartProvider>(
        builder: (context, cart, child) {
          if (cart.itemCount == 0) return const SizedBox.shrink();
          return Consumer<CartProvider>(
            builder: (context, cart, child) {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: cart.itemCount > 0
                    ? FloatingActionButton.extended(
                        key: const ValueKey('visible-cart-button'),
                        onPressed: () {
                          Navigator.pushNamed(context, '/order_confirmation');
                        },
                        backgroundColor: const Color(0xFF153A6B),
                        icon: Stack(
                          children: [
                            const Icon(Icons.shopping_cart,
                                color: Colors.white),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 16,
                                  minHeight: 16,
                                ),
                                child: Text(
                                  cart.itemCount.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                        label: Text(
                          '${cart.totalAmount.toStringAsFixed(0)} ر.س',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : const SizedBox.shrink(
                        key: ValueKey('hidden-cart-button')),
              );
            },
          );
        },
      ),
    );
  }

  Widget _getCategoryIcon(String category, bool isSelected, bool isDark) {
    IconData iconData;
    switch (category) {
      case 'المفضلة':
        iconData = Icons.favorite;
        break;
      case 'قسم اللحوم':
        iconData = Icons.restaurant_menu;
        break;
      case 'سلطات':
        iconData = Icons.local_dining;
        break;
      case 'مقبلات':
        iconData = Icons.fastfood;
        break;
      default:
        iconData = Icons.restaurant;
    }

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isSelected
            ? const Color(0xFF153A6B).withOpacity(0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        iconData,
        color: isSelected
            ? const Color(0xFF153A6B)
            : (isDark ? const Color(0xFF7EE6F3) : Colors.grey[600]),
        size: 18,
      ),
    );
  }

  Widget _buildProductCard(Product product, bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // معلومات المنتج
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: GoogleFonts.cairo(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF153A6B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.description,
                    style: GoogleFonts.cairo(
                      fontSize: 12,
                      color: isDark ? Colors.white70 : Colors.grey[600],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${product.price.toStringAsFixed(0)} ر.س',
                    style: GoogleFonts.cairo(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? const Color(0xFF7EE6F3)
                          : const Color(0xFF153A6B),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // صورة المنتج وأزرار الكمية/المفضلة
            Column(
              children: [
                Consumer<FavoritesProvider>(
                  builder: (context, favorites, child) {
                    final isFavorite = favorites.isProductFavorite(product.id);
                    return IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite
                            ? Colors.red
                            : (isDark ? Colors.white54 : Colors.grey),
                        size: 20,
                      ),
                      onPressed: () {
                        if (isFavorite) {
                          favorites.removeProductFromFavorites(product.id);
                        } else {
                          favorites.addProductToFavorites(product);
                        }
                      },
                    );
                  },
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    product.image,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 80,
                        height: 80,
                        color: Colors.grey[200],
                        child: const Icon(Icons.restaurant, color: Colors.grey),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
                Consumer<CartProvider>(
                  builder: (context, cart, child) {
                    final quantity = cart.getQuantity(product.id);
                    if (quantity == 0) {
                      return ElevatedButton(
                        onPressed: () {
                          cart.addItem(product);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFC72C),
                          foregroundColor: const Color(0xFF153A6B),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          minimumSize: const Size(80, 36),
                        ),
                        child: Text(
                          'أضف للسلة',
                          style: GoogleFonts.cairo(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    } else {
                      return Container(
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF2A2A2A)
                              : const Color(0xFFF0F0F0),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove, size: 20),
                              onPressed: () {
                                cart.removeItem(product.id);
                              },
                              color: isDark ? Colors.white : Colors.black,
                            ),
                            Text(
                              '$quantity',
                              style: GoogleFonts.cairo(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : Colors.black,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add, size: 20),
                              onPressed: () {
                                cart.addItem(product);
                              },
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
