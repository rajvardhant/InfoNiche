import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StaticPage extends StatelessWidget {
  final String title;
  final String content;

  const StaticPage({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w700),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Text(
          content,
          style: GoogleFonts.poppins(
            fontSize: 16,
            height: 1.6,
          ),
        ),
      ),
    );
  }
}
