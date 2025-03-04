import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class TwitterFeedScreen extends StatelessWidget {
  const TwitterFeedScreen({Key? key}) : super(key: key);

  Future<void> _launchTwitterProfile(String handle) async {
    final Uri url = Uri.parse('https://twitter.com/$handle');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar(
        'Error',
        'Could not open Twitter profile',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Widget _buildNewsSourceCard(BuildContext context, String name, String handle, String description) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _launchTwitterProfile(handle),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.flutter_dash, 
                    color: isDark ? Colors.white : Colors.blue,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '@$handle',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                description,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: isDark ? Colors.grey[300] : Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'News Sources on Twitter',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            _buildNewsSourceCard(
              context,
              'BBC News',
              'BBCNews',
              'Breaking news, features and analysis from the BBC News team.',
            ),
            _buildNewsSourceCard(
              context,
              'CNN',
              'CNN',
              'Breaking news from around the world. Join the conversation.',
            ),
            _buildNewsSourceCard(
              context,
              'Reuters',
              'Reuters',
              'Top and breaking news, pictures, and videos from Reuters.',
            ),
            _buildNewsSourceCard(
              context,
              'The New York Times',
              'nytimes',
              'News, investigations, and opinion from The New York Times.',
            ),
            _buildNewsSourceCard(
              context,
              'Al Jazeera',
              'AJEnglish',
              'Breaking news, live coverage and documentaries from around the world.',
            ),
            _buildNewsSourceCard(
              context,
              'Bloomberg',
              'business',
              'The first word in business news. Breaking news on the economy, markets, and technology.',
            ),
          ],
        ),
      ),
    );
  }
}
