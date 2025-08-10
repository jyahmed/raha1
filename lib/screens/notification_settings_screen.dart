import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  bool _allNotifications = true;
  bool _orderUpdates = true;
  bool _promotionalOffers = true;
  bool _newRestaurants = true;
  bool _specialDeals = true;
  bool _deliveryUpdates = true;
  bool _paymentNotifications = true;
  bool _accountSecurity = true;
  bool _weeklyReports = false;
  bool _monthlyReports = false;
  
  // إعدادات الصوت والاهتزاز
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  String _notificationTone = 'افتراضي';
  
  // إعدادات التوقيت
  TimeOfDay _quietHoursStart = const TimeOfDay(hour: 22, minute: 0);
  TimeOfDay _quietHoursEnd = const TimeOfDay(hour: 7, minute: 0);
  bool _quietHoursEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'إعدادات الإشعارات',
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
            // التحكم العام في الإشعارات
            _buildSectionTitle('التحكم العام'),
            _buildGeneralSettings(),

            const SizedBox(height: 20),

            // إشعارات الطلبات
            _buildSectionTitle('إشعارات الطلبات'),
            _buildOrderNotifications(),

            const SizedBox(height: 20),

            // إشعارات التسويق
            _buildSectionTitle('إشعارات التسويق'),
            _buildMarketingNotifications(),

            const SizedBox(height: 20),

            // إشعارات الحساب
            _buildSectionTitle('إشعارات الحساب'),
            _buildAccountNotifications(),

            const SizedBox(height: 20),

            // إعدادات الصوت
            _buildSectionTitle('إعدادات الصوت والاهتزاز'),
            _buildSoundSettings(),

            const SizedBox(height: 20),

            // إعدادات التوقيت
            _buildSectionTitle('إعدادات التوقيت'),
            _buildTimingSettings(),

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

  Widget _buildGeneralSettings() {
    return _buildSettingsCard(
      children: [
        _buildSwitchTile(
          icon: Icons.notifications,
          title: 'تفعيل جميع الإشعارات',
          subtitle: 'تشغيل أو إيقاف جميع الإشعارات',
          value: _allNotifications,
          onChanged: (value) {
            setState(() {
              _allNotifications = value;
              if (!value) {
                // إيقاف جميع الإشعارات
                _orderUpdates = false;
                _promotionalOffers = false;
                _newRestaurants = false;
                _specialDeals = false;
                _deliveryUpdates = false;
                _paymentNotifications = false;
                _accountSecurity = false;
                _weeklyReports = false;
                _monthlyReports = false;
              }
            });
          },
        ),
      ],
    );
  }

  Widget _buildOrderNotifications() {
    return _buildSettingsCard(
      children: [
        _buildSwitchTile(
          icon: Icons.shopping_bag,
          title: 'تحديثات الطلبات',
          subtitle: 'إشعارات حالة الطلب والتوصيل',
          value: _orderUpdates,
          onChanged: _allNotifications ? (value) {
            setState(() {
              _orderUpdates = value;
            });
          } : null,
        ),
        const Divider(height: 1),
        _buildSwitchTile(
          icon: Icons.delivery_dining,
          title: 'تحديثات التوصيل',
          subtitle: 'إشعارات موقع السائق ووقت الوصول',
          value: _deliveryUpdates,
          onChanged: _allNotifications ? (value) {
            setState(() {
              _deliveryUpdates = value;
            });
          } : null,
        ),
        const Divider(height: 1),
        _buildSwitchTile(
          icon: Icons.payment,
          title: 'إشعارات الدفع',
          subtitle: 'تأكيد المدفوعات والفواتير',
          value: _paymentNotifications,
          onChanged: _allNotifications ? (value) {
            setState(() {
              _paymentNotifications = value;
            });
          } : null,
        ),
      ],
    );
  }

  Widget _buildMarketingNotifications() {
    return _buildSettingsCard(
      children: [
        _buildSwitchTile(
          icon: Icons.local_offer,
          title: 'العروض الترويجية',
          subtitle: 'إشعارات العروض والخصومات',
          value: _promotionalOffers,
          onChanged: _allNotifications ? (value) {
            setState(() {
              _promotionalOffers = value;
            });
          } : null,
        ),
        const Divider(height: 1),
        _buildSwitchTile(
          icon: Icons.store,
          title: 'المطاعم الجديدة',
          subtitle: 'إشعارات المطاعم والمتاجر الجديدة',
          value: _newRestaurants,
          onChanged: _allNotifications ? (value) {
            setState(() {
              _newRestaurants = value;
            });
          } : null,
        ),
        const Divider(height: 1),
        _buildSwitchTile(
          icon: Icons.star,
          title: 'العروض الخاصة',
          subtitle: 'عروض حصرية ومناسبات خاصة',
          value: _specialDeals,
          onChanged: _allNotifications ? (value) {
            setState(() {
              _specialDeals = value;
            });
          } : null,
        ),
      ],
    );
  }

  Widget _buildAccountNotifications() {
    return _buildSettingsCard(
      children: [
        _buildSwitchTile(
          icon: Icons.security,
          title: 'أمان الحساب',
          subtitle: 'إشعارات تسجيل الدخول والأمان',
          value: _accountSecurity,
          onChanged: _allNotifications ? (value) {
            setState(() {
              _accountSecurity = value;
            });
          } : null,
        ),
        const Divider(height: 1),
        _buildSwitchTile(
          icon: Icons.bar_chart,
          title: 'التقارير الأسبوعية',
          subtitle: 'ملخص أسبوعي لنشاطك',
          value: _weeklyReports,
          onChanged: _allNotifications ? (value) {
            setState(() {
              _weeklyReports = value;
            });
          } : null,
        ),
        const Divider(height: 1),
        _buildSwitchTile(
          icon: Icons.calendar_month,
          title: 'التقارير الشهرية',
          subtitle: 'ملخص شهري لطلباتك ومدفوعاتك',
          value: _monthlyReports,
          onChanged: _allNotifications ? (value) {
            setState(() {
              _monthlyReports = value;
            });
          } : null,
        ),
      ],
    );
  }

  Widget _buildSoundSettings() {
    return _buildSettingsCard(
      children: [
        _buildSwitchTile(
          icon: Icons.volume_up,
          title: 'الصوت',
          subtitle: 'تشغيل صوت الإشعارات',
          value: _soundEnabled,
          onChanged: (value) {
            setState(() {
              _soundEnabled = value;
            });
          },
        ),
        const Divider(height: 1),
        _buildSwitchTile(
          icon: Icons.vibration,
          title: 'الاهتزاز',
          subtitle: 'اهتزاز الجهاز عند الإشعارات',
          value: _vibrationEnabled,
          onChanged: (value) {
            setState(() {
              _vibrationEnabled = value;
            });
          },
        ),
        const Divider(height: 1),
        _buildDropdownTile(
          icon: Icons.music_note,
          title: 'نغمة الإشعار',
          subtitle: 'اختيار نغمة الإشعارات',
          value: _notificationTone,
          items: ['افتراضي', 'نغمة 1', 'نغمة 2', 'نغمة 3', 'صامت'],
          onChanged: (value) {
            setState(() {
              _notificationTone = value!;
            });
          },
        ),
      ],
    );
  }

  Widget _buildTimingSettings() {
    return _buildSettingsCard(
      children: [
        _buildSwitchTile(
          icon: Icons.bedtime,
          title: 'ساعات الهدوء',
          subtitle: 'إيقاف الإشعارات في أوقات محددة',
          value: _quietHoursEnabled,
          onChanged: (value) {
            setState(() {
              _quietHoursEnabled = value;
            });
          },
        ),
        if (_quietHoursEnabled) ...[
          const Divider(height: 1),
          _buildTimeTile(
            icon: Icons.bedtime,
            title: 'بداية ساعات الهدوء',
            time: _quietHoursStart,
            onChanged: (time) {
              setState(() {
                _quietHoursStart = time;
              });
            },
          ),
          const Divider(height: 1),
          _buildTimeTile(
            icon: Icons.wb_sunny,
            title: 'نهاية ساعات الهدوء',
            time: _quietHoursEnd,
            onChanged: (time) {
              setState(() {
                _quietHoursEnd = time;
              });
            },
          ),
        ],
      ],
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool>? onChanged,
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
          color: onChanged == null ? Colors.grey : null,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.cairo(
          fontSize: 14,
          color: onChanged == null ? Colors.grey : Colors.grey[600],
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

  Widget _buildTimeTile({
    required IconData icon,
    required String title,
    required TimeOfDay time,
    required ValueChanged<TimeOfDay> onChanged,
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
      trailing: InkWell(
        onTap: () async {
          final TimeOfDay? picked = await showTimePicker(
            context: context,
            initialTime: time,
          );
          if (picked != null) {
            onChanged(picked);
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).primaryColor),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            time.format(context),
            style: GoogleFonts.cairo(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

