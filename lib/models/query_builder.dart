import 'package:sqlite_query_builder/enumerators/order.dart';
import 'package:sqlite_query_builder/exceptions/query_builder_exception.dart';
import 'package:sqlite_query_builder/models/join.dart';
import 'package:sqlite_query_builder/models/order_by.dart';
import 'package:sqlite_query_builder/models/table.dart';
import 'package:sqlite_query_builder/models/where.dart';

class QueryBuilder {
  List<String> _selectList = [];
  Table? _table;
  final List<Join> _joinList = [];
  WhereElement? _clause;
  final List<OrderBy> _orderByList = [];
  final List<String> _groupByList = [];
  int? _limit;

  void from({required Table table}) {
    _table = table;
  }

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
    String queryString = 'SELECT ${_selectList.isNotEmpty ? _selectList.join(', ') : '*'}';

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
    if (null != _clause) {
      queryString += ' WHERE ${_clause!.writeQuery()}';
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
