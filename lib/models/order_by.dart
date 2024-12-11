import 'package:sqlite_query_builder/enumerators/order.dart';
import 'package:sqlite_query_builder/interfaces/query_part_interface.dart';

class OrderBy implements QueryPartInterface {
  final String column;
  final Order order;

  OrderBy({required this.column, this.order = Order.asc});

  @override
  String writeQuery() => '$column ${order.name.toUpperCase()}';
}
