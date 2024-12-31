import 'dart:async';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:myapp/app/routes/app_pages.dart';

class SearchArticlePageView extends StatefulWidget {
  @override
  _SearchArticlePageState createState() => _SearchArticlePageState();
}

class _SearchArticlePageState extends State<SearchArticlePageView> {
  TextEditingController _searchController = TextEditingController();
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  String _speechText = "";
  List<DocumentSnapshot> _filteredArticles = [];

  late Timer _timer; // Timer untuk mengubah warna border secara periodik
  List<Color> _borderColors = [
    Colors.blue,
    const Color.fromARGB(255, 0, 251, 255),
    const Color.fromARGB(255, 0, 6, 84),
    const Color.fromARGB(255, 0, 17, 255),
    const Color.fromARGB(255, 0, 0, 0),
  ];
  int _currentColorIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializeSpeech();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _changeBorderColor();
    });
  }

  // Fungsi untuk mengubah warna border setiap detik
  void _changeBorderColor() {
    setState(() {
      _currentColorIndex = (_currentColorIndex + 1) % _borderColors.length;
    });
  }

  Future<void> _initializeSpeech() async {
    bool available = await _speech.initialize();
    if (!available) {
      print("Speech recognition tidak tersedia pada perangkat ini");
    }
  }

  void _startListening() async {
    if (_speech.isAvailable && !_isListening) {
      setState(() => _isListening = true);
      _speech.listen(onResult: (val) {
        setState(() {
          _speechText = val.recognizedWords;
          _searchController.text = _speechText;
          _searchArticles(_speechText);
        });
      });
    }
  }

  void _stopListening() {
    if (_isListening) {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  void _searchArticles(String query) async {
    if (query.isEmpty) {
      setState(() => _filteredArticles = []);
      return;
    }

    final lowercaseQuery = query.toLowerCase();

    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('Informasi').get();

    final filteredDocs = snapshot.docs.where((doc) {
      final title = doc['judul_artikel']?.toLowerCase() ?? '';
      return title.contains(lowercaseQuery);
    }).toList();

    setState(() {
      _filteredArticles = filteredDocs;
    });
  }

  @override
  void dispose() {
    _timer
        .cancel(); // Jangan lupa untuk menghentikan timer ketika widget dihancurkan
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Image.asset('assets/logoweare.jpg', height: 55),
          ],
        ),
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(255, 139, 181, 255),
              const Color.fromARGB(255, 201, 238, 255)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Temukan Artikel Terpercaya dan Terupdate!',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.5),
                      offset: Offset(2.0, 2.0),
                      blurRadius: 4.0,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),

              // TextField with changing border color
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 38, 0, 255)
                          .withOpacity(0.3),
                      spreadRadius: 5,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: "Masukkan judul artikel...",
                    hintStyle: TextStyle(color: Colors.grey),
                    prefixIcon: Icon(Icons.search, color: Colors.blue),
                    suffixIcon: IconButton(
                      icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
                      onPressed:
                          _isListening ? _stopListening : _startListening,
                    ),
                  ),
                  onChanged: _searchArticles,
                ),
              ),
              SizedBox(height: 20),

              // Expanded to take up remaining space for the list of articles
              Expanded(
                child: _filteredArticles.isEmpty
                    ? Center(
                        child: Text(
                          "Tidak ada artikel ditemukan",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _filteredArticles.length,
                        itemBuilder: (context, index) {
                          return _buildArticleCard(_filteredArticles[index]);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildArticleCard(DocumentSnapshot article) {
    String title = article['judul_artikel'] ?? 'No Title';
    String category = article['kategori'] ?? 'No Category';
    String imageUrl =
        article['gambar_url'] ?? 'https://example.com/default-image.png';

    String formattedDate =
        DateFormat('dd MMMM yyyy').format(article['tanggal_upload'].toDate());

    return GestureDetector(
      onTap: () async {
        String articleId = article.id;
        var articleDetails = article.data();

        Get.toNamed(
          Routes.NGALAM_READ_TERBARU,
          arguments: {
            'id': articleId,
            'data': articleDetails,
          },
        );
      },
      child: Card(
        margin: EdgeInsets.only(bottom: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(
            color: _borderColors[_currentColorIndex], // Border color is dynamic
            width: 3, // Adjust width here for the Card's border
          ),
        ),
        elevation: 5,
        child: Row(
          children: [
            Container(
              width: 100,
              height: 100,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                ),
                child: Image.network(imageUrl, fit: BoxFit.cover),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 5),
                    Text(category, style: TextStyle(color: Colors.grey)),
                    SizedBox(height: 10),
                    Text(formattedDate, style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
