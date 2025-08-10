import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFF7EE6F3),
        appBar: AppBar(
          title: Text(
            'عن التطبيق',
            style: GoogleFonts.cairo(
              color: const Color(0xFF153A6B),
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: const Color(0xFF7EE6F3),
          elevation: 0,
          iconTheme: const IconThemeData(color: Color(0xFF153A6B)),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Image.asset('assets/logo1.png', height: 150)),
              const SizedBox(height: 20),
              Text(
                'تطبيق توصيل راحة',
                style: GoogleFonts.cairo(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF153A6B),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'الإصدار 1.0.0',
                style: GoogleFonts.cairo(color: Colors.grey[700]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Text(
                'وصف التطبيق:',
                style: GoogleFonts.cairo(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF153A6B),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'تطبيق توصيل راحة هو الحل الأمثل لطلب جميع احتياجاتك من متاجر ومطاعم قريبة منك،'
                ' حيث يمكنك تصفح المتاجر، طلب المنتجات، متابعة طلباتك، والاستفادة من العروض الحصرية.'
                ' نسعى لتوفير تجربة تسوق سلسة وسريعة مع أفضل خدمة توصيل إلى باب منزلك.',
                style: GoogleFonts.cairo(fontSize: 16, height: 1.5),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 30),
              Text(
                'مميزات التطبيق:',
                style: GoogleFonts.cairo(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF153A6B),
                ),
              ),
              const SizedBox(height: 10),
              _buildFeatureItem('واجهة سهلة الاستخدام'),
              _buildFeatureItem('تتبع الطلبات في الوقت الحقيقي'),
              _buildFeatureItem('دفع آمن عبر التطبيق'),
              _buildFeatureItem('عروض وكوبونات حصرية'),
              _buildFeatureItem('دعم فني على مدار الساعة'),
              const SizedBox(height: 30),
              Center(
                child: Text(
                  'جميع الحقوق محفوظة © 2023',
                  style: GoogleFonts.cairo(color: Colors.grey[700]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, color: Color(0xFF153A6B), size: 20),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: GoogleFonts.cairo(fontSize: 16))),
        ],
      ),
    );
  }
}
