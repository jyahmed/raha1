import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/restaurant_card.dart';
import '../widgets/category_selector.dart';
import '../widgets/cart_button.dart';

import '../widgets/search_bar_widget.dart';
import '../widgets/quick_actions.dart';
import '../models/restaurant.dart';
import '../l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  String searchQuery = '';
  int? selectedCategory;

  final List<Restaurant> dummyRestaurants = [
    Restaurant(
      id: 1,
      name: 'برجر كينج',
      image:
          'https://images.unsplash.com/photo-1571091718767-18b5b1457add?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTB8fGJ1cmdlcnxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=600&q=60',
      rating: 4.8,
      deliveryTime: '25-35 دقيقة',
      deliveryFee: '5 ر.س',
      categories: ['برجر', 'وجبات سريعة'],
      isNew: true,
    ),
    Restaurant(
      id: 2,
      name: 'الدار ',
      image:
          'https://images.unsplash.com/photo-1513104890138-7c749659a591?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8cGl6emF8ZW58MHx8MHx8&auto=format&fit=crop&w=600&q=60',
      rating: 4.5,
      deliveryTime: '20-30 دقيقة',
      deliveryFee: '8 ر.س',
      categories: ['بيتزا', 'إيطالي'],
      isFavorite: true,
    ),
    Restaurant(
      id: 3,
      name: 'كنتاكي',
      image:
          'https://images.unsplash.com/photo-1626082927389-6cd097cdc6ec?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8ZnJpZWQlMjBjaGlja2VufGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=600&q=60',
      rating: 4.2,
      deliveryTime: '30-40 دقيقة',
      deliveryFee: '7 ر.س',
      categories: ['دجاج', 'وجبات سريعة'],
    ),
    Restaurant(
      id: 4,
      name: 'الدار',
      image:
          'https://images.unsplash.com/photo-1509722747041-616f39b57569?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8c2FuZHdpY2h8ZW58MHx8MHx8&auto=format&fit=crop&w=600&q=60',
      rating: 4.0,
      deliveryTime: '15-25 دقيقة',
      deliveryFee: '4 ر.س',
      categories: ['سندويتشات', 'صحي'],
    ),
    Restaurant(
      id: 5,
      name: 'كافيه',
      image:
          'https://images.unsplash.com/photo-1504753793650-d4a2b783c15e?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8Y29mZmVlfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=600&q=60',
      rating: 4.7,
      deliveryTime: '10-20 دقيقة',
      deliveryFee: '9 ر.س',
      categories: ['قهوة', 'مشروبات'],
      isNew: true,
    ),
    Restaurant(
      id: 6,
      name: 'البيك',
      image:
          'https://images.unsplash.com/photo-1632778149955-e80f8ceca2e8?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTB8fGNoaWNrZW58ZW58MHx8MHx8&auto=format&fit=crop&w=600&q=60',
      rating: 4.9,
      deliveryTime: '25-40 دقيقة',
      deliveryFee: '6 ر.س',
      categories: ['دجاج', 'وجبات سريعة'],
      isFavorite: true,
    ),
  ];

  List<Restaurant> get filteredRestaurants {
    return dummyRestaurants.where((restaurant) {
      final matchesSearch = restaurant.name.contains(searchQuery);
      final matchesCategory = selectedCategory == null ||
          restaurant.categories
              .any((cat) => cat.contains(_getCategoryName(selectedCategory!)));
      return matchesSearch && matchesCategory;
    }).toList();
  }

  String _getCategoryName(int categoryId) {
    const categories = ['', 'برجر', 'بيتزا', 'دجاج', 'قهوة', 'حلويات', 'صحي'];
    return categoryId < categories.length ? categories[categoryId] : '';
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isTablet = MediaQuery.of(context).size.width >= 600;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: CustomScrollView(
            slivers: [
              // App Bar مخصص

              // المحتوى الرئيسي
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    // قسم البحث والإجراءات السريعة
                    Container(
                      color: Theme.of(context).primaryColor,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(24),
                            topRight: Radius.circular(24),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              // شريط البحث
                              SearchBarWidget(
                                controller: _searchController,
                                onChanged: (value) {
                                  setState(() {
                                    searchQuery = value;
                                  });
                                },
                              ),

                              const SizedBox(height: 24),

                              // قسم الإعلانات والعروض
                              _buildAdsSection(),

                              const SizedBox(height: 24),

                              // الإجراءات السريعة
                              const QuickActions(),

                              const SizedBox(height: 24),

                              // الفئات
                              CategorySelector(
                                selectedCategory: selectedCategory,
                                onSelectCategory: (category) {
                                  setState(() {
                                    selectedCategory = category;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // قسم المطاعم
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          // عنوان القسم
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton.icon(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16,
                                ),
                                label: Text(localizations.viewMore),
                                style: TextButton.styleFrom(
                                  foregroundColor:
                                      Theme.of(context).primaryColor,
                                ),
                              ),
                              Text(
                                localizations.restaurantsStores,
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // شبكة المطاعم
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: filteredRestaurants.isEmpty
                                ? _buildEmptyState(localizations)
                                : _buildRestaurantGrid(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: const CartButton(),
    );
  }

  Widget _buildAdsSection() {
    return SizedBox(
      // أضف SizedBox لتحديد ارتفاع ثابت
      height: 150,
      child: PageView.builder(
        padEnds: false, // يمنع الحشو الزائد عند الأطراف
        clipBehavior: Clip.hardEdge, // يمنع تجاوز المحتوى للحدود
        itemCount: 3,
        itemBuilder: (context, index) {
          return Padding(
            // أضف Padding لتجنب الالتصاق بالحواف
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Container(
              clipBehavior: Clip.antiAlias, // تأكد من اقتصاص الصورة داخل الحدود
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFFFFC72C).withOpacity(0.8),
                    const Color(0xFF153A6B).withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // صورة الخلفية
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      _getAdImage(index),
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xFFFFC72C),
                                const Color(0xFF153A6B),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  // محتوى الإعلان
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.3),
                          Colors.transparent,
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getAdTitle(index),
                          style: GoogleFonts.cairo(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _getAdSubtitle(index),
                          style: GoogleFonts.cairo(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _getAdImage(int index) {
    const images = [
      'https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?ixlib=rb-4.0.3',
      'https://images.unsplash.com/photo-1571091718767-18b5b1457add?ixlib=rb-4.0.3',
      'https://images.unsplash.com/photo-1513104890138-7c749659a591?ixlib=rb-4.0.3',
    ];
    return images[index % images.length];
  }

  String _getAdTitle(int index) {
    const titles = [
      'خصم 30% على جميع الوجبات',
      'توصيل مجاني للطلبات فوق 50 ر.س',
      'عروض خاصة على البيتزا',
    ];
    return titles[index % titles.length];
  }

  String _getAdSubtitle(int index) {
    const subtitles = [
      'لفترة محدودة فقط',
      'اطلب الآن واستمتع بالتوصيل المجاني',
      'أفضل النكهات بأسعار مميزة',
    ];
    return subtitles[index % subtitles.length];
  }

  Widget _buildRestaurantGrid() {
    final isTablet = MediaQuery.of(context).size.width >= 600;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 8), // أضف padding جانبي
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isTablet ? 3 : 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.8, // عدل النسبة لتكون أكثر أمانًا (جرب 0.7 إلى 0.9)
      ),
      itemCount: filteredRestaurants.length,
      itemBuilder: (context, index) {
        return RestaurantCard(
          restaurant: filteredRestaurants[index],
        );
      },
    );
  }

  Widget _buildEmptyState(AppLocalizations localizations) {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Icon(
            Icons.search_off,
            size: 80,
            // ignore: deprecated_member_use
            color:
                Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            localizations.noResultsFound,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            localizations.tryDifferentSearch,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
