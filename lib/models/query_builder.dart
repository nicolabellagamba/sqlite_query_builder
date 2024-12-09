import 'package:sqlite_query_builder/enumerators/order.dart';
import 'package:sqlite_query_builder/enumerators/query_type.dart';
import 'package:sqlite_query_builder/models/join.dart';
import 'package:sqlite_query_builder/models/order_by.dart';
import 'package:sqlite_query_builder/models/where.dart';

class QueryBuilder {
  final QueryType _type;
  final List<Join> _joinList = [];
  WhereElement? _clause;
  final List<OrderBy> _orderByList = [];
  final List<String> _groupByList = [];
  int? _limit;

  QueryBuilder.select() : _type = QueryType.select;

  void addJoin({required Join join}) {
    _joinList.add(join);
  }

  void setClause({required WhereElement clause}) {
    _clause = clause;
  }

  void addOrderBy({required String column, Order order = Order.asc}) {
    _orderByList.add(OrderBy(column: column, order: order));
  }

  void setLimit({required int limit}) {
    _limit = limit;
  }

  String writeQuery() {
    String queryString = switch (_type) {
      QueryType.select => '',
      QueryType.insert => throw UnimplementedError(),
      QueryType.update => throw UnimplementedError(),
      QueryType.delete => throw UnimplementedError(),
    };

    if (_joinList.isNotEmpty) {
      queryString += _joinList.map((Join join) {
        return ' ${switch (join) {
          InnerJoin() => 'INNER JOIN',
          LeftJoin() => 'LEFT JOIN',
          RightJoin() => 'RIGHT JOIN',
        }} ${join.tableName}${null != join.tableAlias ? ' AS ${join.tableAlias}' : ''} ON ${join.joinCondition.writeClause()}';
      }).join(' ');
    }

    // add where clause to query string if set.
    if (null != _clause) {
      queryString += ' WHERE ${_clause!.writeClause()}';
    }

    // add order by part to query string.
    if (_orderByList.isNotEmpty) {
      queryString += ' ORDER BY ${_orderByList.map((OrderBy orderBy) => "${orderBy.column} ${orderBy.order.name.toUpperCase()}").join(', ')}';
    }

    // add group by part to query string.
    if (_groupByList.isNotEmpty) {
      queryString += 'GROUP BY ${_groupByList.join(', ')}';
    }

    // add limit to query string.
    if (null != _limit) {
      queryString += ' LIMIT $_limit';
    }

    return queryString;
  }
}
