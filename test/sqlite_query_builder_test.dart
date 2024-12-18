import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite_query_builder/enumerators/order.dart';
import 'package:sqlite_query_builder/models/join.dart';
import 'package:sqlite_query_builder/models/join_condition.dart';
import 'package:sqlite_query_builder/models/query_builder.dart';
import 'package:sqlite_query_builder/models/table.dart';
import 'package:sqlite_query_builder/models/conditions.dart';

void main() {
  test('check query builder write method', () {
    final QueryBuilder queryBuilder = QueryBuilder();

    queryBuilder
      ..from(table: Table(name: 'table_1', alias: 't1'))
      ..addJoin(
        join: InnerJoin(
          table: Table(name: 'table_2', alias: 't2'),
          joinCondition: JoinCondition(
            firstColumn: 't1.column_1',
            secondColumn: 't2.column_2',
          ),
        ),
      )
      ..where(
        where: ConditionGroup.and(
          clauses: [
            Condition.equal(column: 'test', param: 12),
            ConditionGroup.or(clauses: [
              Condition.greater(column: 'test_1', param: 46),
              Condition.greater(column: 'test_1', param: '47'),
              Condition.between(column: 'test_4', lowerBound: 34, upperBound: 'tre')
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
