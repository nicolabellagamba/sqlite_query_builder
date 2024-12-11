import 'package:sqlite_query_builder/models/join_condition.dart';
import 'package:sqlite_query_builder/models/table.dart';

sealed class Join {
  final Table table;
  final JoinCondition joinCondition;

  Join({required this.table, required this.joinCondition});
}

class InnerJoin extends Join {
  InnerJoin({required super.table, required super.joinCondition});
}

class LeftJoin extends Join {
  LeftJoin({required super.table, required super.joinCondition});
}

class RightJoin extends Join {
  RightJoin({required super.table, required super.joinCondition});
}
