import 'package:flutter/material.dart';

class EnquiryScreen extends StatelessWidget {
  const EnquiryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Enquiry"),
      ),
      body: const Center(
        child: Text(
          "Enquiry Module Coming Soon",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}