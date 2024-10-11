import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Data Berita Terbaru dan Trending
  final List<Map<String, String>> latestNews = [
    {
      'title': 'Arema FC Rekrut Striker Asing Jelang Putaran 2',
      'date': '10 Oct 2024'
    },
    {'title': 'Arema FC Menang Dramatis atas Persib', 'date': '09 Oct 2024'},
    {'title': 'Optimis Hadapi Laga Big Match Pekan Ini', 'date': '08 Oct 2024'},
  ];

  final List<Map<String, String>> trendingNews = [
    {'title': 'Judul Trending 1', 'date': '09 Oct 2024'},
    {'title': 'Judul Trending 2', 'date': '08 Oct 2024'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset(
                  'assets/logo.png',
                  height: 40,
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome!',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Hari ini, 10 Okt 2024',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            IconButton(
              icon: Icon(Icons.notifications, color: Colors.black),
              onPressed: () {},
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Pencarian
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.grey),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Cari berita...',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            // Tab bar
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  Chip(label: Text('Semua')),
                  SizedBox(width: 10),
                  Chip(label: Text('Berita Terbaru')),
                  SizedBox(width: 10),
                  Chip(label: Text('Trending')),
                  SizedBox(width: 10),
                  Chip(label: Text('Arema Day')),
                  SizedBox(width: 10),
                  Chip(label: Text('Aremania/nita')),
                ],
              ),
            ),
            SizedBox(height: 16),
            // Berita Terbaru section
            _buildSectionTitle('Berita Terbaru'),
            Container(
              height: 270,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: latestNews.length,
                itemBuilder: (context, index) {
                  return _buildNewsCard(
                    latestNews[index]['title']!,
                    latestNews[index]['date']!,
                    'assets/gambar${index + 1}.jpeg', // Ganti dengan path gambar yang sesuai
                  );
                },
              ),
            ),
            // Trending Section
            _buildSectionTitle('Trending'),
            Container(
              height: 170,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: trendingNews.length,
                itemBuilder: (context, index) {
                  return _buildTrendingCard(
                    trendingNews[index]['title']!,
                    trendingNews[index]['date']!,
                  );
                },
              ),
            ),
            // Arema Day section
            _buildSectionTitle('Arema Day'),
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1.5,
              ),
              itemCount: 4,
              itemBuilder: (context, index) {
                return _buildGridItem();
              },
            ),
            // Aremania/nita section
            _buildSectionTitle('Aremania/nita'),
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1.5,
              ),
              itemCount: 4,
              itemBuilder: (context, index) {
                return _buildGridItem();
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notification',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Text(
            'Lihat Semua',
            style: TextStyle(color: Colors.blue, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildNewsCard(String title, String date, String imagePath) {
    return Container(
      margin: EdgeInsets.only(left: 16),
      width: 150,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 4,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar
          Container(
            height: 160,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(imagePath), // Ganti dengan gambar yang sesuai
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
            ),
          ),
          SizedBox(height: 8),
          // Teks
          Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.person, size: 14, color: Colors.grey),
                    SizedBox(width: 4),
                    Text(
                      'by Author', // Ganti 'Author' dengan nama penulis yang sesuai
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  date,
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendingCard(String title, String date) {
    return Container(
      margin: EdgeInsets.only(left: 16),
      width: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 100,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          SizedBox(height: 8),
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(
            date,
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildGridItem() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
