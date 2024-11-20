import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Provider/media_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final List<String> titles = ['Home', 'Search', 'Library'];

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.sizeOf(context).width;
    double h = MediaQuery.sizeOf(context).height;
    final providerTrue = Provider.of<MediaProvider>(context);
    final providerFalse = Provider.of<MediaProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.white),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
        title: Text(
          titles[_currentIndex],
          style: TextStyle(
            color: Colors.white,
            fontSize: w * 0.06,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(CupertinoIcons.search, color: Colors.white),
            onPressed: () {
              showSearch(
                context: context,
                delegate: SongSearchDelegate(providerTrue),
              );
            },
          ),
        ],
      ),
      drawer: _buildDrawer(w, h),
      body: _currentIndex == 0
          ? _buildHomeScreen(w, h, providerTrue, providerFalse)
          : Center(
        child: Text(
          'Coming Soon!',
          style: TextStyle(color: Colors.white, fontSize: w * 0.05),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        onTap: (index) => setState(() {
          _currentIndex = index;
        }),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_music),
            label: 'Library',
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer(double w, double h) {
    return Drawer(
      backgroundColor: Colors.black,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.black),
            child: Text(
              'Menu',
              style: TextStyle(color: Colors.white, fontSize: w * 0.06),
            ),
          ),
          _buildDrawerItem(Icons.person, 'Profile'),
          _buildDrawerItem(Icons.favorite, 'Liked Songs', onTap: () {
            Navigator.of(context).pushNamed('like');
          }),
          _buildDrawerItem(Icons.language, 'Language'),
          _buildDrawerItem(Icons.contact_mail, 'Contact Us'),
          _buildDrawerItem(Icons.help, 'FAQs'),
          _buildDrawerItem(Icons.settings, 'Settings'),
        ],
      ),
    );
  }

  ListTile _buildDrawerItem(IconData icon, String title, {VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey),
      title: Text(
        title,
        style: TextStyle(color: Colors.white),
      ),
      onTap: onTap ?? () {},
    );
  }

  Widget _buildHomeScreen(
      double w,
      double h,
      MediaProvider providerTrue,
      MediaProvider providerFalse,
      ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: w * 0.04),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: h * 0.02),
            Text(
              'Recommended for You',
              style: TextStyle(
                color: Colors.white,
                fontSize: w * 0.06,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: h * 0.02),
            providerTrue.musicModal == null
                ? Center(child: CircularProgressIndicator(color: Colors.white))
                : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12.0,
                mainAxisSpacing: 12.0,
                childAspectRatio: 0.85,
              ),
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: providerTrue.musicModal?.data.results.length ?? 0,
              itemBuilder: (context, index) {
                final song = providerTrue.musicModal!.data.results[index];
                return GestureDetector(
                  onTap: () {
                    providerFalse.selectSong(index);
                    providerFalse.setSong(song.downloadUrl[1].url);
                    Navigator.of(context).pushNamed('/play');
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),

                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                          child: Image.network(
                            song.image.length > 2
                                ? song.image[2].url
                                : '',
                            height: 155,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            song.name ?? 'Unknown Song',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: w * 0.04,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
                          child: Text(
                            song.artists.primary?.isNotEmpty == true
                                ? song.artists.primary![0].name
                                : 'Unknown Artist',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: w * 0.035,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SongSearchDelegate extends SearchDelegate {
  final MediaProvider provider;

  SongSearchDelegate(this.provider);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () => query = '',
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    provider.searchSong(query);
    return _buildSearchResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults(context);
  }

  Widget _buildSearchResults(BuildContext context) {
    final results = provider.musicModal?.data.results
        .where((song) => song.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return results == null || results.isEmpty
        ? Center(child: Text('No Results Found', style: TextStyle(color: Colors.white)))
        : ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final song = results[index];
        return ListTile(
          title: Text(song.name, style: TextStyle(color: Colors.white)),
          subtitle: Text(
            song.artists.primary?.isNotEmpty == true
                ? song.artists.primary![0].name
                : 'Unknown Artist',
            style: TextStyle(color: Colors.grey),
          ),
          onTap: () {
            provider.selectSong(index);
            provider.setSong(song.downloadUrl[1].url);
            Navigator.of(context).pushNamed('/play');
          },
        );
      },
    );
  }
}
