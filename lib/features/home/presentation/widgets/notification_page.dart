import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/extensions.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        title: Text(context.tr('notifications_title'),
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all, color: AppColors.primary),
            tooltip: context.tr('mark_all_read'),
            onPressed: () async {
              final cubit = context.read<HomeCubit>();
              for (final n in cubit.state.notifications) {
                if (!n.isRead) {
                  await cubit.markNotificationRead(n.id);
                }
              }
              cubit.loadNotifications();
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_sweep_outlined,
                color: AppColors.expense),
            tooltip: context.tr('clear_notifications'),
            onPressed: () async {
              await context.read<HomeCubit>().clearNotifications();
            },
          ),
        ],
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state.notifications.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.notifications_off_outlined,
                      size: 56,
                      color: AppColors.textSecondary.withValues(alpha: 0.5)),
                  const SizedBox(height: 12),
                  Text(context.tr('no_notifications'),
                      style: GoogleFonts.poppins(
                          fontSize: 14, color: AppColors.textSecondary)),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.notifications.length,
            itemBuilder: (context, index) {
              final n = state.notifications[index];
              Color color = AppColors.warning;
              IconData icon = Icons.warning_amber_rounded;
              if (n.type == 'budget_exceeded') {
                color = AppColors.expense;
                icon = Icons.error_outline;
              } else if (n.type == 'info') {
                color = AppColors.info;
                icon = Icons.info_outline;
              }
return GestureDetector(
                onTap: () async {
                  if (!n.isRead) {
                    await context
                        .read<HomeCubit>()
                        .markNotificationRead(n.id);
                  }
                },
                child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDark : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.05)
                          : AppColors.divider),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(icon, color: color, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  n.title,
                                  style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: isDark
                                          ? AppColors.textDarkPrimary
                                          : AppColors.textPrimary),
                                ),
                              ),
                              if (!n.isRead)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                      color: AppColors.primary
                                          .withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Text(
                                    context.tr('notification_new'),
                                    style: GoogleFonts.poppins(
                                        fontSize: 10,
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(n.message,
                              style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: AppColors.textSecondary)),
                          const SizedBox(height: 6),
                          Text(
                            n.date.relativeDate(context),
                            style: GoogleFonts.poppins(
                                fontSize: 11,
                                color: AppColors.textMuted),
),
                        ],
                      ),
                    ),
                  ],
                ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
