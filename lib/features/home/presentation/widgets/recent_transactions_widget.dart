import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../data/local/isar_service.dart';
import '../../../../data/models/transaction_model.dart';
import '../../../add_transaction/presentation/cubit/add_transaction_cubit.dart';
import '../../../add_transaction/presentation/pages/add_transaction_sheet.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';

class RecentTransactionsWidget extends StatelessWidget {
  const RecentTransactionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state.recentTransactions.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Column(
                children: [
                  Icon(Icons.receipt_long_outlined,
                      size: 48,
                      color: AppColors.textSecondary.withValues(alpha: 0.5)),
                  const SizedBox(height: 12),
                  Text(context.tr('no_transactions'),
                      style: GoogleFonts.poppins(
                          fontSize: 14, color: AppColors.textSecondary)),
                  const SizedBox(height: 4),
                  Text(context.tr('add_first_transaction'),
                      style: GoogleFonts.poppins(
                          fontSize: 12,
                          color:
                              AppColors.textSecondary.withValues(alpha: 0.7))),
                ],
              ),
            ),
          );
        }

        return Column(
          children: state.recentTransactions
              .map((t) => _TransactionTile(transaction: t))
              .toList(),
        );
      },
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final TransactionModel transaction;
  const _TransactionTile({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final isExpense = transaction.type == 'expense';
    final color = isExpense ? AppColors.expense : AppColors.income;

    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => BlocProvider.value(
            value: AddTransactionCubit(IsarService()),
            child: AddTransactionSheet(transaction: transaction),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : AppColors.cardLight,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.05)
                  : AppColors.divider),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: (isExpense ? AppColors.expenseLight : AppColors.incomeLight)
                    .withValues(alpha: isDark ? 0.15 : 1.0),
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Text(transaction.category.categoryEmoji,
                  style: const TextStyle(fontSize: 22)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
Text(transaction.localizedTitle(context),
                      style: GoogleFonts.poppins(
                          fontSize: 14, fontWeight: FontWeight.w500)),
                  if (transaction.note != null &&
                      transaction.note!.isNotEmpty) ...[
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        const Icon(Icons.edit_note_outlined,
                            size: 12, color: AppColors.textSecondary),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            transaction.note!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                                fontSize: 11,
                                color: AppColors.textSecondary,
                                fontStyle: FontStyle.italic),
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 3),
                  Text(transaction.date.relativeDate(context),
                      style: GoogleFonts.poppins(
                          fontSize: 11, color: AppColors.textSecondary)),
                ],
              ),
            ),
            Directionality(
              textDirection: TextDirection.ltr,
              child: Text(
                '${isExpense ? '-' : '+'}${transaction.amount.formattedAmount}',
                style: GoogleFonts.poppins(
                    fontSize: 14, fontWeight: FontWeight.w600, color: color),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
