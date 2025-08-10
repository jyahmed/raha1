import 'package:flutter/material.dart';
import 'models/restaurant.dart';
import 'screens/contact_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/fast_delivery_screen.dart';
import 'screens/nearest_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import '../screens/restaurant_detail_screen.dart';
import 'widgets/custom_app_bar.dart';
import 'widgets/custom_bottom_nav.dart';

import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens/home_screen.dart';
import 'screens/restaurant_screen.dart';
import 'screens/stores_screen.dart';
import 'screens/orders_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/product_screen.dart';
import 'screens/coupons_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/about_screen.dart';
import 'screens/previous_orders_screen.dart';
import 'screens/favorites_screen.dart';
import 'providers/cart_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/favorites_provider.dart';
import 'providers/settings_provider.dart';

import 'screens/order_confirmation_screen.dart';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;

  const MyApp({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider(prefs: prefs)),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settingsProvider, child) {
          return MaterialApp(
            title: settingsProvider.language == 'ar'
                ? 'توصيل راحة'
                : 'Raha Delivery',
            debugShowCheckedModeBanner: false,
            theme: _buildLightTheme(),
            darkTheme: _buildDarkTheme(),
            themeMode: settingsProvider.getThemeMode(),
            locale: Locale(settingsProvider.language),
            localizationsDelegates: const [
              AppLocalizationsDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('ar', ''), Locale('en', '')],
            builder: (context, child) {
              final locale = Localizations.localeOf(context);
              return Directionality(
                textDirection: locale.languageCode == 'ar'
                    ? TextDirection.ltr
                    : TextDirection.rtl,
                child: Scaffold(
                  body: child!,
                ),
              );
            },
            home: const MainNavigationScreen(),
            routes: {
              '/main': (context) => const MainNavigationScreen(),
              '/home': (context) => const HomeScreen(),
              '/restaurant': (context) => const RestaurantScreen(),
              '/stores': (context) => const StoresScreen(),
              '/orders': (context) => const OrdersScreen(
                    confirmedOrders: [],
                  ),
              '/profile': (context) => const ProfileScreen(),
              '/product': (context) => const ProductScreen(),
              '/coupons': (context) => const CouponsScreen(),
              '/auth': (context) => const AuthScreen(),
              '/notifications': (context) => const NotificationsScreen(),
              '/settings_screen': (context) => const SettingsScreen(),
              '/about_screen': (context) => const AboutScreen(),
              '/contact_screen': (context) => const ContactScreen(),
              '/previous_orders': (context) => const PreviousOrdersScreen(),
              '/favorites': (context) => const FavoritesScreen(),
              '/fast_delivery': (context) => FastDeliveryScreen(),
              '/nearest': (context) => const NearestScreen(),
              '/order_confirmation': (context) =>
                  const OrderConfirmationScreen(),
              '/cart': (context) =>
                  const CartScreen(), // تأكد من استيراد CartScreen
              '/restaurant-detail': (context) {
                final args = ModalRoute.of(context)?.settings.arguments;
                return args != null && args is Restaurant
                    ? RestaurantDetailScreen(restaurant: args)
                    : const Placeholder(); // أو أي ويدجت بديلة
              },
            },
            initialRoute: '/main',
          );
        },
      ),
    );
  }

  ThemeData _buildLightTheme() {
    return ThemeData(
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.black), // للنصوص الأساسية
        titleMedium: TextStyle(color: Colors.black), // لعناوين الـ ListTile
      ),
      scaffoldBackgroundColor: const Color(0xFFF8F9FA),
      primaryColor: const Color.fromARGB(255, 58, 223, 245),
      fontFamily: GoogleFonts.cairo().fontFamily,
      appBarTheme: AppBarTheme(
        backgroundColor: const Color.fromARGB(255, 58, 223, 245),
        foregroundColor: const Color(0xFF153A6B),
        elevation: 0,
        titleTextStyle: GoogleFonts.cairo(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF153A6B),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF153A6B)),
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFFC72C),
          foregroundColor: const Color(0xFF153A6B),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          minimumSize: const Size.fromHeight(50),
        ),
      ),
      colorScheme: ColorScheme.fromSwatch().copyWith(
        secondary: const Color(0xFFFFC72C),
        primary: const Color(0xFF153A6B),
      ),
      cardColor: Colors.white,
      cardTheme: const CardThemeData(
        color: Colors.white,
        elevation: 4,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: Color(0xFF153A6B),
        unselectedItemColor: Colors.grey,
        elevation: 8,
      ),
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF121212),
      primaryColor: const Color(0xFF7EE6F3),
      fontFamily: GoogleFonts.cairo().fontFamily,
      textTheme: GoogleFonts.cairoTextTheme(
        ThemeData.dark().textTheme,
      ).apply(
          bodyColor: const Color.fromARGB(255, 7, 0, 0),
          displayColor: const Color.fromARGB(255, 15, 0, 0)),
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFF1E1E1E),
        foregroundColor: const Color(0xFF7EE6F3),
        elevation: 0,
        titleTextStyle: GoogleFonts.cairo(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF7EE6F3),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF7EE6F3)),
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFFC72C),
          foregroundColor: const Color(0xFF121212),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          minimumSize: const Size.fromHeight(50),
        ),
      ),
      colorScheme: ColorScheme.fromSwatch(brightness: Brightness.dark).copyWith(
        secondary: const Color(0xFFFFC72C),
        primary: const Color(0xFF7EE6F3),
        surface: const Color(0xFF1E1E1E),
        background: const Color(0xFF121212),
      ),
      cardColor: const Color(0xFF1E1E1E),
      cardTheme: const CardThemeData(
        color: Color(0xFF1E1E1E),
        elevation: 4,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF1E1E1E),
        selectedItemColor: Color(0xFF7EE6F3),
        unselectedItemColor: Colors.grey,
        elevation: 8,
      ),
      drawerTheme: const DrawerThemeData(backgroundColor: Color(0xFF121212)),
      dividerColor: const Color(0xFF333333),
      iconTheme: const IconThemeData(color: Color(0xFF7EE6F3)),
    );
  }
}

class  {
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const StoresScreen(),
    const OrdersScreen(
      confirmedOrders: [],
    ),
    const CouponsScreen(),
    const ProfileScreen(),
  ];

  void _showContactDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.ltr,
        child: AlertDialog(
          backgroundColor: const Color(0xFF7EE6F3),
          title: Text(
            'تواصل معنا',
            style: GoogleFonts.cairo(
              color: const Color(0xFF153A6B),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildContactOption(
                context,
                Icons.phone,
                'اتصال هاتفي',
                () async {
                  const phoneNumber = 'tel:+966123456789';
                  // ignore: deprecated_member_use
                  if (await canLaunch(phoneNumber)) {
                    // ignore: deprecated_member_use
                    await launch(phoneNumber);
                  }
                },
              ),
              _buildContactOption(context, Icons.chat, 'واتساب', () async {
                const whatsappUrl = 'https://wa.me/966123456789';
                // ignore: deprecated_member_use
                if (await canLaunch(whatsappUrl)) {
                  // ignore: deprecated_member_use
                  await launch(whatsappUrl);
                }
              }),
              _buildContactOption(context, Icons.facebook, 'فيسبوك', () async {
                const facebookUrl = 'https://facebook.com/yourpage';
                // ignore: deprecated_member_use
                if (await canLaunch(facebookUrl)) {
                  // ignore: deprecated_member_use
                  await launch(facebookUrl);
                }
              }),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'إغلاق',
                style: GoogleFonts.cairo(color: const Color(0xFF153A6B)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactOption(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF153A6B)),
      title: Text(title),
      onTap: onTap,
    );
  }

  void _showSettingsMenu(BuildContext context) {
    showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(0, 60, 0, 0),
      items: [
        PopupMenuItem(
          height: 48,
          child: _buildSettingsMenuItem(
            context,
            Icons.settings,
            'الإعدادات',
            () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/settings_screen');
            },
          ),
        ),
        PopupMenuItem(
          height: 48,
          child: _buildSettingsMenuItem(context, Icons.call, 'تواصل معنا', () {
            Navigator.pop(context);
            _showContactDialog(context);
          }),
        ),
        PopupMenuItem(
          height: 48,
          child: _buildSettingsMenuItem(
            context,
            Icons.share,
            'مشاركة التطبيق',
            () {
              Navigator.pop(context);
              Share.share(
                'تحميل تطبيق توصيل راحة - أفضل تطبيق لتوصيل الطلبات إلى المنزل',
                subject: 'توصيل راحة',
              );
            },
          ),
        ),
        PopupMenuItem(
          height: 48,
          child: _buildSettingsMenuItem(context, Icons.info, 'عن التطبيق', () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/about_screen');
          }),
        ),
        PopupMenuItem(
          height: 48,
          child: _buildSettingsMenuItem(
            context,
            Icons.logout,
            'تسجيل الخروج',
            () {
              Navigator.pop(context);
              Provider.of<AuthProvider>(context, listen: false).logout();
              Navigator.pushReplacementNamed(context, '/auth');
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsMenuItem(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              Icon(icon, color: const Color(0xFF153A6B)),
              const SizedBox(width: 12),
              Text(
                title,
                style: GoogleFonts.cairo(
                  color: const Color(0xFF153A6B),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      key: _scaffoldKey,
      drawer: Directionality(
        textDirection: TextDirection.ltr, // إجبار اتجاه النص لليسار
        child: Drawer(
          child: ListView(
            children: [
              DrawerHeader(
                decoration:
                    BoxDecoration(color: Theme.of(context).primaryColor),
                child: Center(
                  child: Text(
                    'القائمة الرئيسية',
                    style: GoogleFonts.cairo(
                      fontSize: 24,
                      color: const Color.fromARGB(255, 0, 4, 4),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              ListTile(
                leading:
                    Icon(Icons.home, color: Theme.of(context).primaryColor),
                title: Text(localizations.home, style: GoogleFonts.cairo()),
                onTap: () {
                  Navigator.pop(context);
                  setState(() => _selectedIndex = 0);
                },
              ),
              ListTile(
                leading:
                    Icon(Icons.store, color: Theme.of(context).primaryColor),
                title: Text(localizations.stores, style: GoogleFonts.cairo()),
                onTap: () {
                  Navigator.pop(context);
                  setState(() => _selectedIndex = 1);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.receipt_long,
                  color: Theme.of(context).primaryColor,
                ),
                title: Text(localizations.orders, style: GoogleFonts.cairo()),
                onTap: () {
                  Navigator.pop(context);
                  setState(() => _selectedIndex = 2);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.person,
                  color: Theme.of(context).primaryColor,
                ),
                title: Text(localizations.profile, style: GoogleFonts.cairo()),
                onTap: () {
                  Navigator.pop(context);
                  setState(() => _selectedIndex = 4);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.favorite,
                  color: Theme.of(context).primaryColor,
                ),
                title:
                    Text(localizations.favorites, style: GoogleFonts.cairo()),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/favorites');
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.history,
                  color: Theme.of(context).primaryColor,
                ),
                title: Text(
                  localizations.previousOrders,
                  style: GoogleFonts.cairo(),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/previous_orders');
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.local_offer,
                  color: Theme.of(context).primaryColor,
                ),
                title: Text(localizations.coupons, style: GoogleFonts.cairo()),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/coupons');
                },
              ),
              Divider(color: Theme.of(context).primaryColor),
              ListTile(
                leading: Icon(
                  Icons.notifications,
                  color: Theme.of(context).primaryColor,
                ),
                title: Text(
                  localizations.notifications,
                  style: GoogleFonts.cairo(),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/notifications');
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.settings,
                  color: Theme.of(context).primaryColor,
                ),
                title: Text(localizations.settings, style: GoogleFonts.cairo()),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/settings_screen');
                },
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        title: Align(
          alignment: Alignment.centerRight, // الصورة على اليمين
          child: Image.asset(
            'logo.png',
            height: isSmallScreen ? 90 : 130,
            fit: BoxFit.contain,
          ),
        ),
        leadingWidth: 120, // نحدد عرض مناسب لعناصر leading
        leading: Directionality(
          textDirection: TextDirection.ltr,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => _scaffoldKey.currentState?.openDrawer(),
              ),
              IconButton(
                icon: const Icon(Icons.person),
                onPressed: () {
                  Navigator.pushNamed(context, '/profile');
                  setState(() => _selectedIndex = 4);
                },
              ),
              Consumer<SettingsProvider>(
                builder: (context, settingsProvider, _) {
                  return IconButton(
                    icon: Stack(
                      children: [
                        const Icon(Icons.notifications),
                        if (settingsProvider.notificationsEnabled)
                          Positioned(
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: const Text('1',
                                  style: TextStyle(fontSize: 10)),
                            ),
                          ),
                      ],
                    ),
                    onPressed: () =>
                        Navigator.pushNamed(context, '/notifications'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(child: _screens[_selectedIndex]),
      bottomNavigationBar: EnhancedBottomNav(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: [
          BottomNavItem(
            icon: Icons.home_outlined,
            activeIcon: Icons.home,
            label: localizations.home,
          ),
          BottomNavItem(
            icon: Icons.store_outlined,
            activeIcon: Icons.store,
            label: localizations.stores,
          ),
          BottomNavItem(
            icon: Icons.receipt_long_outlined,
            activeIcon: Icons.receipt_long,
            label: localizations.orders,
            badgeCount: 2, // عدد الطلبات الجديدة
          ),
          BottomNavItem(
            icon: Icons.local_offer_outlined,
            activeIcon: Icons.local_offer,
            label: localizations.coupons,
            badgeCount: 1, // عدد الكوبونات الجديدة
          ),
        ],
      ),
    );
  }
}
