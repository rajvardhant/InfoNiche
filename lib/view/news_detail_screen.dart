import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import '../controller/bookmark_controller.dart';

class NewsDetailScreen extends StatefulWidget {
  final String newImage;
  final String newsTitle;
  final String newsDate;
  final String author;
  final String description;
  final String content;
  final String source;

  const NewsDetailScreen({
    super.key,
    required this.newImage,
    required this.newsTitle,
    required this.newsDate,
    required this.author,
    required this.description,
    required this.content,
    required this.source,
  });

  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  final format = DateFormat('MMM dd, yyyy');
  bool isLiked = false;

  Future<void> _shareNews() async {
    try {
      final String shareText = '''
${widget.newsTitle}

${widget.description}

Source: ${widget.source}
''';
      await Share.share(shareText);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Unable to share the news. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 1;
    final bookmarkController = Get.put(BookmarkController());
    DateTime dateTime = DateTime.parse(widget.newsDate);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isLiked ? Icons.favorite : Icons.favorite_border,
              color: isLiked ? Colors.red : Colors.grey,
            ),
            onPressed: () {
              setState(() {
                isLiked = !isLiked;
              });
              Get.snackbar(
                isLiked ? 'Liked!' : 'Unliked',
                isLiked ? 'Added to your favorites' : 'Removed from favorites',
                snackPosition: SnackPosition.BOTTOM,
                duration: Duration(seconds: 2),
              );
            },
          ),
          Obx(() {
            final isBookmarked = bookmarkController.isBookmarked(widget.newsTitle);
            return IconButton(
              icon: Icon(
                isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                color: isBookmarked ? Colors.blue : Colors.grey,
              ),
              onPressed: () {
                final newsItem = {
                  'newImage': widget.newImage,
                  'newsTitle': widget.newsTitle,
                  'newsDate': widget.newsDate,
                  'author': widget.author,
                  'description': widget.description,
                  'content': widget.content,
                  'source': widget.source,
                };
                bookmarkController.toggleBookmark(newsItem);
                Get.snackbar(
                  isBookmarked ? 'Removed from Bookmarks' : 'Added to Bookmarks',
                  isBookmarked ? 'Article removed from your bookmarks' : 'Article saved to your bookmarks',
                  snackPosition: SnackPosition.BOTTOM,
                  duration: Duration(seconds: 2),
                );
              },
            );
          }),
          IconButton(
            icon: Icon(Icons.share, color: Colors.grey),
            onPressed: _shareNews,
          ),
          SizedBox(width: 10),
        ],
      ),
      body: Stack(
        children: [
          Container(
            height: height * .45,
            child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(40),
                ),
                child: CachedNetworkImage(
                  imageUrl: widget.newImage,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(),
                  ),
                )),
          ),
          Container(
            height: height * .6,
            margin: EdgeInsets.only(top: height * .4),
            padding: EdgeInsets.only(top: 20, right: 20, left: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(40),
            ),
            ),
            child: ListView(
              children: [
                Text(
                  widget.newsTitle,
                  style: GoogleFonts.poppins(
                      fontSize: 20,
                      color: Colors.black87,
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: height * .02,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: Text(
                        widget.source,
                        style: GoogleFonts.poppins(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    Text(
                      format.format(dateTime),
                      style: GoogleFonts.poppins(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                SizedBox(height: height * .03,),
                Text(widget.description,style: GoogleFonts.poppins(fontSize: 16,color: Colors.black,fontWeight: FontWeight.w500),)
              ],
            ),
          )
        ],
      ),
    );
  }
}
