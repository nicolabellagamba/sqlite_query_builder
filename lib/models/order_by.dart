import 'package:sqlite_query_builder/enumerators/order.dart';

class OrderBy {
  final String column;
  final Order order;

  OrderBy({required this.column, this.order = Order.asc});
}
