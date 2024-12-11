import 'package:sqlite_query_builder/interfaces/query_part_interface.dart';

class JoinCondition implements QueryPartInterface {
  final String firstColumn;
  final String secondColumn;

  JoinCondition({required this.firstColumn, required this.secondColumn});
  
  @override
  String writeQuery() => '$firstColumn = $secondColumn';
}
