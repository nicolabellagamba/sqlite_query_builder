class JoinCondition {
  final String firstColumn;
  final String secondColumn;

  JoinCondition({required this.firstColumn, required this.secondColumn});

  String writeClause() => '$firstColumn = $secondColumn';
}
