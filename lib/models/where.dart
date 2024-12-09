import 'package:sqlite_query_builder/enumerators/condition.dart';
import 'package:sqlite_query_builder/enumerators/where_group_type.dart';
import 'package:sqlite_query_builder/query_builder_exception.dart';

sealed class WhereElement {
  String writeClause();
}

class Where extends WhereElement {
  final String column;
  final dynamic param;
  final Condition condition;

  Where({required this.column, this.param, required this.condition});

  Where.equal({required this.column, required Object this.param}) : condition = Condition.equal;

  Where.greater({required this.column, required Object this.param}) : condition = Condition.greater;

  Where.greaterOrEqual({required this.column, required Object this.param}) : condition = Condition.greaterOrEqual;

  Where.lower({required this.column, required Object this.param}) : condition = Condition.lower;

  Where.lowerOrEqual({required this.column, required Object this.param}) : condition = Condition.lowerOrEqual;

  Where.like({required this.column, required Object this.param}) : condition = Condition.lowerOrEqual;

  Where.between({required this.column, required Object lowerBound, required Object upperBound})
      : condition = Condition.between,
        param = {'lowerBound': lowerBound, 'upperBound': upperBound};

  Where.isNull({required this.column})
      : condition = Condition.isNull,
        param = null;

  Where.isNotNull({required this.column})
      : condition = Condition.isNotNull,
        param = null;

  dynamic _maybeQuoteParam({required dynamic param}) => param is String ? '"$param"' : param;

  @override
  String writeClause() {
    final dynamic maybeQuotedParam = _maybeQuoteParam(param: param);

    return '$column ${switch (condition) {
      Condition.equal => '= $maybeQuotedParam',
      Condition.greater => '> $maybeQuotedParam',
      Condition.greaterOrEqual => '>= $maybeQuotedParam',
      Condition.lower => '< $maybeQuotedParam',
      Condition.lowerOrEqual => '<= $maybeQuotedParam',
      Condition.like => 'LIKE "$maybeQuotedParam"',
      Condition.between => 'BETWEEN ${_maybeQuoteParam(param: param['lowerBound'])} AND ${_maybeQuoteParam(param: param['upperBound'])}',
      Condition.isNull => 'IS NULL',
      Condition.isNotNull => 'IS NOT NULL',
    }}';
  }
}

class WhereGroup extends WhereElement {
  final List<WhereElement> clauses;
  final WhereGroupType type;

  WhereGroup.and({this.clauses = const []}) : type = WhereGroupType.and;

  WhereGroup.or({this.clauses = const []}) : type = WhereGroupType.or;

  @override
  String writeClause() {
    if (clauses.isEmpty) {
      throw QueryBuilderException('Attempting to write an empty where $type group');
    }

    return '(${clauses.map((WhereElement clause) => clause.writeClause()).join(' ${type.name.toUpperCase()} ')})';
  }
}