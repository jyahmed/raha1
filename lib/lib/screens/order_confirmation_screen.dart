import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/cart_provider.dart';
import '../models/cart_item.dart';

class OrderConfirmationScreen extends StatefulWidget {
  const OrderConfirmationScreen({super.key});

  @override
  State<OrderConfirmationScreen> createState() =>
      _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen> {
  String selectedPaymentMethod = 'cash_on_delivery';
  String selectedDeliveryTime = 'now';
  String selectedDigitalWallet = ''; // إضافة متغير للمحفظة المختارة
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  double deliveryFee = 5.0;
  double serviceFee = 3.0;

  @override
  void initState() {
    super.initState();
    _addressController.text = 'اختر العنوان...';
  }

  @override
  void dispose() {
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _showDigitalWalletDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'اختر المحفظة الإلكترونية',
            style: GoogleFonts.cairo(
              fontWeight: FontWeight.bold,
              color: const Color(0xFF153A6B),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildWalletOption('Apple Pay', 'apple_pay', Icons.phone_iphone),
              _buildWalletOption('Google Pay', 'google_pay', Icons.android),
              _buildWalletOption(
                  'Samsung Pay', 'samsung_pay', Icons.smartphone),
              _buildWalletOption('STC Pay', 'stc_pay', Icons.payment),
              _buildWalletOption('مدى', 'mada', Icons.credit_card),
              _buildWalletOption('فيزا', 'visa', Icons.credit_card),
              _buildWalletOption('ماستركارد', 'mastercard', Icons.credit_card),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'إلغاء',
                style: GoogleFonts.cairo(color: Colors.grey),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildWalletOption(String title, String value, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF153A6B)),
      title: Text(
        title,
        style: GoogleFonts.cairo(),
      ),
      onTap: () {
        setState(() {
          selectedDigitalWallet = value;
          selectedPaymentMethod = 'digital_wallet';
        });
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'تم اختيار $title',
              style: GoogleFonts.cairo(),
            ),
            backgroundColor: const Color(0xFF153A6B),
          ),
        );
      },
    );
  }

  String _getWalletDisplayName(String walletValue) {
    switch (walletValue) {
      case 'apple_pay':
        return 'Apple Pay';
      case 'google_pay':
        return 'Google Pay';
      case 'samsung_pay':
        return 'Samsung Pay';
      case 'stc_pay':
        return 'STC Pay';
      case 'mada':
        return 'مدى';
      case 'visa':
        return 'فيزا';
      case 'mastercard':
        return 'ماستركارد';
      default:
        return 'غير محدد';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          'تأكيد الطلب',
          style: GoogleFonts.cairo(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF153A6B),
          ),
        ),
        backgroundColor: const Color(0xFF7EE6F3),
        foregroundColor: const Color(0xFF153A6B),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF153A6B)),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Color(0xFF153A6B)),
            onPressed: () {
              final cart = Provider.of<CartProvider>(context, listen: false);

              if (cart.isEmpty) {
                // التحقق من أن السلة فارغة
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      ' السلة فارغة بالفعل! لا يوجد عناصر لحذفها.',
                      style: GoogleFonts.cairo(),
                      textAlign: TextAlign.center,
                    ),
                    backgroundColor: Colors.orange, // لون مختلف للتنبيه
                  ),
                );
              } else {
                cart.clearCart();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    duration: const Duration(seconds: 2),
                    key: const ValueKey('cart-clear-snackbar'),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    behavior: SnackBarBehavior.floating,
                    margin: const EdgeInsets.all(16),
                    content: Text(
                      'تم حذف السلة',
                      style: GoogleFonts.cairo(),
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
                // العودة إلى الشاشة السابقة بعد الحذف (اختياري)
                // Navigator.pop(context);
              }
            },
          ),
        ],
      ),
      body: Consumer<CartProvider>(
        builder: (context, cart, child) {
          if (cart.isEmpty) {
            return const Center(
              child: Text('السلة فارغة'),
            );
          }

          final subtotal = cart.totalAmount;
          final total = subtotal + serviceFee;

          return SingleChildScrollView(
            child: Column(
              children: [
                // قسم العنوان
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: Color(0xFF153A6B),
                        child: Icon(Icons.location_on, color: Colors.white),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'اختر العنوان...',
                              style: GoogleFonts.cairo(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'لا يوجد عنوان محدد',
                              style: GoogleFonts.cairo(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // إضافة وظيفة اختيار العنوان
                        },
                        child: Text(
                          'إضافة',
                          style: GoogleFonts.cairo(
                            color: const Color(0xFF7EE6F3),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // قسم ملاحظات الطلب
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: Color(0xFF153A6B),
                        child: Icon(Icons.note_add, color: Colors.white),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ملاحظات الطلب',
                              style: GoogleFonts.cairo(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'لا يوجد ملاحظة',
                              style: GoogleFonts.cairo(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // إضافة وظيفة إضافة ملاحظات
                        },
                        child: Text(
                          'إضافة',
                          style: GoogleFonts.cairo(
                            color: const Color(0xFF7EE6F3),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // قسم تحديد وقت الطلب
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(
                            backgroundColor: Color(0xFF153A6B),
                            child: Icon(Icons.access_time, color: Colors.white),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'تحديد وقت الطلب',
                            style: GoogleFonts.cairo(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: selectedDeliveryTime == 'now'
                                    ? const Color(0xFF153A6B)
                                    : Colors.grey[200],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    selectedDeliveryTime = 'now';
                                  });
                                },
                                child: Text(
                                  'الآن',
                                  style: GoogleFonts.cairo(
                                    color: selectedDeliveryTime == 'now'
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: selectedDeliveryTime == 'later'
                                    ? const Color(0xFF153A6B)
                                    : Colors.grey[200],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    selectedDeliveryTime = 'later';
                                  });
                                },
                                child: Text(
                                  'في وقت لاحق',
                                  style: GoogleFonts.cairo(
                                    color: selectedDeliveryTime == 'later'
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (selectedDeliveryTime == 'later')
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Text(
                            'وقت تنفيذ الطلب',
                            style: GoogleFonts.cairo(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // قسم طرق الدفع
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(
                            backgroundColor: Color(0xFF153A6B),
                            child: Icon(Icons.payment, color: Colors.white),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'الدفع (الدفع عند الاستلام)',
                            style: GoogleFonts.cairo(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // الدفع عند الاستلام
                      RadioListTile<String>(
                        title: Text(
                          'الدفع عند الاستلام',
                          style: GoogleFonts.cairo(),
                        ),
                        value: 'cash_on_delivery',
                        groupValue: selectedPaymentMethod,
                        onChanged: (value) {
                          setState(() {
                            selectedPaymentMethod = value!;
                          });
                        },
                        activeColor: const Color(0xFF153A6B),
                      ),

                      // المحفظة الإلكترونية
                      ListTile(
                        leading: Radio<String>(
                          value: 'digital_wallet',
                          groupValue: selectedPaymentMethod,
                          onChanged: (value) {
                            _showDigitalWalletDialog();
                          },
                          activeColor: const Color(0xFF153A6B),
                        ),
                        title: Text(
                          selectedDigitalWallet.isEmpty
                              ? 'الدفع باستخدام المحفظة الإلكترونية'
                              : 'المحفظة المختارة: ${_getWalletDisplayName(selectedDigitalWallet)}',
                          style: GoogleFonts.cairo(),
                        ),
                        onTap: () {
                          _showDigitalWalletDialog();
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // قسم الإجمالي والتوصيل
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${subtotal.toStringAsFixed(0)} ر.س',
                            style: GoogleFonts.cairo(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'الإجمالي',
                            style: GoogleFonts.cairo(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${serviceFee.toStringAsFixed(0)} ر.س',
                            style: GoogleFonts.cairo(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            'رسوم التوصيل',
                            style: GoogleFonts.cairo(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${total.toStringAsFixed(0)} ر.ي',
                            style: GoogleFonts.cairo(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFE53E3E),
                            ),
                          ),
                          Text(
                            'الإجمالي الكلي',
                            style: GoogleFonts.cairo(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // قائمة المنتجات
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: const BoxDecoration(
                          color: Color(0xFFF8F9FA),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'الإجمالي',
                              style: GoogleFonts.cairo(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              'الكمية',
                              style: GoogleFonts.cairo(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              'السعر',
                              style: GoogleFonts.cairo(
                                fontSize: 17,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              'المنتج',
                              style: GoogleFonts.cairo(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ...cart.items.map((item) => _buildOrderItem(item)),
                    ],
                  ),
                ),

                const SizedBox(height: 100), // مساحة للزر السفلي
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF7EE6F3),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 6,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Consumer<CartProvider>(
          // أضف Consumer هنا لتتمكن من الوصول إلى cart
          builder: (context, cart, child) {
            return Row(
              children: [
                // زر تعديل السلة
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (cart.isEmpty) {
                        // ← استبدل isCartEmpty بـ cart.isEmpty
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'السلة فارغة، الرجاء إضافة منتجات أولاً',
                              style: GoogleFonts.cairo(),
                              textAlign: TextAlign.center,
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                      } else {
                        Navigator.pushNamed(context, '/cart');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF153A6B),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'تعديل السلة',
                      style: GoogleFonts.cairo(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // زر تأكيد الطلب
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (cart.isEmpty) {
                        // ← هنا بالفعل تستخدم cart.isEmpty بشكل صحيح
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'السلة فارغة، الرجاء إضافة منتجات أولاً',
                              style: GoogleFonts.cairo(),
                              textAlign: TextAlign.center,
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                      } else {
                        _confirmOrder(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF153A6B),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'تأكيد الطلب',
                      style: GoogleFonts.cairo(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildOrderItem(CartItem item) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFF0F0F0), width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${item.totalPrice.toStringAsFixed(0)} ر.س',
            style: GoogleFonts.cairo(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            item.quantity.toString(),
            style: GoogleFonts.cairo(
              fontSize: 14,
            ),
          ),
          Text(
            '${item.product.finalPrice.toStringAsFixed(0)} ر.س',
            style: GoogleFonts.cairo(
              fontSize: 14,
            ),
          ),
          Expanded(
            child: Text(
              item.product.name,
              style: GoogleFonts.cairo(
                fontSize: 14,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  void _confirmOrder(BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'تأكيد الطلب',
          style: GoogleFonts.cairo(),
        ),
        content: Text(
          'هل أنت متأكد من تأكيد هذا الطلب؟',
          style: GoogleFonts.cairo(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'إلغاء',
              style: GoogleFonts.cairo(),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              _confirmOrder(context); // إغلاق dialog التأكيد

              // عرض مؤشر تحميل
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => const Center(
                  child: CircularProgressIndicator(),
                ),
              );

              // محاكاة عملية تأكيد الطلب (استبدلها بالمنطق الحقيقي)
              await Future.delayed(const Duration(seconds: 2));

              // تفريغ السلة بعد التأكيد
              cart.clearCart();

              // إغلاق مؤشر التحميل
              Navigator.pop(context);
              Navigator.popUntil(context, ModalRoute.withName('/'));
              Navigator.pushNamed(context, '/orders');
              // إظهار رسالة نجاح
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'تم تأكيد الطلب بنجاح!',
                    style: GoogleFonts.cairo(),
                  ),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: Text(
              'تأكيد',
              style: GoogleFonts.cairo(),
            ),
          ),
        ],
      ),
    );
  }
}
