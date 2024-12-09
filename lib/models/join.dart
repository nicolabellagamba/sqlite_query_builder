import 'package:sqlite_query_builder/models/join_condition.dart';

sealed class Join {
  final String tableName;
  final String? tableAlias;
  final JoinCondition joinCondition;

  Join({required this.tableName, this.tableAlias, required this.joinCondition});
}

class InnerJoin extends Join {
  InnerJoin({required super.tableName, super.tableAlias, required super.joinCondition});
}

class LeftJoin extends Join {
  LeftJoin({required super.tableName, super.tableAlias, required super.joinCondition});
}

class RightJoin extends Join {
  RightJoin({required super.tableName, super.tableAlias, required super.joinCondition});
}
