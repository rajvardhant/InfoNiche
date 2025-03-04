import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news_app/model/categories_new_model.dart';
import 'package:news_app/utils/string_utils.dart';

import '../view_model/news_view_model.dart';
import 'home_screen.dart';
import 'news_detail_screen.dart';

const spinKit2 = SpinKitFadingCircle(color: Colors.amber, size: 50);

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  NewsViewModel newsViewModel = NewsViewModel();

  final format = DateFormat('MMM dd, yyyy');

  String categoryName = 'General';

  List<String> categoriesList = [
    'General',
    'Sports',
    'Bitcoin',
    'Health',
    'Business',
    'Technology',
    'Entertainment',
    'Science',
  ];

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 1;
    final width = MediaQuery.of(context).size.width * 1;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Categories',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
          ),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categoriesList.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      categoryName = categoriesList[index];
                      setState(() {});
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Container(
                        decoration: BoxDecoration(
                          color: categoryName == categoriesList[index]
                              ? Colors.blue
                              : Theme.of(context).brightness == Brightness.dark
                                  ? Colors.grey[700]
                                  : Colors.grey[300],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Center(
                            child: Text(
                              categoriesList[index].toString(),
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: categoryName == categoriesList[index]
                                    ? Colors.white
                                    : Theme.of(context).brightness == Brightness.dark
                                        ? Colors.white
                                        : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<categoriesNewsModel>(
                future: newsViewModel.fetchCategoriesNewsApi(categoryName),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.articles!.length,
                      itemBuilder: (context, index) {
                        DateTime dateTime = DateTime.parse(
                          snapshot.data!.articles![index].publishedAt.toString(),
                        );
                        return InkWell(
                          onTap: () {
                            Get.to(() => NewsDetailScreen(
                              newImage: snapshot.data!.articles![index].urlToImage.toString(),
                              // newsImage: snapshot.data!.articles![index].urlToImage.toString(),
                              newsTitle: snapshot.data!.articles![index].title.toString(),
                              // newsDate: format.format(dateTime),
                              newsDate: snapshot.data!.articles![index].publishedAt.toString(),
                              author: snapshot.data!.articles![index].author.toString(),
                              description: snapshot.data!.articles![index].description.toString(),
                              content: snapshot.data!.articles![index].content.toString(),
                              source: snapshot.data!.articles![index].source!.name.toString(),
                            ));
                          },
                          child: Card(
                            elevation: 5,
                            margin: const EdgeInsets.only(bottom: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: CachedNetworkImage(
                                      imageUrl: snapshot.data!.articles![index].urlToImage.toString(),
                                      fit: BoxFit.cover,
                                      height: height * 0.25,
                                      width: double.infinity,
                                      placeholder: (context, url) => spinKit2,
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error_outline, color: Colors.red),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    snapshot.data!.articles![index].title.toString(),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    snapshot.data!.articles![index].description.toString(),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: Theme.of(context).brightness == Brightness.dark ? Colors.white70 : Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          StringUtils.formatAuthorName(
                                            snapshot.data!.articles![index].author ?? 'Unknown',
                                          ),
                                          style: GoogleFonts.poppins(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          format.format(DateTime.parse(
                                            snapshot.data!.articles![index].publishedAt.toString(),
                                          )),
                                          style: GoogleFonts.poppins(
                                            fontSize: 12,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error loading news',
                        style: GoogleFonts.poppins(
                          color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                        ),
                      ),
                    );
                  }
                  return const Center(child: spinKit2);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
