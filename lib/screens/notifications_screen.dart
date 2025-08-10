import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الإشعارات'),
        backgroundColor: const Color(0xFF7EE6F3),
        foregroundColor: const Color(0xFF153A6B),
      ),
      body: const Center(
        child: Text('قائمة الإشعارات ستظهر هنا'),
      ),
    );
  }
}// TODO Implement this library.