import 'package:sqlite_query_builder/enumerators/condition_group_type.dart';
import 'package:sqlite_query_builder/enumerators/condition_type.dart';
import 'package:sqlite_query_builder/exceptions/query_builder_exception.dart';
import 'package:sqlite_query_builder/interfaces/query_part_interface.dart';

sealed class BaseCondition implements QueryPartInterface {
}

class Condition extends BaseCondition {
  final String column;
  final dynamic param;
  final ConditionType type;

  Condition({required this.column, this.param, required this.type});

  Condition.equal({required this.column, required Object this.param}) : type = ConditionType.equal;

  Condition.notEqual({required this.column, required Object this.param}) : type = ConditionType.notEqual;

  Condition.greater({required this.column, required Object this.param}) : type = ConditionType.greater;

  Condition.greaterOrEqual({required this.column, required Object this.param}) : type = ConditionType.greaterOrEqual;

  Condition.lower({required this.column, required Object this.param}) : type = ConditionType.lower;

  Condition.lowerOrEqual({required this.column, required Object this.param}) : type = ConditionType.lowerOrEqual;

  Condition.like({required this.column, required Object this.param}) : type = ConditionType.lowerOrEqual;

  Condition.between({required this.column, required Object lowerBound, required Object upperBound})
      : type = ConditionType.between,
        param = {'lowerBound': lowerBound, 'upperBound': upperBound};

  Condition.isNull({required this.column})
      : type = ConditionType.isNull,
        param = null;

  Condition.isNotNull({required this.column})
      : type = ConditionType.isNotNull,
        param = null;

  Condition.inGroup({required this.column, required List<Object> this.param}) : type = ConditionType.inGroup;

  Condition.notInGroup({required this.column, required List<Object> this.param}) : type = ConditionType.inGroup;

  dynamic _maybeQuoteParam(dynamic param) => param is String ? '"$param"' : param;

  @override
  String writeQuery() {
    final dynamic maybeQuotedParam = _maybeQuoteParam(param);

    return '$column ${switch (type) {
      ConditionType.equal => '= $maybeQuotedParam',
      ConditionType.notEqual => '!= $maybeQuotedParam',
      ConditionType.greater => '> $maybeQuotedParam',
      ConditionType.greaterOrEqual => '>= $maybeQuotedParam',
      ConditionType.lower => '< $maybeQuotedParam',
      ConditionType.lowerOrEqual => '<= $maybeQuotedParam',
      ConditionType.like => 'LIKE $maybeQuotedParam',
      ConditionType.notLike => 'NOT LIKE $maybeQuotedParam',
      ConditionType.between => 'BETWEEN ${_maybeQuoteParam(param['lowerBound'])} AND ${_maybeQuoteParam(param['upperBound'])}',
      ConditionType.isNull => 'IS NULL',
      ConditionType.isNotNull => 'IS NOT NULL',
      ConditionType.inGroup => 'IN (${(param as List<dynamic>).map(_maybeQuoteParam).join(', ')})',
      ConditionType.notInGroup => 'NOT IN (${(param as List<dynamic>).map(_maybeQuoteParam).join(', ')})',
    }}';
  }
}

class ConditionGroup extends BaseCondition {
  final List<BaseCondition> clauses;
  final ConditionGroupType type;

  ConditionGroup.and({this.clauses = const []}) : type = ConditionGroupType.and;

  ConditionGroup.or({this.clauses = const []}) : type = ConditionGroupType.or;

  @override
  String writeQuery() {
    if (clauses.isEmpty) {
      throw QueryBuilderException('Attempting to write an empty condition $type group');
    }

    return '(${clauses.map((BaseCondition clause) => clause.writeQuery()).join(' ${type.name.toUpperCase()} ')})';
  }
}
