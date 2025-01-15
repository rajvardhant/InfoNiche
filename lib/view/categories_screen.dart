import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news_app/model/categories_new_model.dart';

import '../view_model/news_view_model.dart';
import 'home_screen.dart';
import 'news_detail_screen.dart';

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
    final height = MediaQuery.sizeOf(context).height * 1;
    final widht = MediaQuery.sizeOf(context).width * 1;
    return Scaffold(
      appBar: AppBar(),
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
                                  : Colors.grey,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: Center(
                                child: Text(
                                  categoriesList[index].toString(),
                                  style: GoogleFonts.poppins(
                                      fontSize: 13, color: Colors.white),
                                ),
                              ),
                            ),
                          )));
                },
              ),
            ),
            SizedBox(height: 20,),
            Expanded(
              child: FutureBuilder<categoriesNewsModel>(
                future: newsViewModel.fetchCategoriesNewsApi(categoryName),
                builder: (BuildContext context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: SpinKitSpinningLines(size: 50, color: Colors.blue),
                    );
                  } else {
                    return ListView.builder(
                        itemCount: snapshot.data!.articles!.length,
                        scrollDirection: Axis.vertical ,
                        itemBuilder: (context, index) {
                          DateTime dateTime = DateTime.parse(snapshot
                              .data!.articles![index].publishedAt
                              .toString());
                          return InkWell(
                            onTap: () {
                              Get.to(NewsDetailScreen(
                                newImage: snapshot.data!.articles![index].urlToImage.toString(),
                                newsTitle: snapshot.data!.articles![index].title.toString(),
                                newsDate: snapshot.data!.articles![index].publishedAt.toString(),
                                author: snapshot.data!.articles![index].author.toString(),
                                description: snapshot.data!.articles![index].description.toString(),
                                content: snapshot.data!.articles![index].content.toString(),
                                source: snapshot.data!.articles![index].source!.name.toString(),
                              ));
                            },
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 15),
                              child: Row(children: [
                                ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: CachedNetworkImage(
                                          imageUrl: snapshot
                                              .data!.articles![index].urlToImage
                                              .toString(),
                                          fit: BoxFit.cover,
                                          height: height * .18,
                                          width: widht* .3,
                                          placeholder: (context, url) => Container(
                                            child: spinKit2,
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Icon(
                                            Icons.error_outline,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                              Expanded(

                                child: Container(
                                  height:height * .18,
                                  padding: EdgeInsets.only(left: 15),
                                  child: Column(
                                    children: [
                                      Text( snapshot
                                              .data!.articles![index].title
                                              .toString(),
                                              style: GoogleFonts.poppins(fontSize: 15,
                                              color: Colors.black,
                                              fontWeight:FontWeight.w600
                                              ),
                                              ),
                                              Spacer(),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                            Text( snapshot
                                              .data!.articles![index].source!.name
                                              .toString(),
                                              style: GoogleFonts.poppins(fontSize: 12,
                                              color: Colors.black,
                                              fontWeight:FontWeight.w500
                                              ),
                                              ),
                                              Text( format.format(dateTime),
                                              style: GoogleFonts.poppins(fontSize: 12,
                                              color: Colors.black,
                                              fontWeight:FontWeight.w500
                                              ),
                                              ),
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              )
                              ],
                              ),
                            ),
                          );
                        });
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
