import 'package:flutter/material.dart';

abstract class AppLocalizations {
  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  // Navigation
  String get home;
  String get stores;
  String get orders;
  String get coupons;
  String get profile;

  // Settings
  String get settings;
  String get notifications;
  String get language;
  String get darkMode;
  String get previousOrders;
  String get favorites;
  String get privacySecurity;
  String get helpSupport;
  String get aboutApp;
  String get logout;

  // Common
  String get close;
  String get cancel;
  String get confirm;
  String get save;
  String get delete;
  String get edit;
  String get search;
  String get viewMore;
  String get addToCart;
  String get removeFromFavorites;
  String get addToFavorites;
  String get reorder;
  String get viewDetails;
  String get clearAll;
  String get undo;

  // Quick Actions
  String get quickActions;
  String get fastDelivery;
  String get offers;

  // Home Screen
  String get restaurantsStores;
  String get noResultsFound;
  String get tryDifferentSearch;

  // Previous Orders
  String get orderNumber;
  String get orderDetails;
  String get delivered;
  String get preparing;
  String get onTheWay;
  String get cancelled;
  String get total;
  String get items;
  String get restaurant;
  String get date;
  String get status;

  // Favorites
  String get noFavoriteItems;
  String get startAddingFavorites;
  String get browseRestaurants;
  String get removedFromFavorites;
  String get addedToCart;
  String get clearAllFavorites;
  String get confirmClearFavorites;
  String get allFavoritesCleared;

  // Messages
  String get itemAddedToCart;
  String get itemRemovedFromFavorites;
  String get itemsAddedToCart;

  // Contact
  String get contactUs;
  String get phoneCall;
  String get whatsapp;
  String get facebook;

  // App Info
  String get appTitle;
  String get shareApp;
  String get shareAppMessage;
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['ar', 'en'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    switch (locale.languageCode) {
      case 'en':
        return AppLocalizationsEn();
      case 'ar':
      default:
        return AppLocalizationsAr();
    }
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}

class AppLocalizationsAr extends AppLocalizations {
  @override
  String get home => 'الرئيسية';
  @override
  String get stores => 'المتاجر';
  @override
  String get orders => 'الطلبات';
  @override
  String get coupons => 'الكوبونات';
  @override
  String get profile => 'الملف الشخصي';

  @override
  String get settings => 'الإعدادات';
  @override
  String get notifications => 'الإشعارات';
  @override
  String get language => 'اللغة';
  @override
  String get darkMode => 'الوضع الليلي';
  @override
  String get previousOrders => 'الطلبات السابقة';
  @override
  String get favorites => 'المفضلة';
  @override
  String get privacySecurity => 'الخصوصية والأمان';
  @override
  String get helpSupport => 'المساعدة والدعم';
  @override
  String get aboutApp => 'عن التطبيق';
  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get close => 'إغلاق';
  @override
  String get cancel => 'إلغاء';
  @override
  String get confirm => 'تأكيد';
  @override
  String get save => 'حفظ';
  @override
  String get delete => 'حذف';
  @override
  String get edit => 'تعديل';
  @override
  String get search => 'بحث';
  @override
  String get viewMore => 'عرض المزيد';
  @override
  String get addToCart => 'إضافة للسلة';
  @override
  String get removeFromFavorites => 'إزالة من المفضلة';
  @override
  String get addToFavorites => 'إضافة للمفضلة';
  @override
  String get reorder => 'إعادة الطلب';
  @override
  String get viewDetails => 'عرض التفاصيل';
  @override
  String get clearAll => 'مسح الكل';
  @override
  String get undo => 'تراجع';

  @override
  String get quickActions => 'الإجراءات السريعة';
  @override
  String get fastDelivery => 'توصيل سريع';
  @override
  String get offers => 'العروض';

  @override
  String get restaurantsStores => 'المطاعم والمتاجر';
  @override
  String get noResultsFound => 'لم نجد نتائج';
  @override
  String get tryDifferentSearch => 'جرب البحث بكلمات مختلفة أو تصفح الفئات';

  @override
  String get orderNumber => 'طلب';
  @override
  String get orderDetails => 'تفاصيل الطلب';
  @override
  String get delivered => 'تم التوصيل';
  @override
  String get preparing => 'قيد التحضير';
  @override
  String get onTheWay => 'في الطريق';
  @override
  String get cancelled => 'ملغي';
  @override
  String get total => 'المجموع';
  @override
  String get items => 'العناصر';
  @override
  String get restaurant => 'المطعم';
  @override
  String get date => 'التاريخ';
  @override
  String get status => 'الحالة';

  @override
  String get noFavoriteItems => 'لا توجد عناصر مفضلة';
  @override
  String get startAddingFavorites => 'ابدأ بإضافة عناصرك المفضلة لتظهر هنا';
  @override
  String get browseRestaurants => 'تصفح المطاعم';
  @override
  String get removedFromFavorites => 'تم إزالة العنصر من المفضلة';
  @override
  String get addedToCart => 'تم إضافة العنصر إلى السلة';
  @override
  String get clearAllFavorites => 'مسح جميع المفضلة';
  @override
  String get confirmClearFavorites =>
      'هل أنت متأكد من أنك تريد مسح جميع العناصر المفضلة؟';
  @override
  String get allFavoritesCleared => 'تم مسح جميع المفضلة';

  @override
  String get itemAddedToCart => 'تم إضافة العنصر إلى السلة';
  @override
  String get itemRemovedFromFavorites => 'تم إزالة العنصر من المفضلة';
  @override
  String get itemsAddedToCart => 'تم إضافة العناصر إلى السلة';

  @override
  String get contactUs => 'تواصل معنا';
  @override
  String get phoneCall => 'اتصال هاتفي';
  @override
  String get whatsapp => 'واتساب';
  @override
  String get facebook => 'فيسبوك';

  @override
  String get appTitle => 'توصيل راحة';
  @override
  String get shareApp => 'مشاركة التطبيق';
  @override
  String get shareAppMessage =>
      'تحميل تطبيق توصيل راحة - أفضل تطبيق لتوصيل الطلبات إلى المنزل';
}

class AppLocalizationsEn extends AppLocalizations {
  @override
  String get home => 'Home';
  @override
  String get stores => 'Stores';
  @override
  String get orders => 'Orders';
  @override
  String get coupons => 'Coupons';
  @override
  String get profile => 'Profile';

  @override
  String get settings => 'Settings';
  @override
  String get notifications => 'Notifications';
  @override
  String get language => 'Language';
  @override
  String get darkMode => 'Dark Mode';
  @override
  String get previousOrders => 'Previous Orders';
  @override
  String get favorites => 'Favorites';
  @override
  String get privacySecurity => 'Privacy & Security';
  @override
  String get helpSupport => 'Help & Support';
  @override
  String get aboutApp => 'About App';
  @override
  String get logout => 'Logout';

  @override
  String get close => 'Close';
  @override
  String get cancel => 'Cancel';
  @override
  String get confirm => 'Confirm';
  @override
  String get save => 'Save';
  @override
  String get delete => 'Delete';
  @override
  String get edit => 'Edit';
  @override
  String get search => 'Search';
  @override
  String get viewMore => 'View More';
  @override
  String get addToCart => 'Add to Cart';
  @override
  String get removeFromFavorites => 'Remove from Favorites';
  @override
  String get addToFavorites => 'Add to Favorites';
  @override
  String get reorder => 'Reorder';
  @override
  String get viewDetails => 'View Details';
  @override
  String get clearAll => 'Clear All';
  @override
  String get undo => 'Undo';

  @override
  String get quickActions => 'Quick Actions';
  @override
  String get fastDelivery => 'Fast Delivery';
  @override
  String get offers => 'Offers';

  @override
  String get restaurantsStores => 'Restaurants & Stores';
  @override
  String get noResultsFound => 'No Results Found';
  @override
  String get tryDifferentSearch =>
      'Try searching with different keywords or browse categories';
  @override
  String get orderNumber => 'Order';
  @override
  String get orderDetails => 'Order Details';
  @override
  String get delivered => 'Delivered';
  @override
  String get preparing => 'Preparing';
  @override
  String get onTheWay => 'On the Way';
  @override
  String get cancelled => 'Cancelled';
  @override
  String get total => 'Total';
  @override
  String get items => 'Items';
  @override
  String get restaurant => 'Restaurant';
  @override
  String get date => 'Date';
  @override
  String get status => 'Status';

  @override
  String get noFavoriteItems => 'No Favorite Items';
  @override
  String get startAddingFavorites =>
      'Start adding your favorite items to see them here';
  @override
  String get browseRestaurants => 'Browse Restaurants';
  @override
  String get removedFromFavorites => 'Item removed from favorites';
  @override
  String get addedToCart => 'Item added to cart';
  @override
  String get clearAllFavorites => 'Clear All Favorites';
  @override
  String get confirmClearFavorites =>
      'Are you sure you want to clear all favorite items?';
  @override
  String get allFavoritesCleared => 'All favorites cleared';

  @override
  String get itemAddedToCart => 'Item added to cart';
  @override
  String get itemRemovedFromFavorites => 'Item removed from favorites';
  @override
  String get itemsAddedToCart => 'Items added to cart';

  @override
  String get contactUs => 'Contact Us';
  @override
  String get phoneCall => 'Phone Call';
  @override
  String get whatsapp => 'WhatsApp';
  @override
  String get facebook => 'Facebook';

  @override
  String get appTitle => 'Raha Delivery';
  @override
  String get shareApp => 'Share App';
  @override
  String get shareAppMessage =>
      'Download Raha Delivery - The best app for home delivery orders';
}
