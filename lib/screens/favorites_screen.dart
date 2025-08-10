// ignore_for_file: prefer_const_constructors, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/favorites_provider.dart';
import '../widgets/restaurant_card.dart';
import '../widgets/product_card.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          localizations.favorites,
          style: GoogleFonts.cairo(
            color: Theme.of(context).appBarTheme.foregroundColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Theme.of(context).appBarTheme.foregroundColor,
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              child: Text(
                'مفضلات المتاجر',
                style: GoogleFonts.cairo(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Tab(
              child: Text(
                'مفضلات الوجبات',
                style: GoogleFonts.cairo(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
          labelColor: Theme.of(context).primaryColor,
          unselectedLabelColor: Theme.of(context).textTheme.bodyMedium?.color,
          indicatorColor: Theme.of(context).primaryColor,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // تبويب مفضلات المطاعم
          Consumer<FavoritesProvider>(
            builder: (context, favoritesProvider, child) {
              final favoriteRestaurants = favoritesProvider.favoriteRestaurants;
              
              if (favoriteRestaurants.isEmpty) {
                return _buildEmptyState(localizations, 'لا توجد مطاعم مفضلة');
              }
              
              return GridView.builder(
                padding: const EdgeInsets.all(16.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: favoriteRestaurants.length,
                itemBuilder: (context, index) {
                  final restaurant = favoriteRestaurants[index];
                  return RestaurantCard(restaurant: restaurant);
                },
              );
            },
          ),
          
          // تبويب مفضلات الوجبات
          Consumer<FavoritesProvider>(
            builder: (context, favoritesProvider, child) {
              final favoriteProducts = favoritesProvider.favoriteProducts;
              
              if (favoriteProducts.isEmpty) {
                return _buildEmptyState(localizations, 'لا توجد وجبات مفضلة');
              }
              
              return ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: favoriteProducts.length,
                itemBuilder: (context, index) {
                  final product = favoriteProducts[index];
                  return _buildMealCard(context, product, favoritesProvider);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMealCard(BuildContext context, dynamic product, FavoritesProvider favoritesProvider) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Theme.of(context).cardColor,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // صورة الوجبة
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                product.image ?? 'https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?ixlib=rb-4.0.3',
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey[300],
                    child: const Icon(Icons.fastfood),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            // تفاصيل الوجبة
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name ?? 'وجبة',
                    style: GoogleFonts.cairo(
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.description ?? 'وصف الوجبة',
                    style: GoogleFonts.cairo(
                      color: Theme.of(context).textTheme.bodySmall?.color,
                      fontSize: 12,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Spacer(),
                      Text(
                        '${product.price ?? 0} ر.س',
                        style: GoogleFonts.cairo(
                          color: Theme.of(context).primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // أزرار الإجراءات
            Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.favorite, color: Colors.red),
                  onPressed: () {
                    favoritesProvider.removeFromFavorites(product.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'تم إزالة ${product.name} من المفضلة',
                          style: GoogleFonts.cairo(),
                        ),
                        backgroundColor: Colors.orange,
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.add_shopping_cart,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  onPressed: () {
                    // إضافة للسلة
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'تم إضافة ${product.name} إلى السلة',
                          style: GoogleFonts.cairo(),
                        ),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(AppLocalizations localizations, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 80,
            color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: GoogleFonts.cairo(
              color: Theme.of(context).textTheme.bodyLarge?.color,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'ابدأ بإضافة العناصر المفضلة لديك',
            style: GoogleFonts.cairo(
              color: Theme.of(context).textTheme.bodyMedium?.color,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'تصفح المطاعم',
              style: GoogleFonts.cairo(),
            ),
          ),
        ],
      ),
    );
  }
}
