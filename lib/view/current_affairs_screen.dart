import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/current_affairs_controller.dart';
import '../model/current_affairs_model.dart';
import 'package:google_fonts/google_fonts.dart';

class CurrentAffairsScreen extends StatelessWidget {
  final String type;
  
  const CurrentAffairsScreen({
    Key? key,
    required this.type,
  }) : super(key: key);

  String get screenTitle {
    switch (type) {
      case 'international':
        return 'International Affairs';
      case 'india':
        return 'Indian Affairs';
      case 'history':
        return 'Today in History';
      default:
        return 'Current Affairs';
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CurrentAffairsController());

    return Scaffold(
      appBar: AppBar(
        title: Text(
          screenTitle,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (controller.error.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  controller.error.value,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => controller.fetchCurrentAffairs(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (controller.currentAffairs.isEmpty) {
          return const Center(
            child: Text('No historical events available for today'),
          );
        }

        return ListView.builder(
          itemCount: controller.currentAffairs.length,
          padding: const EdgeInsets.all(16),
          itemBuilder: (context, index) {
            final affair = controller.currentAffairs[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      affair.title,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      affair.description,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      affair.date,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
