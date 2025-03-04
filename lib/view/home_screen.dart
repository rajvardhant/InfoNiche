import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:news_app/controller/language_controller.dart';
import 'package:news_app/view/bookmark_screen.dart';
import 'package:news_app/view/current_affairs_screen.dart';
import 'package:news_app/view/custom_date_screen.dart';
import 'package:news_app/view/news_detail_screen.dart';
import 'package:news_app/view/profile_screen.dart';
import 'package:news_app/view/quiz_screen.dart';
import 'package:news_app/view/search_screen.dart';
import 'package:news_app/view_model/news_view_model.dart';
import '../model/categories_new_model.dart';
import '../model/news_channel_headlines_modle.dart';
import 'categories_screen.dart';
import 'package:news_app/utils/string_utils.dart';

enum FilterList { bbcNews, bloomberg, independent, retuers, cnn, argaam }

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final newsViewModel = Get.put(NewsViewModel());
  final languageController = Get.put(LanguageController());
  FilterList? selectedMenu;
  int _selectedIndex = 0;
  String name = 'bbc-news';
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const HomeContent(),
      const SearchScreen(),
      const BookmarkScreen(),
      const ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.to(() => const CategoriesScreen());
          },
          icon: Icon(Icons.drag_indicator,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black),
        ),
        title: Text(
          'InfoNiche',
          style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black),
        ),
        actions: [
          PopupMenuButton<FilterList>(
            initialValue: selectedMenu,
            icon: Icon(Icons.more_vert,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black),
            onSelected: (FilterList item) {
              setState(() {
                selectedMenu = item;
                switch (item) {
                  case FilterList.bbcNews:
                    name = 'bbc-news';
                    break;
                  case FilterList.bloomberg:
                    name = 'bloomberg';
                    break;
                  case FilterList.argaam:
                    name = 'al-jazeera-english';
                    break;
                  case FilterList.cnn:
                    name = 'cnn';
                    break;
                  default:
                    name = 'bbc-news';
                }
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: FilterList.bbcNews,
                child: Text('BBC News'),
              ),
              const PopupMenuItem(
                value: FilterList.bloomberg,
                child: Text('Bloomberg'),
              ),
              const PopupMenuItem(
                value: FilterList.argaam,
                child: Text('Al-jazeera News'),
              ),
              const PopupMenuItem(
                value: FilterList.cnn,
                child: Text('CNN'),
              ),
            ],
          ),
        ],
      ),
      body: _pages[_selectedIndex],
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
            padding: const EdgeInsets.all(16),
            selectedIndex: _selectedIndex,
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            tabs: const [
              GButton(
                icon: Icons.home,
                text: 'Home',
              ),
              GButton(
                icon: Icons.search,
                text: 'Search',
              ),
              GButton(
                icon: Icons.bookmark_add_outlined,
                text: 'BookMark',
              ),
              GButton(
                icon: Icons.person,
                text: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  const HomeContent({Key? key}) : super(key: key);

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  final newsViewModel = Get.find<NewsViewModel>();
  final languageController = Get.find<LanguageController>();
  final format = DateFormat('MMM dd, yyyy');
  String name = 'bbc-news';

  String formatTitleText(String text) {
    if (text.length <= 10) return text;

    List<String> words = text.split(' ');
    if (words.length <= 1) return text;

    String firstWord = words[0];
    // Get initials of remaining words and join them
    String restInitials = words.skip(1)
        .map((word) => word.isNotEmpty ? word[0].toUpperCase() : '')
        .join('');

    // If there are no initials, just return the first word
    if (restInitials.isEmpty) return firstWord;

    // Add a bullet point between initials if there are multiple
    String formattedInitials = restInitials.split('').join('·');

    return '$firstWord\n$formattedInitials';
  }

  Widget _buildCircularOption(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                shape: BoxShape.circle,
                border: Border.all(color: color, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              formatTitleText(title),
              textAlign: TextAlign.center,
              maxLines: 2,
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                height: 1.2,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    final width = MediaQuery.of(context).size.width;
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 3,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 8),
          width: width * 0.85,
          child: Shimmer.fromColors(
            period: const Duration(milliseconds: 1500), // Slower animation
            baseColor: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey[850]!
                : Colors.grey[300]!,
            highlightColor: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey[700]!
                : Colors.grey[100]!,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            height: 20,
                            width: width * 0.6,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            height: 16,
                            width: width * 0.4,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
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
  }

  Widget _buildNewsShimmer() {
    return ListView.builder(
      itemCount: 4,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Shimmer.fromColors(
            period: const Duration(milliseconds: 1500), // Slower animation
            baseColor: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey[850]!
                : Colors.grey[300]!,
            highlightColor: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey[700]!
                : Colors.grey[100]!,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 20,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        margin: EdgeInsets.only(bottom: 8, right: 20),
                      ),
                      Container(
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        margin: EdgeInsets.only(bottom: 4, right: 50),
                      ),
                      Container(
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        margin: EdgeInsets.only(bottom: 4, right: 30),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 14,
                            width: 80,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          Container(
                            height: 14,
                            width: 60,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          Container(
            height: height * .42,
            width: width,
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: FutureBuilder<NewsChannelHeadlinesModel>(
              future: newsViewModel.fetchNewChannelHeadlinesApi(name),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return _buildShimmerLoading();
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else if (!snapshot.hasData ||
                    snapshot.data!.articles == null) {
                  return const Center(
                    child: Text('No articles available'),
                  );
                }

                return ListView.builder(
                  itemCount: snapshot.data!.articles!.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    DateTime dateTime = DateTime.parse(
                        snapshot.data!.articles![index].publishedAt.toString());
                    return InkWell(
                      onTap: () {
                        Get.to(NewsDetailScreen(
                          newImage: snapshot.data!.articles![index].urlToImage
                              .toString(),
                          newsTitle:
                              snapshot.data!.articles![index].title.toString(),
                          newsDate: snapshot.data!.articles![index].publishedAt
                              .toString(),
                          author:
                              snapshot.data!.articles![index].author.toString(),
                          description: snapshot
                              .data!.articles![index].description
                              .toString(),
                          content: snapshot.data!.articles![index].content
                              .toString(),
                          source: snapshot.data!.articles![index].source!.name
                              .toString(),
                        ));
                      },
                      child: Container(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              height: height * 0.42,
                              width: width * .85,
                              padding: EdgeInsets.symmetric(
                                horizontal: height * .01,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: CachedNetworkImage(
                                  imageUrl: snapshot
                                          .data!.articles![index].urlToImage
                                          .toString() ??
                                      '',
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(
                                    child: SpinKitFadingCircle(
                                      color: Colors.amber,
                                      size: 50,
                                    ),
                                  ),
                                  errorWidget: (context, error, stackTrace) {
                                    return const Icon(Icons.error);
                                  },
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 20,
                              child: Card(
                                elevation: 5,
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.grey[800]
                                    : Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Container(
                                  alignment: Alignment.bottomCenter,
                                  padding: const EdgeInsets.all(15),
                                  height: height * .18,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: width * 0.65,
                                        child: Text(
                                          snapshot.data!.articles![index].title
                                              .toString(),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                            color:
                                                Theme.of(context).brightness ==
                                                        Brightness.dark
                                                    ? Colors.white
                                                    : Colors.black,
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      Container(
                                        width: width * 0.65,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              snapshot.data!.articles![index]
                                                  .source!.name
                                                  .toString(),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.poppins(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                                color: Theme.of(context)
                                                            .brightness ==
                                                        Brightness.dark
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                            ),
                                            Text(
                                              format.format(dateTime),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: Theme.of(context)
                                                            .brightness ==
                                                        Brightness.dark
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          // Current Affairs Options
          Padding(padding: EdgeInsets.all(5)),
          Container(
            height: 90,
            margin: const EdgeInsets.only(bottom: 11),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey[900]
                  : Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              children: [
                const SizedBox(width: 8),
                _buildCircularOption(
                  context,
                  'International',
                  Icons.public,
                  Colors.blue,
                  () => Get.to(() => const CurrentAffairsScreen(type: 'international')),
                ),
                _buildCircularOption(
                  context,
                  'India',
                  Icons.flag,
                  Colors.orange,
                  () => Get.to(() => const CurrentAffairsScreen(type: 'india')),
                ),
                _buildCircularOption(
                  context,
                  'Quiz',
                  Icons.quiz,
                  Colors.purple,
                  () => Get.to(() => const QuizScreen()),
                ),
                _buildCircularOption(
                  context,
                  'History',
                  Icons.history_edu,
                  Colors.green,
                  () => Get.to(() => const CurrentAffairsScreen(type: 'history')),
                ),
                _buildCircularOption(
                  context,
                  'Date',
                  Icons.calendar_today,
                  Colors.red,
                  () => Get.to(() => const CustomDateScreen()),
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),
          // News Categories
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: FutureBuilder<categoriesNewsModel>(
              future: newsViewModel.fetchCategoriesNewsApi('General'),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return _buildNewsShimmer();
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else if (!snapshot.hasData ||
                    snapshot.data!.articles == null) {
                  return const Center(
                    child: Text('No articles available'),
                  );
                }

                return ListView.builder(
                  itemCount: snapshot.data!.articles!.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final article = snapshot.data!.articles![index];
                    DateTime dateTime =
                        DateTime.parse(article.publishedAt.toString());
                    bool isDarkMode =
                        Theme.of(context).brightness == Brightness.dark;

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
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                                          color: isDarkMode
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        article.description.toString(),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          color: isDarkMode
                                              ? Colors.white70
                                              : Colors.grey[600],
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                              StringUtils.formatAuthorName(
                                                article.author ?? 'Unknown',
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
                                              format.format(dateTime),
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
