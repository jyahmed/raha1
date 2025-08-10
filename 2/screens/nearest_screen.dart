import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/restaurant_card.dart';
import '../models/restaurant.dart';
import '../services/location_service.dart';

class NearestScreen extends StatefulWidget {
  const NearestScreen({super.key});

  @override
  State<NearestScreen> createState() => _NearestScreenState();
}

class _NearestScreenState extends State<NearestScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  // متغيرات الموقع
  Map<String, double>? _currentLocation;
  String _currentAddress = 'جاري تحديد الموقع...';
  bool _isLoadingLocation = true;
  List<Map<String, dynamic>> _nearbyStores = [];
  List<Map<String, dynamic>> _nearbyRestaurants = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _getCurrentLocationAndStores();
  }

  Future<void> _getCurrentLocationAndStores() async {
    try {
      // الحصول على الموقع الحالي
      final location = await LocationService.getCurrentLocation();
      final address = await LocationService.getAddressFromCoordinates(
        location['latitude']!,
        location['longitude']!,
      );

      // الحصول على المتاجر القريبة
      final allStores = LocationService.getDummyStores();
      final nearbyStores = LocationService.getNearbyStores(
        location['latitude']!,
        location['longitude']!,
        allStores,
      );

      // تصنيف المتاجر
      final restaurants = nearbyStores
          .where((store) =>
              store['category'].contains('مطعم') ||
              store['category'].contains('مقاهي') ||
              store['category'].contains('مأكولات'))
          .toList();

      final stores = nearbyStores
          .where((store) =>
              !store['category'].contains('مطعم') &&
              !store['category'].contains('مقاهي') &&
              !store['category'].contains('مأكولات'))
          .toList();

      setState(() {
        _currentLocation = location;
        _currentAddress = address;
        _nearbyStores = stores;
        _nearbyRestaurants = restaurants;
        _isLoadingLocation = false;
      });
    } catch (e) {
      setState(() {
        _currentAddress = 'فشل في تحديد الموقع';
        _isLoadingLocation = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get filteredRestaurants {
    return _nearbyRestaurants.where((restaurant) {
      return restaurant['name'].toString().contains(searchQuery) ||
          restaurant['category'].toString().contains(searchQuery);
    }).toList();
  }

  List<Map<String, dynamic>> get filteredStores {
    return _nearbyStores.where((store) {
      return store['name'].toString().contains(searchQuery) ||
          store['category'].toString().contains(searchQuery);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          'الأقرب لك',
          style: GoogleFonts.cairo(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 58, 223, 245),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _getCurrentLocationAndStores,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFFFFC72C),
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: GoogleFonts.cairo(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: GoogleFonts.cairo(
            fontSize: 16,
            fontWeight: FontWeight.normal,
          ),
          tabs: const [
            Tab(text: 'المطاعم'),
            Tab(text: 'المتاجر'),
          ],
        ),
      ),
      body: Column(
        children: [
          // معلومات الموقع الحالي
          Container(
            color: const Color.fromARGB(255, 58, 223, 245),
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Icon(
                  _isLoadingLocation
                      ? Icons.location_searching
                      : Icons.location_on,
                  color: const Color(0xFFFFC72C),
                  size: 24,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _currentAddress,
                    style: GoogleFonts.cairo(
                      color: const Color.fromARGB(255, 0, 0, 0),
                      fontSize: 16,
                    ),
                  ),
                ),
                if (_isLoadingLocation)
                  const SizedBox(
                    width: 10,
                    height: 10,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Color(0xFFFFC72C)),
                    ),
                  ),
              ],
            ),
          ),

          // شريط البحث
          Container(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: TextField(
              controller: _searchController,
              textAlign: TextAlign.right,
              style: GoogleFonts.cairo(),
              decoration: InputDecoration(
                hintText: 'ابحث عن مطعم أو متجر...',
                hintStyle: GoogleFonts.cairo(
                    color: const Color.fromARGB(255, 49, 48, 48)),
                prefixIcon: const Icon(Icons.search,
                    color: Color.fromARGB(255, 57, 56, 56)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: const Color.fromARGB(167, 58, 223, 245),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),

          // محتوى التبويبات
          Expanded(
            child: _isLoadingLocation
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('جاري تحديد الموقع والبحث عن المتاجر القريبة...'),
                      ],
                    ),
                  )
                : TabBarView(
                    controller: _tabController,
                    children: [
                      // تبويب المطاعم
                      _buildRestaurantsTab(),
                      // تبويب المتاجر
                      _buildStoresTab(),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildRestaurantsTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Icon(
                Icons.location_on,
                color: Color(0xFF153A6B),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'المطاعم القريبة منك (${filteredRestaurants.length})',
                style: GoogleFonts.cairo(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF153A6B),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: filteredRestaurants.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.restaurant,
                        size: 64,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'لا توجد مطاعم قريبة',
                        style: GoogleFonts.cairo(
                          fontSize: 18,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filteredRestaurants.length,
                  itemBuilder: (context, index) {
                    final restaurant = filteredRestaurants[index];
                    return _buildStoreCard(restaurant);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildStoresTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Icon(
                Icons.store,
                color: Color(0xFF153A6B),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'المتاجر القريبة منك (${filteredStores.length})',
                style: GoogleFonts.cairo(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF153A6B),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: filteredStores.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.store,
                        size: 64,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'لا توجد متاجر قريبة',
                        style: GoogleFonts.cairo(
                          fontSize: 18,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filteredStores.length,
                  itemBuilder: (context, index) {
                    final store = filteredStores[index];
                    return _buildStoreCard(store);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildStoreCard(Map<String, dynamic> store) {
    final deliveryFee = LocationService.calculateDeliveryFee(store['distance']);
    final estimatedTime =
        LocationService.estimateDeliveryTime(store['distance']);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // أيقونة المتجر
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getStoreIcon(store['category']),
                    color: Theme.of(context).primaryColor,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 16),

                // معلومات المتجر
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        store['name'],
                        style: GoogleFonts.cairo(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        store['category'],
                        style: GoogleFonts.cairo(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            store['rating'].toString(),
                            style: GoogleFonts.cairo(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // حالة المتجر
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: store['isOpen'] ? Colors.green : Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    store['isOpen'] ? 'مفتوح' : 'مغلق',
                    style: GoogleFonts.cairo(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // معلومات التوصيل
            Row(
              children: [
                _buildInfoChip(
                  Icons.location_on,
                  store['distanceText'],
                  Colors.blue,
                ),
                const SizedBox(width: 8),
                _buildInfoChip(
                  Icons.access_time,
                  estimatedTime,
                  Colors.orange,
                ),
                const SizedBox(width: 8),
                _buildInfoChip(
                  Icons.delivery_dining,
                  '${deliveryFee.toInt()} ر.ي',
                  Colors.green,
                ),
              ],
            ),

            const SizedBox(height: 12),

            // العنوان
            Row(
              children: [
                Icon(
                  Icons.location_pin,
                  color: Colors.grey[600],
                  size: 16,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    store['address'],
                    style: GoogleFonts.cairo(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // أزرار الإجراءات
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: store['isOpen']
                        ? () {
                            // الانتقال إلى صفحة المتجر
                          }
                        : null,
                    icon: const Icon(Icons.shopping_bag, size: 18),
                    label: Text(
                      'تصفح المتجر',
                      style: GoogleFonts.cairo(),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: () {
                    // الاتصال بالمتجر
                  },
                  icon: const Icon(Icons.phone, size: 18),
                  label: Text(
                    'اتصال',
                    style: GoogleFonts.cairo(),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Theme.of(context).primaryColor,
                    side: BorderSide(color: Theme.of(context).primaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 4),
          Text(
            text,
            style: GoogleFonts.cairo(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getStoreIcon(String category) {
    if (category.contains('مطعم') || category.contains('مقاهي')) {
      return Icons.restaurant;
    } else if (category.contains('سوبر ماركت')) {
      return Icons.shopping_cart;
    } else if (category.contains('صيدلية')) {
      return Icons.local_pharmacy;
    } else if (category.contains('مأكولات بحرية')) {
      return Icons.set_meal;
    } else {
      return Icons.store;
    }
  }
}
