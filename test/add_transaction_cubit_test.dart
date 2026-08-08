import 'package:flutter_test/flutter_test.dart';
import 'package:masroufy/data/local/isar_service.dart';
import 'package:masroufy/features/add_transaction/presentation/cubit/add_transaction_cubit.dart';

void main() {
  test('switching to income uses an income category', () {
    final cubit = AddTransactionCubit(IsarService());

    cubit.toggleType(true);
    expect(cubit.state.selectedCategory, 'food');

    cubit.toggleType(false);
    expect(cubit.state.selectedCategory, 'salary');
  });
}
