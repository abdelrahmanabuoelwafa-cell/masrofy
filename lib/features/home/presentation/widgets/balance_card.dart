import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/extensions.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';

class BalanceCard extends StatelessWidget {
  const BalanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final budget = state.settings?.monthlyBudget ?? 0;
        final remaining = budget - state.totalExpense;
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: AppColors.balanceGradient,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(context.tr('balance_current'),
                  style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withValues(alpha: 0.85))),
              const SizedBox(height: 8),
              Directionality(
                textDirection: TextDirection.ltr,
                child: Text(
                  '${state.balance >= 0 ? '' : '-'}${state.balance.abs().formattedAmount}',
                  style: GoogleFonts.poppins(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: -0.5),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  _buildInfoRow(Icons.arrow_upward_rounded,
                      context.tr('expense_label'), state.totalExpense,
                      isExpense: true),
                  const SizedBox(width: 16),
                  _buildInfoRow(Icons.account_balance,
                      context.tr('income_label'), state.totalIncome,
                      isExpense: false),
                ],
              ),
              if (budget > 0) ...[
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        remaining >= 0
                            ? Icons.savings_outlined
                            : Icons.error_outline,
                        size: 18,
                        color: remaining >= 0
                            ? const Color(0xFFA7F3D0)
                            : const Color(0xFFFED7D7),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          context.tr('remaining_budget'),
                          style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.white.withValues(alpha: 0.85)),
                        ),
                      ),
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: Text(
                          '${remaining >= 0 ? '' : '-'}${remaining.abs().formattedAmount}',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: remaining >= 0
                                ? const Color(0xFFA7F3D0)
                                : const Color(0xFFFED7D7),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(IconData icon, String label, double amount,
      {bool isExpense = false}) {
final Color bgColor = isExpense
        ? AppColors.expense.withValues(alpha: 0.25)
        : AppColors.income.withValues(alpha: 0.25);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(14)),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8)),
              child: Icon(icon, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${isExpense ? '-' : '+'}$label',
                      style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: Colors.white.withValues(alpha: 0.8))),
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: Text(
                      '${isExpense ? '-' : '+'}${amount.formattedAmount}',
                      style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
