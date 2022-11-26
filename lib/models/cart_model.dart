class CartModel {
  final String id;
  final String title;
  final String storeName;
  final double price;
  int quantity;
  final String imageUrl;

  CartModel(this.id, this.title, this.storeName, this.price, this.quantity,
      this.imageUrl);
}