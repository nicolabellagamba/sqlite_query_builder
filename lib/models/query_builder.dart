import 'package:sqlite_query_builder/enumerators/order.dart';
import 'package:sqlite_query_builder/exceptions/query_builder_exception.dart';
import 'package:sqlite_query_builder/models/column.dart';
import 'package:sqlite_query_builder/models/conditions.dart';
import 'package:sqlite_query_builder/models/join.dart';
import 'package:sqlite_query_builder/models/order_by.dart';
import 'package:sqlite_query_builder/models/table.dart';

class QueryBuilder {
  bool _distinct = false;
  final List<dynamic> _columns = [];
  Table? _table;
  final List<Join> _joinList = [];
  BaseCondition? _where;
  final List<OrderBy> _orderByList = [];
  final List<String> _groupByList = [];
  BaseCondition? _having;
  int? _limit;

  void select({List<dynamic> columns = const [], bool distinct = false}) {
    _columns.addAll(columns);
    _distinct = distinct;
  }

  void from({required Table table}) {
    _table = table;
  }

  void addJoin({required Join join}) {
    _joinList.add(join);
  }

  void where({required BaseCondition where}) {
    _where = where;
  }

  void addOrderBy({required String column, Order order = Order.asc}) {
    _orderByList.add(OrderBy(column: column, order: order));
  }

  void addGroupBy({required String column}) {
    _groupByList.add(column);
  }

  void having({required BaseCondition having}) {
    _having = having;
  }

  void setLimit({required int limit}) {
    _limit = limit;
  }

  String writeQuery() {
    String queryString = 'SELECT';

    if (_distinct) {
      queryString += ' DISTINCT';
    }

    queryString += _columns.isNotEmpty
        ? _columns
            .map((dynamic element) => switch (element.runtimeType) {
                  const (String) => element,
                  const (Column) => (element as Column).writeQuery(),
                  _ => throw QueryBuilderException('${element.runtimeType} is not supported.'),
                })
            .join(', ')
        : '*';

    if (null != _table) {
      queryString += ' FROM ${_table!.writeQuery()}';
    } else {
      throw QueryBuilderException('No table supplied, query cannot be executed.');
    }

    if (_joinList.isNotEmpty) {
      queryString += _joinList.map((Join join) {
        return ' ${switch (join) {
          InnerJoin() => 'INNER JOIN',
          LeftJoin() => 'LEFT JOIN',
          RightJoin() => 'RIGHT JOIN',
        }} ${join.table.name}${null != join.table.alias ? ' AS ${join.table.alias}' : ''} ON ${join.joinCondition.writeQuery()}';
      }).join(' ');
    }

    // add where clause to query string if set.
    if (null != _where) {
      queryString += ' WHERE ${_where!.writeQuery()}';
    }

    // add order by part to query string.
    if (_orderByList.isNotEmpty) {
      queryString += ' ORDER BY ${_orderByList.map((OrderBy orderBy) => "${orderBy.column} ${orderBy.order.name.toUpperCase()}").join(', ')}';
    }

    // add group by part to query string.
    if (_groupByList.isNotEmpty) {
      queryString += 'GROUP BY ${_groupByList.join(', ')}';
    }

    // add having clause to query string if set.
    if (null != _having) {
      queryString += ' HAVING ${_where!.writeQuery()}';
    }

    // add limit to query string.
    if (null != _limit) {
      queryString += ' LIMIT $_limit';
    }

    return queryString;
  }
}
