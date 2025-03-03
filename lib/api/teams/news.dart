import 'package:cloud_firestore/cloud_firestore.dart';

class NewsApi {
  final CollectionReference news = FirebaseFirestore.instance.collection('news');

  Stream<QuerySnapshot> getTeamsStream() {
    return news.orderBy('news_time', descending: false).snapshots();
  }

  Future<void> addNews({required String newsTitle, required String newsContent ,required String newsImage, required String newsTime}) async {
    // Automatically generate a unique ID for the team
    await news.add({
      'news_title': newsTitle,
      'news_content': newsContent,
      'news_url': newsImage,
      'news_time': newsTime,
      'news_id': news.doc().id, // Generate unique ID
      
    });
  }
}