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
    name: 'UCL',
    date: '2023-06-01',
    time: '10:00 AM',
    price: 10.0,
    imagePath: 'assets/news/6.png',
    idEvent: '1'
  ),
  Item(
    name: 'UCL',
    date: '2023-06-02',
    time: '11:00 AM',
    price: 20.0,
    imagePath: 'assets/news/5.png',
    idEvent: '2'
  ),
  Item(
    name: 'UCL',
    date: '2023-06-03',
    time: '12:00 PM',
    price: 30.0,
    imagePath: 'assets/news/4.png', 
    idEvent: '3'
  ),
];
