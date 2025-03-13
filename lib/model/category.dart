class Item {
  final String name;
  final String date;
  final String time;
  final double price;
  final String imagePath;
  final String idEvent;

  Item({
    required this.name,
    required this.date,
    required this.time,
    required this.price,
    required this.imagePath,
    required this.idEvent

  });
}

List<Item> items = [
  Item(
    name: 'NEWS',
    date: 'UEFA Champion League',
    time: '',
    price: 10.0,
    imagePath: 'assets/news/6.png',
    idEvent: '1'
  ),
  Item(
    name: 'NEWS',
    date: 'Premier League',
    time: '',
    price: 20.0,
    imagePath: 'assets/news/5.png',
    idEvent: '2'
  ),
  Item(
    name: 'NEWS',
    date: 'World Cup',
    time: '',
    price: 30.0,
    imagePath: 'assets/news/4.png', 
    idEvent: '3'
  ),
];

