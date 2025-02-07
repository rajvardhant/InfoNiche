import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:intl/intl.dart';
import 'package:news_app/model/news_channel_headlines_modle.dart';
import 'package:news_app/view/categories_screen.dart';
import 'package:news_app/view/news_detail_screen.dart';
import 'package:news_app/view_model/news_view_model.dart';

import '../model/categories_new_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum FilterList { bbcNews, bloomberg, independent, retuers, cnn, argaam }

class _HomeScreenState extends State<HomeScreen> {
  NewsViewModel newsViewModel = NewsViewModel();
  FilterList? selectedMenu;
  final format = DateFormat('MMM dd, yyyy');

  String name = 'bbc-news';

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 1;
    final width = MediaQuery.sizeOf(context).width * 1;

    return Scaffold(
        appBar: AppBar(

          leading: IconButton(
            onPressed: () {Get.to(CategoriesScreen());},
            icon: Icon(Icons.drag_indicator, color: Colors.black),
            // Image.asset(
            //   'images/news1.png',
            //   height: 30,
            //   width: 30,
            // ),
          ),
          title: Text(
            'InfoNiche',
            style:
                GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w700),
          ),
          actions: [
            PopupMenuButton<FilterList>(
                initialValue: selectedMenu,
                icon: Icon(
                  Icons.more_vert,
                  color: Colors.black,
                ),
                onSelected: (FilterList item) {
                  setState(() {
                    selectedMenu = item;
                    if (item == FilterList.bbcNews) {
                      name = 'bbc-news';
                    } else if (item == FilterList.bloomberg) {
                      name = 'bloomberg';
                    } else if (item == FilterList.argaam) {
                      name = 'al-jazeera-english';
                    }
                    else if (item == FilterList.cnn) {
                      name = 'CNN';
                    }
                    print('Selected news source: $name'); // Debug log
                  });
                },

                itemBuilder: (context) => <PopupMenuEntry<FilterList>>[
                      PopupMenuItem<FilterList>(
                        value: FilterList.bbcNews,
                        child: Text('BBC News'),
                      ),
                      PopupMenuItem<FilterList>(
                        value: FilterList.bloomberg,
                        child: Text('bloomberg'),
                      ),
                      PopupMenuItem<FilterList>(
                        value: FilterList.argaam,
                        child: Text('Al-jazeera News'),
                      ),
                      PopupMenuItem<FilterList>(
                        value: FilterList.cnn,
                        child: Text('CNN'),
                      ),
                    ])
          ],
        ),

      bottomNavigationBar: Container(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: GNav(
            backgroundColor: Colors.black,
            color: Colors.white,
            activeColor: Colors.white,
            tabBackgroundColor: Colors.grey[800]!,
            gap: 8,
            padding: EdgeInsets.all(16),
            tabs: const[
              GButton(icon: Icons.home, text: 'Home'),
              GButton(icon: Icons.search, text: 'Search'),
              GButton(icon: Icons.favorite_border, text: 'like'),
              GButton(icon: Icons.settings, text: 'Setting'),
            ]),
        ),
      ),

        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: height * .55,
                width: width,
                child: FutureBuilder<NewsChannelHeadlinesModel>(
                        future: newsViewModel.fetchNewChannelHeadlinesApi(name),
                        builder: (BuildContext context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(
                              child: SpinKitSpinningLines(size: 50, color: Colors.blue),
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.error_outline, color: Colors.red, size: 60),
                                  SizedBox(height: 16),
                                  Text(
                                    'Error loading news\n${snapshot.error}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ],
                              ),
                            );
                          } else if (!snapshot.hasData || snapshot.data!.articles!.isEmpty) {
                            return Center(
                              child: Text('No articles available.'),
                            );
                  } else {
                    return ListView.builder(
                        itemCount: snapshot.data!.articles!.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          DateTime dateTime = DateTime.parse(snapshot
                              .data!.articles![index].publishedAt
                              .toString());
                          return InkWell(
                            onTap: (){
                              Get.to(NewsDetailScreen(
                                newImage: snapshot.data!.articles![index].urlToImage.toString(),
                                newsTitle: snapshot.data!.articles![index].title.toString(),
                                newsDate: snapshot.data!.articles![index].publishedAt.toString(),
                                author: snapshot.data!.articles![index].author.toString(),
                                description: snapshot.data!.articles![index].description.toString(),
                                content: snapshot.data!.articles![index].content.toString(),
                                source: snapshot.data!.articles![index].source!.name.toString(),
                                )
                                );
                            },
                            child: SizedBox(
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    height: height * 0.6,
                                    width: width * 0.9,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: height * .02),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: CachedNetworkImage(
                                        imageUrl: snapshot
                                            .data!.articles![index].urlToImage
                                            .toString(),
                                        fit: BoxFit.cover,
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
                                  ),
                                  Positioned(
                                    bottom: 20,
                                    child: Card(
                                      elevation: 5,
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Container(
                                        alignment: Alignment.bottomCenter,
                                        padding: EdgeInsets.all(15),
                                        height: height * .22,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: width * 0.7,
                                              child: Text(
                                                snapshot
                                                    .data!.articles![index].title
                                                    .toString(),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.poppins(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w700),
                                              ),
                                            ),
                                            Spacer(),
                                            Container(
                                              width: width * 0.7,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    snapshot
                                                        .data!
                                                        .articles![index]
                                                        .source!
                                                        .name
                                                        .toString(),
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                  Text(
                                                    format.format(dateTime),
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        });
                  }
                },
              ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8),
                child: FutureBuilder<categoriesNewsModel>(
                        future: newsViewModel.fetchCategoriesNewsApi('General'),
                        builder: (BuildContext context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(
                              child: SpinKitSpinningLines(size: 50, color: Colors.blue),
                            );
                          } else {
                            return ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: snapshot.data!.articles!.length,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (context, index) {
                                DateTime dateTime = DateTime.parse(
                                    snapshot.data!.articles![index].publishedAt.toString());
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
                                    child: Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(20),
                                          child: CachedNetworkImage(
                                            imageUrl: snapshot.data!.articles![index].urlToImage.toString(),
                                            fit: BoxFit.cover,
                                            height: height * .18,
                                            width: width * .3,
                                            placeholder: (context, url) => Container(
                                              child: spinKit2,
                                            ),
                                            errorWidget: (context, url, error) => Icon(
                                              Icons.error_outline,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            height: height * .18,
                                            padding: EdgeInsets.only(left: 15),
                                            child: Column(
                                              children: [
                                                Text(
                                                  snapshot.data!.articles![index].title.toString(),
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 15,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w600
                                                  ),
                                                ),
                                                Spacer(),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      snapshot.data!.articles![index].source!.name.toString(),
                                                      style: GoogleFonts.poppins(
                                                        fontSize: 12,
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.w500
                                                      ),
                                                    ),
                                                    Text(
                                                      format.format(dateTime),
                                                      style: GoogleFonts.poppins(
                                                        fontSize: 12,
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.w500
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
                              }
                            );
                          }
                        },
                      ),
              ),
            ],
          ),
        ),
        );
  }
}

const spinKit2 = SpinKitFadingCircle(color: Colors.amber, size: 50);
