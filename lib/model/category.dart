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
    name: 'Manchester United',
    date: '2023-06-01',
    time: '10:00 AM',
    price: 10.0,
    imagePath: 'assets/news/1.png',
    idEvent: '1'
  ),
  Item(
    name: 'Liverpool',
    date: '2023-06-02',
    time: '11:00 AM',
    price: 20.0,
    imagePath: 'assets/news/2.png',
    idEvent: '2'
  ),
  Item(
    name: 'Real Madrid',
    date: '2023-06-03',
    time: '12:00 PM',
    price: 30.0,
    imagePath: 'assets/news/3.png', 
    idEvent: '3'
  ),
];
