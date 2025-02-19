class NewsModel {
  final String id;
  final String title;
  final String content;
  final String imageUrl;
  final DateTime publishDate;

  NewsModel({
    required this.id,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.publishDate,
  });
}


final List<NewsModel> mockNews = [
  NewsModel(
    id: '1',
    title: 'Manchester City Maintains Lead with 3-1 Victory over United',
    content: 'In a thrilling Manchester derby, City emerged victorious with a 3-1 win at the Etihad Stadium. Phil Foden scored twice and Erling Haaland added another, while Marcus Rashford scored United\'s consolation goal. This victory keeps City in strong contention for the Premier League title...',
    imageUrl: 'https://i.guim.co.uk/img/media/4473f82aea27b20378275dfccdf239e4a28e6a20/0_75_3434_2061/master/3434.jpg?width=465&dpr=1&s=none&crop=none',
    publishDate: DateTime.now().subtract(const Duration(hours: 12)),
  ),
  NewsModel(
    id: '2',
    title: 'Cristiano Ronaldo Leads Al Nassr to ICL Quarter-finals',
    content: 'Al Nassr secured their place in the Intercontinental League quarter-finals with a stunning 4-2 victory, featuring a hat-trick from Cristiano Ronaldo. The Portuguese superstar continues to dominate in Saudi Arabia, bringing his season tally to 28 goals across all competitions...',
    imageUrl: 'https://c.files.bbci.co.uk/2700/live/0cfb5290-6460-11ef-a7d8-61cd67f3fb31.jpg',
    publishDate: DateTime.now().subtract(const Duration(days: 1)),
  ),
  NewsModel(
    id: '3',
    title: 'Liverpool\'s Title Hopes Boosted After 2-0 Win Against Arsenal',
    content: 'Liverpool strengthened their position in the Premier League title race with a crucial 2-0 victory over Arsenal at Anfield. Mohamed Salah and Darwin Núñez found the net in a dominant display that keeps the Reds at the top of the table with just eight games remaining...',
    imageUrl: 'https://images2.minutemediacdn.com/image/upload/c_crop,w_3544,h_1993,x_833,y_1052/c_fill,w_1440,ar_16:9,f_auto,q_auto,g_auto/images/GettyImages/mmsport/90min_th_international_web/01j3fd8gss5qfhn4gwdj.jpg',
    publishDate: DateTime.now().subtract(const Duration(days: 2)),
  ),
  
];
