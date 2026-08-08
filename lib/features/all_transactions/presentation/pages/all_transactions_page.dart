import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../data/local/isar_service.dart';
import '../../../add_transaction/presentation/cubit/add_transaction_cubit.dart';
import '../../../add_transaction/presentation/pages/add_transaction_sheet.dart';
import '../cubit/all_transactions_cubit.dart';
import '../cubit/all_transactions_state.dart';

class AllTransactionsPage extends StatelessWidget {
  const AllTransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AllTransactionsCubit, AllTransactionsState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: context.isDark
              ? AppColors.darkBackground
              : Colors.white,
          body: Column(
            children: [
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(context.tr('all_transactions'),
                        style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: context.isDark
                                ? AppColors.textDarkPrimary
                                : AppColors.textPrimary)),
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        color: context.isDark
                            ? AppColors.surfaceDark
                            : AppColors.bgLight,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: TextField(
                        onChanged: (q) => context
                            .read<AllTransactionsCubit>()
                            .setSearchQuery(q),
                        style: GoogleFonts.poppins(fontSize: 14),
                        decoration: InputDecoration(
                          hintText: context.tr('search_transactions'),
                          prefixIcon: const Icon(Icons.search,
                              size: 20, color: AppColors.textSecondary),
                          suffixIcon: state.searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.close, size: 18),
                                  onPressed: () => context
                                      .read<AllTransactionsCubit>()
                                      .setSearchQuery(''))
                              : null,
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                  ],
                ),
              ),
              SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    _chip(
                        context.tr('all'),
                        'all',
                        state.activeFilter,
                        () => context
                            .read<AllTransactionsCubit>()
                            .setFilter('all'),
                        context),
                    const SizedBox(width: 8),
                    _chip(
                        context.tr('expenses_filter'),
                        'expense',
                        state.activeFilter,
                        () => context
                            .read<AllTransactionsCubit>()
                            .setFilter('expense'),
                        context,
                        color: AppColors.expense),
                    const SizedBox(width: 8),
                    _chip(
                        context.tr('income_filter'),
                        'income',
                        state.activeFilter,
                        () => context
                            .read<AllTransactionsCubit>()
                            .setFilter('income'),
                        context,
                        color: AppColors.income),
                    ...AppConstants.categories.map((cat) => Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: _chip(
                            '${cat['emoji']} ${(cat['name'] as String).localizedCategoryName(context)}',
                            cat['name'] as String,
                            state.activeFilter,
                            () => context
                                .read<AllTransactionsCubit>()
                                .setFilter(cat['name'] as String),
                            context,
                            color: cat['color'] as Color,
                          ),
                        )),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: state.isLoading
                    ? const Center(
                        child:
                            CircularProgressIndicator(color: AppColors.primary))
                    : state.filteredTransactions.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.inbox_outlined,
                                    size: 48,
                                    color: AppColors.textSecondary
                                        .withValues(alpha: 0.5)),
                                const SizedBox(height: 12),
                                Text(context.tr('no_data'),
                                    style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: AppColors.textSecondary)),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            itemCount: state.filteredTransactions.length,
                            itemBuilder: (context, index) {
                              final t = state.filteredTransactions[index];
                              return Dismissible(
                                key: ValueKey(t.id),
                                direction: DismissDirection.endToStart,
                                confirmDismiss: (dir) async {
                                  if (dir == DismissDirection.endToStart) {
                                    return await showDialog(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title: Text(
                                            context.tr('delete_transaction'),
                                            style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w600)),
                                        content: Text(
                                            context.tr('delete_confirmation'),
                                            style: GoogleFonts.poppins()),
                                        actions: [
                                          TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(ctx, false),
                                              child: Text(context.tr('cancel'),
                                                  style:
                                                      GoogleFonts.poppins())),
                                          TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(ctx, true),
                                              child: Text(context.tr('delete'),
                                                  style: GoogleFonts.poppins(
                                                      color:
                                                          AppColors.expense)))
                                        ],
                                      ),
                                    );
                                  }
                                  return false;
                                },
                                onDismissed: (_) => context
                                    .read<AllTransactionsCubit>()
                                    .deleteTransaction(t.id),
                                background: Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.only(left: 24),
                                  decoration: BoxDecoration(
                                      color: AppColors.expense,
                                      borderRadius: BorderRadius.circular(14)),
                                  child: const Icon(Icons.delete_outline,
                                      color: Colors.white),
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      builder: (_) => BlocProvider.value(
                                        value:
                                            AddTransactionCubit(IsarService()),
                                        child:
                                            AddTransactionSheet(transaction: t),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 10),
                                    padding: const EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                      color: context.isDark
                                          ? AppColors.surfaceDark
                                          : AppColors.cardLight,
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(
                                          color: context.isDark
                                              ? Colors.white
                                                  .withValues(alpha: 0.05)
                                              : AppColors.divider),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 44,
                                          height: 44,
                                          decoration: BoxDecoration(
                                            color: t.category.categoryColor
                                                .withValues(alpha: 0.12),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(t.category.categoryEmoji,
                                              style: const TextStyle(
                                                  fontSize: 22)),
                                        ),
                                        const SizedBox(width: 14),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
Text(t.localizedTitle(context),
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                              const SizedBox(height: 3),
Row(
                                                children: [
                                                  Text(
                                                      t.category
                                                          .localizedCategoryName(
                                                              context),
                                                      style: GoogleFonts.poppins(
                                                          fontSize: 11,
                                                          color: AppColors
                                                              .textSecondary)),
                                                  const SizedBox(width: 8),
                                                  Text(
                                                      t.date.relativeDate(
                                                          context),
                                                      style: GoogleFonts.poppins(
                                                          fontSize: 11,
                                                          color: AppColors
                                                              .textSecondary)),
                                                ],
                                              ),
                                              if (t.note != null &&
                                                  t.note!.isNotEmpty) ...[
                                                const SizedBox(height: 3),
                                                Row(
                                                  children: [
                                                    const Icon(
                                                        Icons.edit_note_outlined,
                                                        size: 12,
                                                        color: AppColors
                                                            .textSecondary),
                                                    const SizedBox(width: 4),
                                                    Expanded(
                                                      child: Text(
                                                        t.note!,
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: GoogleFonts.poppins(
                                                            fontSize: 11,
                                                            color: AppColors
                                                                .textSecondary,
                                                            fontStyle: FontStyle
                                                                .italic),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ],
                                          ),
                                        ),
                                        Directionality(
                                          textDirection: TextDirection.ltr,
                                          child: Text(
                                            '${t.type == 'expense' ? '-' : '+'}${t.amount.formattedAmount}',
                                            style: GoogleFonts.poppins(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: t.type == 'expense'
                                                  ? AppColors.expense
                                                  : AppColors.income,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _chip(String label, String value, String active, VoidCallback onTap,
      BuildContext context,
      {Color? color}) {
    final isSelected = active == value;
    final c = color ?? AppColors.primary;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? c.withValues(alpha: 0.12) : null,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: isSelected ? c : AppColors.divider,
              width: isSelected ? 1.5 : 1),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: isSelected ? c : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
