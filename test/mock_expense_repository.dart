import 'package:expense_tracker/data/datasources/local/expense_local_datasource.dart';
import 'package:expense_tracker/data/repositories/expense_repository_impl.dart';
import 'package:expense_tracker/domain/repositories/expense_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:hive/hive.dart';


@GenerateMocks([ExpenseRepositoryImpl,ExpenseRepository, ExpenseLocalDatasource, Box])
void main() {}
