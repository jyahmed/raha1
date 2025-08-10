import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'settings_provider.dart';
import '../l10n/app_localizations.dart';
import 'account_settings_screen.dart';
import 'notification_settings_screen.dart';

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
          icon: Icons.person,
          title: 'إعدادات الحساب',
          subtitle: 'تعديل المعلومات الشخصية',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AccountSettingsScreen(),
            ),
          ),
        ),
        const Divider(height: 1),
        _buildMenuTile(
          icon: Icons.notifications,
          title: 'إعدادات الإشعارات',
          subtitle: 'تخصيص الإشعارات والتنبيهات',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NotificationSettingsScreen(),
            ),
          ),
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
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('إعدادات الأمان:', style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('• تشفير البيانات الشخصية', style: GoogleFonts.cairo()),
              Text('• حماية معلومات الدفع', style: GoogleFonts.cairo()),
              Text('• تأمين عمليات تسجيل الدخول', style: GoogleFonts.cairo()),
              const SizedBox(height: 16),
              Text('إعدادات الخصوصية:', style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('• عدم مشاركة البيانات مع أطراف ثالثة', style: GoogleFonts.cairo()),
              Text('• حماية سجل الطلبات', style: GoogleFonts.cairo()),
              Text('• تشفير معلومات الموقع', style: GoogleFonts.cairo()),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إغلاق', style: GoogleFonts.cairo()),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showMessage('تم تطبيق إعدادات الأمان');
            },
            child: Text('تطبيق', style: GoogleFonts.cairo()),
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
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('نحن نحترم خصوصيتك ونلتزم بحماية بياناتك الشخصية:', style: GoogleFonts.cairo()),
              const SizedBox(height: 12),
              Text('1. جمع البيانات:', style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
              Text('نجمع فقط البيانات الضرورية لتقديم الخدمة', style: GoogleFonts.cairo()),
              const SizedBox(height: 8),
              Text('2. استخدام البيانات:', style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
              Text('تستخدم بياناتك لتحسين تجربة التطبيق فقط', style: GoogleFonts.cairo()),
              const SizedBox(height: 8),
              Text('3. مشاركة البيانات:', style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
              Text('لا نشارك بياناتك مع أي طرف ثالث', style: GoogleFonts.cairo()),
              const SizedBox(height: 8),
              Text('4. حقوقك:', style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
              Text('يمكنك طلب حذف أو تعديل بياناتك في أي وقت', style: GoogleFonts.cairo()),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إغلاق', style: GoogleFonts.cairo()),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showMessage('تم قبول سياسة الخصوصية');
            },
            child: Text('موافق', style: GoogleFonts.cairo()),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog() {
    final TextEditingController currentPasswordController = TextEditingController();
    final TextEditingController newPasswordController = TextEditingController();
    final TextEditingController confirmPasswordController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('تغيير كلمة المرور', style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: currentPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'كلمة المرور الحالية',
                  labelStyle: GoogleFonts.cairo(),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: newPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'كلمة المرور الجديدة',
                  labelStyle: GoogleFonts.cairo(),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'تأكيد كلمة المرور الجديدة',
                  labelStyle: GoogleFonts.cairo(),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء', style: GoogleFonts.cairo()),
          ),
          ElevatedButton(
            onPressed: () {
              if (newPasswordController.text == confirmPasswordController.text) {
                Navigator.pop(context);
                _showMessage('تم تغيير كلمة المرور بنجاح');
              } else {
                _showMessage('كلمة المرور غير متطابقة');
              }
            },
            child: Text('تغيير', style: GoogleFonts.cairo()),
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
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('الأسئلة الشائعة:', style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              _buildFAQItem('كيف أقوم بتتبع طلبي؟', 'يمكنك تتبع طلبك من قسم "طلباتي" في التطبيق'),
              _buildFAQItem('كيف أغير عنوان التوصيل؟', 'اذهب إلى الملف الشخصي واختر "تعديل العنوان"'),
              _buildFAQItem('كيف أتواصل مع خدمة العملاء؟', 'يمكنك التواصل معنا عبر الهاتف أو الواتساب'),
              _buildFAQItem('كيف أقوم بإلغاء الطلب؟', 'يمكن إلغاء الطلب خلال 5 دقائق من تأكيده'),
              const SizedBox(height: 16),
              Text('للمزيد من المساعدة:', style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('📞 الهاتف: 712345678', style: GoogleFonts.cairo()),
              Text('📱 واتساب: 712345678', style: GoogleFonts.cairo()),
              Text('📧 البريد: support@rahadelivery.com', style: GoogleFonts.cairo()),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إغلاق', style: GoogleFonts.cairo()),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showContactDialog();
            },
            child: Text('تواصل معنا', style: GoogleFonts.cairo()),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'س: $question',
            style: GoogleFonts.cairo(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            'ج: $answer',
            style: GoogleFonts.cairo(color: Colors.grey[700]),
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
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.phone, color: Colors.green),
              title: Text('اتصال هاتفي', style: GoogleFonts.cairo()),
              subtitle: Text('712345678', style: GoogleFonts.cairo()),
              onTap: () {
                Navigator.pop(context);
                _makePhoneCall('712345678');
              },
            ),
            ListTile(
              leading: const Icon(Icons.chat, color: Colors.green),
              title: Text('واتساب', style: GoogleFonts.cairo()),
              subtitle: Text('712345678', style: GoogleFonts.cairo()),
              onTap: () {
                Navigator.pop(context);
                _openWhatsApp('712345678');
              },
            ),
            ListTile(
              leading: const Icon(Icons.email, color: Colors.blue),
              title: Text('البريد الإلكتروني', style: GoogleFonts.cairo()),
              subtitle: Text('support@rahadelivery.com', style: GoogleFonts.cairo()),
              onTap: () {
                Navigator.pop(context);
                _sendEmail('support@rahadelivery.com');
              },
            ),
            ListTile(
              leading: const Icon(Icons.facebook, color: Colors.blue),
              title: Text('فيسبوك', style: GoogleFonts.cairo()),
              subtitle: Text('Raha Delivery', style: GoogleFonts.cairo()),
              onTap: () {
                Navigator.pop(context);
                _openFacebook();
              },
            ),
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

  void _showRatingDialog() {
    int rating = 5;
    final TextEditingController feedbackController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('تقييم التطبيق', style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('كيف تقيم تجربتك مع التطبيق؟', style: GoogleFonts.cairo()),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    onPressed: () {
                      setState(() {
                        rating = index + 1;
                      });
                    },
                    icon: Icon(
                      index < rating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 32,
                    ),
                  );
                }),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: feedbackController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'ملاحظاتك (اختياري)',
                  labelStyle: GoogleFonts.cairo(),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('إلغاء', style: GoogleFonts.cairo()),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _submitRating(rating, feedbackController.text);
              },
              child: Text('إرسال التقييم', style: GoogleFonts.cairo()),
            ),
          ],
        ),
      ),
    );
  }

  void _shareApp() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'مشاركة التطبيق',
              style: GoogleFonts.cairo(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.share, color: Colors.blue),
              title: Text('مشاركة عامة', style: GoogleFonts.cairo()),
              subtitle: Text('مشاركة رابط التطبيق', style: GoogleFonts.cairo()),
              onTap: () {
                Navigator.pop(context);
                _shareAppLink();
              },
            ),
            ListTile(
              leading: const Icon(Icons.chat, color: Colors.green),
              title: Text('مشاركة عبر واتساب', style: GoogleFonts.cairo()),
              subtitle: Text('إرسال رابط التطبيق عبر واتساب', style: GoogleFonts.cairo()),
              onTap: () {
                Navigator.pop(context);
                _shareViaWhatsApp();
              },
            ),
            ListTile(
              leading: const Icon(Icons.sms, color: Colors.orange),
              title: Text('مشاركة عبر الرسائل', style: GoogleFonts.cairo()),
              subtitle: Text('إرسال رابط التطبيق عبر SMS', style: GoogleFonts.cairo()),
              onTap: () {
                Navigator.pop(context);
                _shareViaSMS();
              },
            ),
            ListTile(
              leading: const Icon(Icons.facebook, color: Colors.blue),
              title: Text('مشاركة على فيسبوك', style: GoogleFonts.cairo()),
              subtitle: Text('نشر التطبيق على فيسبوك', style: GoogleFonts.cairo()),
              onTap: () {
                Navigator.pop(context);
                _shareOnFacebook();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('حول التطبيق', style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).primaryColor,
                        Theme.of(context).colorScheme.secondary,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.delivery_dining,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  'توصيل راحة',
                  style: GoogleFonts.cairo(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  'الإصدار 2.1.0',
                  style: GoogleFonts.cairo(color: Colors.grey[600]),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'تطبيق توصيل راحة هو أفضل تطبيق لتوصيل الطلبات في اليمن. نوفر خدمة توصيل سريعة وموثوقة من المطاعم والمتاجر المفضلة لديك.',
                style: GoogleFonts.cairo(),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text('المميزات:', style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('• توصيل سريع خلال 30 دقيقة', style: GoogleFonts.cairo()),
              Text('• تتبع الطلب في الوقت الفعلي', style: GoogleFonts.cairo()),
              Text('• دفع آمن ومتنوع', style: GoogleFonts.cairo()),
              Text('• خدمة عملاء 24/7', style: GoogleFonts.cairo()),
              Text('• عروض وخصومات حصرية', style: GoogleFonts.cairo()),
              const SizedBox(height: 16),
              Text('تطوير: فريق راحة للتقنية', style: GoogleFonts.cairo()),
              Text('© 2024 جميع الحقوق محفوظة', style: GoogleFonts.cairo()),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إغلاق', style: GoogleFonts.cairo()),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _shareApp();
            },
            child: Text('مشاركة التطبيق', style: GoogleFonts.cairo()),
          ),
        ],
      ),
    );
  }

  void _checkForUpdates() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('البحث عن تحديثات', style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text('جاري البحث عن تحديثات...', style: GoogleFonts.cairo()),
          ],
        ),
      ),
    );

    // محاكاة البحث عن تحديثات
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('التحديثات', style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
          content: Text(
            'أنت تستخدم أحدث إصدار من التطبيق!\n\nالإصدار الحالي: 2.1.0\nتاريخ آخر تحديث: 4 أغسطس 2024',
            style: GoogleFonts.cairo(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('حسناً', style: GoogleFonts.cairo()),
            ),
          ],
        ),
      );
    });
  }

  void _showBugReportDialog() {
    final TextEditingController bugDescriptionController = TextEditingController();
    String selectedBugType = 'خطأ في التطبيق';
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('الإبلاغ عن مشكلة', style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('نوع المشكلة:', style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: selectedBugType,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  items: [
                    'خطأ في التطبيق',
                    'مشكلة في التوصيل',
                    'مشكلة في الدفع',
                    'مشكلة في تسجيل الدخول',
                    'مشكلة أخرى',
                  ].map((type) => DropdownMenuItem(
                    value: type,
                    child: Text(type, style: GoogleFonts.cairo()),
                  )).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedBugType = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                Text('وصف المشكلة:', style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextField(
                  controller: bugDescriptionController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'اشرح المشكلة بالتفصيل...',
                    hintStyle: GoogleFonts.cairo(),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('إلغاء', style: GoogleFonts.cairo()),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _submitBugReport(selectedBugType, bugDescriptionController.text);
              },
              child: Text('إرسال التقرير', style: GoogleFonts.cairo()),
            ),
          ],
        ),
      ),
    );
  }

  // Helper methods for actions
  void _makePhoneCall(String phoneNumber) {
    _showMessage('جاري الاتصال بـ $phoneNumber');
  }

  void _openWhatsApp(String phoneNumber) {
    _showMessage('جاري فتح واتساب للرقم $phoneNumber');
  }

  void _sendEmail(String email) {
    _showMessage('جاري فتح تطبيق البريد الإلكتروني');
  }

  void _openFacebook() {
    _showMessage('جاري فتح صفحة فيسبوك');
  }

  void _submitRating(int rating, String feedback) {
    _showMessage('شكراً لك! تم إرسال تقييمك ($rating نجوم)');
  }

  void _shareAppLink() {
    _showMessage('تم نسخ رابط التطبيق للمشاركة');
  }

  void _shareViaWhatsApp() {
    _showMessage('جاري فتح واتساب لمشاركة التطبيق');
  }

  void _shareViaSMS() {
    _showMessage('جاري فتح تطبيق الرسائل');
  }

  void _shareOnFacebook() {
    _showMessage('جاري فتح فيسبوك للمشاركة');
  }

  void _submitBugReport(String type, String description) {
    _showMessage('تم إرسال تقرير المشكلة. سنتواصل معك قريباً');
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.cairo()),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}

