import 'package:flutter/material.dart';
import '../../customwidget/album_row_widget.dart';
import '../../domain/app_color.dart';
import '../../domain/uihelper.dart';
import '../../pages/category_music_page.dart';
import '../../pages/playsong_ui.dart';

class SearchBottomNavPage extends StatefulWidget {
  @override
  _SearchBottomNavPageState createState() => _SearchBottomNavPageState();
}

class _SearchBottomNavPageState extends State<SearchBottomNavPage> {
  TextEditingController searchController = TextEditingController();

  List<String> allSongs = [
    "Kesariya",
    "Tum Hi Ho",
    "Jhoome Jo Pathaan",
    "Excuses",
    "Shubh",
    "Love Dose",
    "Heat Waves",
  ];

  Map<String, List<String>> categorySongs = {
    "Hindi": ["Aijit Singh", "Tum Hi Ho"],
    "Punjabi": ["Shubh", "Baller",],
    "Pop": ["Heat Waves"],
    "New Release": ["Jhoome Jo Pathaan"],
  };

  //    UI LISTS
  final List<Map<String, dynamic>> mTopGenreList = [
    {"imagePath": "assets/images/1st.png", "name": "Pop"},
    {"imagePath": "assets/images/1st.png", "name": "Hindi"},
    {"imagePath": "assets/images/1st.png", "name": "New Release"},
    {"imagePath": "assets/images/1st.png", "name": "Punjabi"},
  ];

  final List<Map<String, dynamic>> mPodcastList = [
    {"imagePath": "assets/images/1st.png", "name": "News & Politices"},
    {"imagePath": "assets/images/1st.png", "name": "Comedy"},
  ];

  final List<Map<String, dynamic>> mBrowseList = [
    {"imagePath": "assets/images/2(made for you).jpeg", "name": "Made For You"},
    {"imagePath": "assets/images/3(upcoming release).jpeg", "name": "Upcoming releases"},
    {"imagePath": "assets/images/4(new release).jpeg", "name": "New Releases"},
    {"imagePath": "assets/images/5(hindi).jpeg", "name": "Hindi"},
    {"imagePath": "assets/images/6(telugu).jpeg", "name": "Telugu"},
    {"imagePath": "assets/images/7(punjabi).jpeg", "name": "Punjabi"},
    {"imagePath": "assets/images/8(tamil).jpeg", "name": "Tamil"},
    {"imagePath": "assets/images/9(chart).jpeg", "name": "Charts"},
    {"imagePath": "assets/images/10(podcast chart).jpeg", "name": "Podcast Charts"},
    {"imagePath": "assets/images/11(podcast new).jpeg", "name": "Podcast New Release"},
    {"imagePath": "assets/images/13(pop).jpeg", "name": "Pop"},
    {"imagePath": "assets/images/12(bhojpuri).jpeg", "name": "Bhojpuri"},
  ];

  List<Map<String, dynamic>> finalSearchResults = [];
  List<Map<String, dynamic>> filteredList = [];

  @override
  void initState() {
    super.initState();
    generateAllSearchItems();
  }

  // Combine all items for searching
  void generateAllSearchItems() {
    finalSearchResults.clear();

    // SONGS
    for (var song in allSongs) {
      finalSearchResults.add({
        "type": "song",
        "title": song,
      });
    }

    // TOP GENRES
    for (var item in mTopGenreList) {
      finalSearchResults.add({
        "type": "category",
        "title": item["name"],
      });
    }

    // PODCAST
    for (var item in mPodcastList) {
      finalSearchResults.add({
        "type": "podcast",
        "title": item["name"],
      });
    }

    // BROWSE
    for (var item in mBrowseList) {
      finalSearchResults.add({
        "type": "browse",
        "title": item["name"],
      });
    }
  }

  //  SEARCH WITH CATEGORY SONG MATCHING

  void filterSearch(String query) {
    filteredList = [];

    if (query.isEmpty) {
      setState(() {});
      return;
    }

    String q = query.toLowerCase();

    for (var song in allSongs) {
      if (song.toLowerCase().contains(q)) {
        String? matchedCategory;
        String? categoryImage;

        // detect category
        categorySongs.forEach((cat, songs) {
          if (songs.contains(song)) {
            matchedCategory = cat;
            categoryImage = getCategoryImage(cat);
          }
        });

        filteredList.add({
          "type": "song",
          "title": song,
          "category": matchedCategory,
          "image": categoryImage,
        });
      }
    }


    //  CATEGORY NAME MATCH

    for (var item in [...mTopGenreList, ...mBrowseList]) {
      if (item["name"].toLowerCase().contains(q)) {
        filteredList.add({
          "type": "category",
          "title": item["name"],
          "image": item["imagePath"],
        });
      }
    }

    setState(() {});
  }


  // Get category image from lists

  String getCategoryImage(String category) {
    for (var item in [...mTopGenreList, ...mBrowseList]) {
      if (item["name"] == category) return item["imagePath"];
    }
    return "";
  }


  // UI STARTS

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.blackColor,
        body: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 85),
          child: Column(
            children: [
              mSpacer(),
              tittleUi(),
              mSpacer(mHeight: 14),
              searchBar(),
              searchResults(),
              mSpacer(mHeight: 14),
              topGenresUi(context),
              mSpacer(mHeight: 14),
              popularPodcasts(context),
              mSpacer(mHeight: 14),
              browseAll(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget tittleUi() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 11.0),
      child: Row(
        children: [
          Text('Search',
              style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
          Spacer(),
          Icon(Icons.camera_alt_outlined, size: 25, color: Colors.white),
          mSpacer(mWidth: 20),
        ],
      ),
    );
  }

  Widget searchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 11.0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 11.0),
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(11),
        ),
        child: TextField(
          controller: searchController,
          onChanged: filterSearch,
          decoration: InputDecoration(
            hintText: "Artists, songs, or Podcasts",
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search, size: 26),
          ),
        ),
      ),
    );
  }

  // SEARCH RESULT UI (SONG + CATEGORY)

  Widget searchResults() {
    if (filteredList.isEmpty) return SizedBox();

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: filteredList.length,
      itemBuilder: (_, index) {
        var item = filteredList[index];

        return ListTile(
          leading: item["image"] != null
              ? Image.asset(item["image"], width: 50, height: 50, fit: BoxFit.cover)
              : Icon(Icons.music_note, color: Colors.white),

          title: Text(item["title"], style: TextStyle(color: Colors.white)),

          subtitle: Text(
            item["type"] == "song"
                ? (item["category"] != null ? "Song • ${item["category"]}" : "Song")
                : "Category",
            style: TextStyle(color: Colors.grey),
          ),

          onTap: () {
            if (item["type"] == "song") {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PlaySongUI(
                    songTitle: item["title"],
                    albumTitle: item["category"] ?? "",
                    thumbnailPath: item["image"] ?? "",
                  ),
                ),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CategoryMusicPage(categoryname: item["title"]),
                ),
              );
            }
          },
        );
      },
    );
  }


  // REST UI (unchanged)

  Widget topGenresUi(context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 11.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Top Genres',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          mSpacer(),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: mTopGenreList.length,
              itemBuilder: (_, index) {
                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CategoryMusicPage(
                        categoryname: mTopGenreList[index]["name"],
                      ),
                    ),
                  ),
                  child: AlbumRowWidget(
                    thumbnailPath: mTopGenreList[index]["imagePath"],
                    albumName: mTopGenreList[index]["name"],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget popularPodcasts(context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 11.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Popular podcast categories',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          mSpacer(),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: mPodcastList.length,
              itemBuilder: (_, index) {
                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CategoryMusicPage(
                          categoryname: mPodcastList[index]["name"]),
                    ),
                  ),
                  child: AlbumRowWidget(
                    thumbnailPath: mPodcastList[index]["imagePath"],
                    albumName: mPodcastList[index]["name"],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget browseAll(context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 11.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Browse all',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          mSpacer(),
          GridView.builder(
            itemCount: mBrowseList.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 16 / 9,
              mainAxisSpacing: 11,
            ),
            itemBuilder: (_, index) {
              return GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CategoryMusicPage(
                        categoryname: mBrowseList[index]["name"]),
                  ),
                ),
                child: AlbumRowWidget(
                  thumbnailPath: mBrowseList[index]["imagePath"],
                  albumName: mBrowseList[index]["name"],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}



