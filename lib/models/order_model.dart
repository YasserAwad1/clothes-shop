import './cart_model.dart';

class OrderModel {
  final String id;
  final List<CartModel> products;
  final DateTime date;
  final double total;

  OrderModel(
    this.id,
    this.products,
    this.date,
    this.total,
  );

}
