

class Category {
  final String name;
  final String image;
  final String? description;

  Category (this.name, this.image , this.description);
}


final List<Category> items = [
  Category('MEN', '1.png', 'MEN'),
  Category('WOMEN', '2.png', 'WOMEN'),
  Category('KIDS', '3.png', 'KIDS'),
  Category('OTHER', '4.png', 'OTHER'),
  ];


final List<Map<String, dynamic>> pages = [
      {
        'image': 'assets/images/1.png',
        'category': 'MEN',
        'des':
            'Explore a wide range of men\'s clothing and accessories. Find your perfect fit for any occasion.'
      },
      {
        'image': 'assets/images/2.png',
        'category': 'WOMEN',
        'des':
            'Discover stylish and comfortable women\'s fashion. From casual wear to elegant evening dresses.'
      },
      {
        'image': 'assets/images/3.png',
        'category': 'KIDS',
        'des':
            'Shop playful and durable clothing for kids. Perfect for school, play, and everything in between.'
      },
      {
        'image': 'assets/images/4.png',
        'category': 'OTHERS',
        'des':
            'Find unique items from various categories that don\'t fit into the standard categories above.'
      },
    ];