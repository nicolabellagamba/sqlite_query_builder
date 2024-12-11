import 'package:sqlite_query_builder/interfaces/query_part_interface.dart';

class Table implements QueryPartInterface {
  final String name;
  final String? alias;

  Table({required this.name, this.alias});

  @override
  String writeQuery() => '$name${null != alias ? ' AS $alias' : ''}';
}
