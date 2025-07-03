class Category {
  String? title;
  String? image;
  Category({required this.title, this.image});
}

List<Category> categories = [
  Category(title: "Grocery", image: "assets/c_images/grocery2ps.png"),
  Category(title: "Electronics", image: "assets/c_images/electronics.jpg"),
  Category(title: "Cosmetics", image: "assets/c_images/cosmeticsPSnew.png"),
  Category(title: "Pharmacy", image: "assets/c_images/pharmacyPS.png"),
  Category(title: "Garments", image: "assets/c_images/clothes.jpg"),
];
