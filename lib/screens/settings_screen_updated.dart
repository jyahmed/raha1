import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'settings_provider.dart';
import '../l10n/app_localizations.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _emailNotifications = true;
  bool _smsNotifications = true;
  bool _pushNotifications = true;
  bool _orderUpdates = true;
  bool _promotionalOffers = true;
  bool _locationServices = true;
  bool _biometricAuth = false;
  bool _autoBackup = true;
  bool _dataSync = true;
  String _selectedLanguage = 'العربية';
  String _selectedCurrency = 'ريال يمني';
  String _selectedRegion = 'الجمهوريه اليمنية';

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'الإعدادات',
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
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // قسم الإشعارات والتنبيهات
            _buildSectionTitle('الإشعارات والتنبيهات'),
            _buildNotificationSettings(),

            const SizedBox(height: 20),

            // قسم إعدادات التطبيق
            _buildSectionTitle('إعدادات التطبيق'),
            _buildAppSettings(),

            const SizedBox(height: 20),

            // قسم اللغة والمنطقة
            _buildSectionTitle('اللغة والمنطقة'),
            _buildLanguageSettings(),

            const SizedBox(height: 20),

            // قسم الأمان والخصوصية
            _buildSectionTitle('الأمان والخصوصية'),
            _buildSecuritySettings(),

            const SizedBox(height: 20),

            // قسم المساعدة والدعم
            _buildSectionTitle('المساعدة والدعم'),
            _buildHelpSettings(),

            const SizedBox(height: 20),

            // قسم معلومات التطبيق
            _buildSectionTitle('معلومات التطبيق'),
            _buildAppInfoSettings(),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Text(
            title,
            style: GoogleFonts.cairo(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsCard({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildNotificationSettings() {
    return _buildSettingsCard(
      children: [
        _buildSwitchTile(
          icon: Icons.notifications,
          title: 'تفعيل الإشعارات',
          subtitle: 'تلقي جميع الإشعارات',
          value: _notificationsEnabled,
          onChanged: (value) {
            setState(() {
              _notificationsEnabled = value;
            });
          },
        ),
        const Divider(height: 1),
        _buildSwitchTile(
          icon: Icons.email,
          title: 'إشعارات البريد الإلكتروني',
          subtitle: 'تلقي الإشعارات عبر البريد',
          value: _emailNotifications,
          onChanged: (value) {
            setState(() {
              _emailNotifications = value;
            });
          },
        ),
        const Divider(height: 1),
        _buildSwitchTile(
          icon: Icons.sms,
          title: 'الرسائل النصية',
          subtitle: 'تلقي الإشعارات عبر SMS',
          value: _smsNotifications,
          onChanged: (value) {
            setState(() {
              _smsNotifications = value;
            });
          },
        ),
        const Divider(height: 1),
        _buildSwitchTile(
          icon: Icons.push_pin,
          title: 'الإشعارات الفورية',
          subtitle: 'إشعارات فورية على الجهاز',
          value: _pushNotifications,
          onChanged: (value) {
            setState(() {
              _pushNotifications = value;
            });
          },
        ),
        const Divider(height: 1),
        _buildSwitchTile(
          icon: Icons.shopping_bag,
          title: 'تحديثات الطلبات',
          subtitle: 'إشعارات حالة الطلب',
          value: _orderUpdates,
          onChanged: (value) {
            setState(() {
              _orderUpdates = value;
            });
          },
        ),
        const Divider(height: 1),
        _buildSwitchTile(
          icon: Icons.local_offer,
          title: 'العروض الترويجية',
          subtitle: 'إشعارات العروض والخصومات',
          value: _promotionalOffers,
          onChanged: (value) {
            setState(() {
              _promotionalOffers = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildAppSettings() {
    return Consumer<SettingsProvider>(
      builder: (context, settingsProvider, child) {
        return _buildSettingsCard(
          children: [
            _buildSwitchTile(
              icon: Icons.dark_mode,
              title: 'الوضع الليلي',
              subtitle: 'تفعيل المظهر الداكن',
              value: settingsProvider.darkModeEnabled,
              onChanged: (value) {
                settingsProvider.toggleDarkMode(value);
              },
            ),
            const Divider(height: 1),
            _buildSwitchTile(
              icon: Icons.location_on,
              title: 'خدمات الموقع',
              subtitle: 'السماح بالوصول للموقع',
              value: _locationServices,
              onChanged: (value) {
                setState(() {
                  _locationServices = value;
                });
              },
            ),
            const Divider(height: 1),
            _buildSwitchTile(
              icon: Icons.fingerprint,
              title: 'المصادقة البيومترية',
              subtitle: 'بصمة الإصبع أو الوجه',
              value: _biometricAuth,
              onChanged: (value) {
                setState(() {
                  _biometricAuth = value;
                });
              },
            ),
            const Divider(height: 1),
            _buildSwitchTile(
              icon: Icons.backup,
              title: 'النسخ الاحتياطي التلقائي',
              subtitle: 'حفظ البيانات تلقائياً',
              value: _autoBackup,
              onChanged: (value) {
                setState(() {
                  _autoBackup = value;
                });
              },
            ),
            const Divider(height: 1),
            _buildSwitchTile(
              icon: Icons.sync,
              title: 'مزامنة البيانات',
              subtitle: 'مزامنة عبر الأجهزة',
              value: _dataSync,
              onChanged: (value) {
                setState(() {
                  _dataSync = value;
                });
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildLanguageSettings() {
    return _buildSettingsCard(
      children: [
        _buildDropdownTile(
          icon: Icons.language,
          title: 'اللغة',
          subtitle: 'اختيار لغة التطبيق',
          value: _selectedLanguage,
          items: ['العربية', 'English'],
          onChanged: (value) {
            setState(() {
              _selectedLanguage = value!;
            });
          },
        ),
        const Divider(height: 1),
        _buildDropdownTile(
          icon: Icons.attach_money,
          title: 'العملة',
          subtitle: 'اختيار العملة المفضلة',
          value: _selectedCurrency,
          items: ['ريال يمني', 'ريال سعودي', 'دولار أمريكي'],
          onChanged: (value) {
            setState(() {
              _selectedCurrency = value!;
            });
          },
        ),
        const Divider(height: 1),
        _buildDropdownTile(
          icon: Icons.public,
          title: 'المنطقة',
          subtitle: 'اختيار المنطقة الجغرافية',
          value: _selectedRegion,
          items: ['الجمهوريه اليمنية', 'المملكة العربية السعودية', 'دولة الإمارات'],
          onChanged: (value) {
            setState(() {
              _selectedRegion = value!;
            });
          },
        ),
      ],
    );
  }

  Widget _buildSecuritySettings() {
    return _buildSettingsCard(
      children: [
        _buildMenuTile(
          icon: Icons.security,
          title: 'الأمان والخصوصية',
          subtitle: 'إعدادات الحماية والخصوصية',
          onTap: () => _showSecurityDialog(),
        ),
        const Divider(height: 1),
        _buildMenuTile(
          icon: Icons.privacy_tip,
          title: 'سياسة الخصوصية',
          subtitle: 'شروط الاستخدام والخصوصية',
          onTap: () => _showPrivacyDialog(),
        ),
        const Divider(height: 1),
        _buildMenuTile(
          icon: Icons.lock,
          title: 'تغيير كلمة المرور',
          subtitle: 'تحديث كلمة المرور',
          onTap: () => _showChangePasswordDialog(),
        ),
      ],
    );
  }

  Widget _buildHelpSettings() {
    return _buildSettingsCard(
      children: [
        _buildMenuTile(
          icon: Icons.help,
          title: 'مركز المساعدة',
          subtitle: 'الأسئلة الشائعة والدعم',
          onTap: () => _showHelpDialog(),
        ),
        const Divider(height: 1),
        _buildMenuTile(
          icon: Icons.chat_bubble,
          title: 'تواصل معنا',
          subtitle: 'الدردشة المباشرة والدعم',
          onTap: () => _showContactDialog(),
        ),
        const Divider(height: 1),
        _buildMenuTile(
          icon: Icons.star,
          title: 'تقييم التطبيق',
          subtitle: 'شاركنا رأيك',
          onTap: () => _showRatingDialog(),
        ),
        const Divider(height: 1),
        _buildMenuTile(
          icon: Icons.share,
          title: 'مشاركة التطبيق',
          subtitle: 'ادع أصدقاءك',
          onTap: () => _shareApp(),
        ),
      ],
    );
  }

  Widget _buildAppInfoSettings() {
    return _buildSettingsCard(
      children: [
        _buildMenuTile(
          icon: Icons.info,
          title: 'حول التطبيق',
          subtitle: 'الإصدار 2.1.0',
          onTap: () => _showAboutDialog(),
        ),
        const Divider(height: 1),
        _buildMenuTile(
          icon: Icons.update,
          title: 'التحديثات',
          subtitle: 'البحث عن تحديثات',
          onTap: () => _checkForUpdates(),
        ),
        const Divider(height: 1),
        _buildMenuTile(
          icon: Icons.bug_report,
          title: 'الإبلاغ عن مشكلة',
          subtitle: 'إرسال تقرير خطأ',
          onTap: () => _showBugReportDialog(),
        ),
      ],
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: Theme.of(context).primaryColor,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: GoogleFonts.cairo(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.cairo(
          fontSize: 14,
          color: Colors.grey[600],
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Theme.of(context).primaryColor,
      ),
    );
  }

  Widget _buildDropdownTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: Theme.of(context).primaryColor,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: GoogleFonts.cairo(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.cairo(
          fontSize: 14,
          color: Colors.grey[600],
        ),
      ),
      trailing: DropdownButton<String>(
        value: value,
        onChanged: onChanged,
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              style: GoogleFonts.cairo(fontSize: 14),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: Theme.of(context).primaryColor,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: GoogleFonts.cairo(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.cairo(
          fontSize: 14,
          color: Colors.grey[600],
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey[400],
      ),
      onTap: onTap,
    );
  }

  // Dialog methods
  void _showSecurityDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('الأمان والخصوصية', style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
        content: Text('إعدادات الأمان والخصوصية', style: GoogleFonts.cairo()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إغلاق', style: GoogleFonts.cairo()),
          ),
        ],
      ),
    );
  }

  void _showPrivacyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('سياسة الخصوصية', style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
        content: Text('شروط الاستخدام وسياسة الخصوصية', style: GoogleFonts.cairo()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إغلاق', style: GoogleFonts.cairo()),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('تغيير كلمة المرور', style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
        content: Text('تحديث كلمة المرور الخاصة بك', style: GoogleFonts.cairo()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء', style: GoogleFonts.cairo()),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('تحديث', style: GoogleFonts.cairo()),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('مركز المساعدة', style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
        content: Text('الأسئلة الشائعة والدعم الفني', style: GoogleFonts.cairo()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إغلاق', style: GoogleFonts.cairo()),
          ),
        ],
      ),
    );
  }

  void _showContactDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('تواصل معنا', style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
        content: Text('الدردشة المباشرة والدعم الفني', style: GoogleFonts.cairo()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إغلاق', style: GoogleFonts.cairo()),
          ),
        ],
      ),
    );
  }

  void _showRatingDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('تقييم التطبيق', style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
        content: Text('شاركنا رأيك في التطبيق', style: GoogleFonts.cairo()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('لاحقاً', style: GoogleFonts.cairo()),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('تقييم', style: GoogleFonts.cairo()),
          ),
        ],
      ),
    );
  }

  void _shareApp() {
    // Share app logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم نسخ رابط التطبيق', style: GoogleFonts.cairo()),
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('حول التطبيق', style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('تطبيق توصيل الطعام', style: GoogleFonts.cairo(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('الإصدار 2.1.0', style: GoogleFonts.cairo()),
            const SizedBox(height: 8),
            Text('تطبيق شامل لطلب وتوصيل الطعام من أفضل المطاعم', style: GoogleFonts.cairo()),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إغلاق', style: GoogleFonts.cairo()),
          ),
        ],
      ),
    );
  }

  void _checkForUpdates() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('لا توجد تحديثات متاحة', style: GoogleFonts.cairo()),
      ),
    );
  }

  void _showBugReportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('الإبلاغ عن مشكلة', style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
        content: Text('صف المشكلة التي واجهتها', style: GoogleFonts.cairo()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء', style: GoogleFonts.cairo()),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إرسال', style: GoogleFonts.cairo()),
          ),
        ],
      ),
    );
  }
}

