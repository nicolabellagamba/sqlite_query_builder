import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite_query_builder/enumerators/order.dart';
import 'package:sqlite_query_builder/models/join.dart';
import 'package:sqlite_query_builder/models/join_condition.dart';
import 'package:sqlite_query_builder/models/query_builder.dart';
import 'package:sqlite_query_builder/models/where.dart';

void main() {
  test('check query builder write method', () {
    final QueryBuilder queryBuilder = QueryBuilder.select();

    queryBuilder
      ..addJoin(
        join: InnerJoin(
          tableName: 'table_2',
          tableAlias: 't2',
          joinClause: JoinClause(
            firstColumn: 't1.column_1',
            secondColumn: 't2.column_2',
          ),
        ),
      )
      ..setClause(
        clause: WhereGroup.and(
          clauses: [
            Where.equal(column: 'test', param: 12),
            WhereGroup.or(clauses: [
              Where.greater(column: 'test_1', param: 46),
              Where.greater(column: 'test_1', param: '47'),
              Where.between(column: 'test_4', lowerBound: 34, upperBound: 'tre')
            ]),
          ],
        ),
      )
      ..addOrderBy(column: 'test', order: Order.desc)
      ..addOrderBy(column: 'test_1')
      ..setLimit(limit: 12);

    expect(queryBuilder.writeQuery(), ' ORDER BY test DESC, test_1 ASC');
  });
}
