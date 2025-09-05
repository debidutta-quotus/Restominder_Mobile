class MenuItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final int minPrepTime;
  final int maxPrepTime;
  final int maxPossibleOrders;
  final bool available;
  final List<String> images;
  final List<String> tags;
  final String category;
  final String dietary;
  final String storeId;
  final DateTime createdAt;
  final DateTime updatedAt;

  MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.minPrepTime,
    required this.maxPrepTime,
    required this.maxPossibleOrders,
    required this.available,
    required this.images,
    required this.tags,
    required this.category,
    required this.dietary,
    required this.storeId,
    required this.createdAt,
    required this.updatedAt,
  });

  // Helper method to get formatted time range
  String get timeRange => '$minPrepTime–$maxPrepTime mins';

  // Helper method to get formatted price
  String get formattedPrice => '\$${price.toStringAsFixed(2)}';

  // Helper method to get dietary display text
  String get dietaryDisplayText {
    switch (dietary.toLowerCase()) {
      case 'veg':
        return 'Vegetarian';
      case 'non-veg':
        return 'Non-Vegetarian';
      case 'vegan':
        return 'Vegan';
      case 'gluten-free':
        return 'Gluten-Free';
      default:
        return dietary;
    }
  }

  // Helper method to get first image or default
  String get primaryImage {
    return images.isNotEmpty ? images.first : 'assets/images/paneer.webp';
  }

  // Helper method to get tags as a single string
  String get tagsString => tags.join(' ');

  // Copy with method for updating
  MenuItem copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    int? minPrepTime,
    int? maxPrepTime,
    int? maxPossibleOrders,
    bool? available,
    List<String>? images,
    List<String>? tags,
    String? category,
    String? dietary,
    String? storeId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MenuItem(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      minPrepTime: minPrepTime ?? this.minPrepTime,
      maxPrepTime: maxPrepTime ?? this.maxPrepTime,
      maxPossibleOrders: maxPossibleOrders ?? this.maxPossibleOrders,
      available: available ?? this.available,
      images: images ?? this.images,
      tags: tags ?? this.tags,
      category: category ?? this.category,
      dietary: dietary ?? this.dietary,
      storeId: storeId ?? this.storeId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}