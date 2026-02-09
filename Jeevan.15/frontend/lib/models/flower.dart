class Flower {
  String id;
  String name;
  String description;
  String imageUrl;
  String pdfUrl;

  Flower({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.pdfUrl,
  });

  factory Flower.fromJson(Map<String, dynamic> map) {
    return Flower(
      id: map['_id'],
      name: map['name'],
      description: map['description'],
      imageUrl: map['imageUrl'],
      pdfUrl: map['pdfUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'pdfUrl': pdfUrl,
    };
  }
}
