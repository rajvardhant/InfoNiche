import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:news_app/view_model/news_view_model.dart';
import 'package:news_app/view/news_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final NewsViewModel _newsViewModel = NewsViewModel();
  final format = DateFormat('MMM dd, yyyy');
  String _searchQuery = '';
  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 1;
    final width = MediaQuery.of(context).size.width * 1;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Search News',
          style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w700),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search for news...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
              onSubmitted: (value) {
                setState(() {
                  _searchQuery = value;
                  _isSearching = true;
                });
              },
            ),
          ),
          Expanded(
            child: _searchQuery.isEmpty
                ? Center(
                    child: Text(
                      'Search for news articles',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  )
                : FutureBuilder(
                    future: _newsViewModel.searchNews(_searchQuery),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: SpinKitSpinningLines(
                            size: 50,
                            color: Colors.blue,
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            'Error: ${snapshot.error}',
                            style: TextStyle(color: Colors.red),
                          ),
                        );
                      } else if (!snapshot.hasData ||
                          snapshot.data!.articles == null ||
                          snapshot.data!.articles!.isEmpty) {
                        return Center(
                          child: Text(
                            'No results found',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        );
                      }

                        return ListView.builder(
                        itemCount: snapshot.data!.articles!.length,
                        itemBuilder: (context, index) {
                          final article = snapshot.data!.articles![index];
                          DateTime dateTime =
                            DateTime.parse(article.publishedAt.toString());
                          bool isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

                          return InkWell(
                          onTap: () {
                            Get.to(NewsDetailScreen(
                            newImage: article.urlToImage.toString(),
                            newsTitle: article.title.toString(),
                            newsDate: article.publishedAt.toString(),
                            author: article.author.toString(),
                            description: article.description.toString(),
                            content: article.content.toString(),
                            source: article.source!.name.toString(),
                            ));
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                            child: Card(
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                              ClipRRect(
                                borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                bottomLeft: Radius.circular(12),
                                ),
                                child: CachedNetworkImage(
                                imageUrl: article.urlToImage.toString(),
                                fit: BoxFit.cover,
                                height: height * .18,
                                width: width * .3,
                                placeholder: (context, url) => Container(
                                  child: SpinKitFadingCircle(
                                  color: Colors.amber,
                                  size: 50,
                                  ),
                                ),
                                errorWidget: (context, url, error) => Icon(
                                  Icons.error_outline,
                                  color: Colors.red,
                                ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                  children: [
                                  Text(
                                    article.title.toString(),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.poppins(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: isDarkMode ? Colors.white : Colors.black,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    article.description.toString(),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: isDarkMode ? Colors.white70 : Colors.grey[600],
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                    children: [
                                    Text(
                                      article.source!.name.toString(),
                                      style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: isDarkMode ? Colors.white : Colors.black,
                                      ),
                                    ),
                                    Text(
                                      format.format(dateTime),
                                      style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: isDarkMode ? Colors.white : Colors.black,
                                      ),
                                    ),
                                    ],
                                  ),
                                  ],
                                ),
                                ),
                              ),
                              ],
                            ),
                            ),
                          ),
                          );
                        },
                        );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
