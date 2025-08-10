import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    // تحميل بيانات المستخدم الحالية
    _nameController.text = 'أحمد محمد علي';
    _phoneController.text = '712345678';
    _emailController.text = 'ahmed@example.com';
    _addressController.text = 'شارع الزبيري، حي السبعين، صنعاء';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'إعدادات الحساب',
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
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveChanges,
            child: Text(
              'حفظ',
              style: GoogleFonts.cairo(
                color: Theme.of(context).appBarTheme.foregroundColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // صورة الملف الشخصي
              _buildProfileImage(),
              
              const SizedBox(height: 32),
              
              // معلومات الحساب
              _buildSectionTitle('المعلومات الشخصية'),
              _buildPersonalInfoSection(),
              
              const SizedBox(height: 24),
              
              // معلومات الاتصال
              _buildSectionTitle('معلومات الاتصال'),
              _buildContactInfoSection(),
              
              const SizedBox(height: 24),
              
              // العنوان
              _buildSectionTitle('العنوان'),
              _buildAddressSection(),
              
              const SizedBox(height: 32),
              
              // أزرار الإجراءات
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return Center(
      child: Stack(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).colorScheme.secondary,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).primaryColor.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: const Icon(
              Icons.person,
              size: 60,
              color: Colors.white,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: IconButton(
                onPressed: _changeProfileImage,
                icon: const Icon(
                  Icons.camera_alt,
                  size: 18,
                  color: Colors.white,
                ),
                padding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
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

  Widget _buildPersonalInfoSection() {
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
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextFormField(
            controller: _nameController,
            textAlign: TextAlign.right,
            style: GoogleFonts.cairo(),
            decoration: InputDecoration(
              labelText: 'الاسم الكامل',
              labelStyle: GoogleFonts.cairo(),
              prefixIcon: const Icon(Icons.person_outline),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'يرجى إدخال الاسم';
              }
              if (value.length < 2) {
                return 'الاسم يجب أن يكون حرفين على الأقل';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfoSection() {
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
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextFormField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            textAlign: TextAlign.right,
            style: GoogleFonts.cairo(),
            decoration: InputDecoration(
              labelText: 'رقم الهاتف',
              labelStyle: GoogleFonts.cairo(),
              prefixIcon: const Icon(Icons.phone_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'يرجى إدخال رقم الهاتف';
              }
              if (!RegExp(r'^(71|78|73|70|77)[0-9]{7}$').hasMatch(value.replaceAll(' ', '').replaceAll('-', ''))) {
                return 'رقم الهاتف غير صحيح (مثال: 712345678)';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            textAlign: TextAlign.right,
            style: GoogleFonts.cairo(),
            decoration: InputDecoration(
              labelText: 'البريد الإلكتروني (اختياري)',
              labelStyle: GoogleFonts.cairo(),
              prefixIcon: const Icon(Icons.email_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
              ),
            ),
            validator: (value) {
              if (value != null && value.isNotEmpty) {
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                  return 'البريد الإلكتروني غير صحيح';
                }
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAddressSection() {
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
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextFormField(
            controller: _addressController,
            textAlign: TextAlign.right,
            style: GoogleFonts.cairo(),
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'العنوان الكامل',
              labelStyle: GoogleFonts.cairo(),
              prefixIcon: const Icon(Icons.location_on_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'يرجى إدخال العنوان';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _getCurrentLocation,
            icon: const Icon(Icons.my_location),
            label: Text(
              'تحديد الموقع الحالي',
              style: GoogleFonts.cairo(),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
              foregroundColor: Theme.of(context).primaryColor,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        // زر حفظ التغييرات
        Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).colorScheme.secondary,
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).primaryColor.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: _isLoading ? null : _saveChanges,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: _isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : Text(
                    'حفظ التغييرات',
                    style: GoogleFonts.cairo(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // زر تغيير كلمة المرور
        OutlinedButton.icon(
          onPressed: _changePassword,
          icon: const Icon(Icons.lock_outline),
          label: Text(
            'تغيير كلمة المرور',
            style: GoogleFonts.cairo(),
          ),
          style: OutlinedButton.styleFrom(
            foregroundColor: Theme.of(context).primaryColor,
            side: BorderSide(color: Theme.of(context).primaryColor),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            minimumSize: const Size(double.infinity, 48),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // زر حذف الحساب
        OutlinedButton.icon(
          onPressed: _deleteAccount,
          icon: const Icon(Icons.delete_outline),
          label: Text(
            'حذف الحساب',
            style: GoogleFonts.cairo(),
          ),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.red,
            side: const BorderSide(color: Colors.red),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            minimumSize: const Size(double.infinity, 48),
          ),
        ),
      ],
    );
  }

  void _changeProfileImage() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: Text('التقاط صورة', style: GoogleFonts.cairo()),
              onTap: () {
                Navigator.pop(context);
                _showMessage('تم التقاط الصورة');
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: Text('اختيار من المعرض', style: GoogleFonts.cairo()),
              onTap: () {
                Navigator.pop(context);
                _showMessage('تم اختيار الصورة');
              },
            ),
          ],
        ),
      ),
    );
  }

  void _getCurrentLocation() {
    _showMessage('جاري تحديد الموقع...');
    // محاكاة تحديد الموقع
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _addressController.text = 'شارع الزبيري، حي السبعين، صنعاء - تم تحديده تلقائياً';
      });
      _showMessage('تم تحديد الموقع بنجاح');
    });
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // محاكاة حفظ البيانات
      await Future.delayed(const Duration(seconds: 2));
      
      if (mounted) {
        _showMessage('تم حفظ التغييرات بنجاح');
        Navigator.pop(context);
      }
    } catch (e) {
      _showMessage('حدث خطأ أثناء حفظ التغييرات');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _changePassword() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('تغيير كلمة المرور', style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
        content: Text('سيتم إرسال رابط تغيير كلمة المرور إلى رقم هاتفك', style: GoogleFonts.cairo()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء', style: GoogleFonts.cairo()),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showMessage('تم إرسال رابط تغيير كلمة المرور');
            },
            child: Text('إرسال', style: GoogleFonts.cairo()),
          ),
        ],
      ),
    );
  }

  void _deleteAccount() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('حذف الحساب', style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
        content: Text('هل أنت متأكد من رغبتك في حذف الحساب؟ هذا الإجراء لا يمكن التراجع عنه.', style: GoogleFonts.cairo()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء', style: GoogleFonts.cairo()),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showMessage('تم حذف الحساب');
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('حذف', style: GoogleFonts.cairo(color: Colors.white)),
          ),
        ],
      ),
    );
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

