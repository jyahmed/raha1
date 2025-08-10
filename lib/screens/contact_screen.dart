import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        backgroundColor: const Color(0xFF7EE6F3),
        appBar: AppBar(
          title: Text(
            'تواصل معنا',
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
            children: [
              const SizedBox(height: 20),
              Image.asset('assets/contact.', height: 150),
              const SizedBox(height: 30),
              Text(
                'نحن هنا لمساعدتك!',
                style: GoogleFonts.cairo(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF153A6B),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'يمكنك التواصل معنا عبر أي من الطرق التالية',
                style: GoogleFonts.cairo(fontSize: 16, color: Colors.grey[700]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              _buildContactCard(
                icon: Icons.phone,
                title: 'خدمة العملاء',
                subtitle: '0123456789',
                color: Colors.green,
                onTap: () async {
                  const phoneNumber = 'tel:+966123456789';
                  if (await canLaunch(phoneNumber)) {
                    await launch(phoneNumber);
                  }
                },
              ),
              const SizedBox(height: 20),
              _buildContactCard(
                icon: Icons.email,
                title: 'البريد الإلكتروني',
                subtitle: 'support@tawsilraha.com',
                color: Colors.blue,
                onTap: () async {
                  const email = 'mailto:support@tawsilraha.com';
                  if (await canLaunch(email)) {
                    await launch(email);
                  }
                },
              ),
              const SizedBox(height: 20),
              _buildContactCard(
                icon: Icons.chat,
                title: 'واتساب',
                subtitle: 'اضغط للتواصل عبر واتساب',
                color: Colors.greenAccent,
                onTap: () async {
                  const whatsappUrl = 'https://wa.me/966123456789';
                  if (await canLaunch(whatsappUrl)) {
                    await launch(whatsappUrl);
                  }
                },
              ),
              const SizedBox(height: 20),
              _buildContactCard(
                icon: Icons.facebook,
                title: 'فيسبوك',
                subtitle: 'facebook.com/tawsilraha',
                color: Colors.blue[800]!,
                onTap: () async {
                  const facebookUrl = 'https://facebook.com/tawsilraha';
                  if (await canLaunch(facebookUrl)) {
                    await launch(facebookUrl);
                  }
                },
              ),
              const SizedBox(height: 20),
              _buildContactCard(
                icon: Icons.location_on,
                title: 'العنوان',
                subtitle: 'المملكة العربية السعودية - الرياض',
                color: Colors.red,
                onTap: () async {
                  const mapUrl = 'https://goo.gl/maps/XXXXXXXXXXXXXX';
                  if (await canLaunch(mapUrl)) {
                    await launch(mapUrl);
                  }
                },
              ),
              const SizedBox(height: 30),
              Text(
                'أو زورنا في مقرنا الرئيسي',
                style: GoogleFonts.cairo(fontSize: 16, color: Colors.grey[700]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.cairo(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF153A6B),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: GoogleFonts.cairo(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
