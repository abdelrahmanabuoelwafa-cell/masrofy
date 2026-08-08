import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../data/models/transaction_model.dart';
import '../../../home/presentation/cubit/home_cubit.dart';
import '../cubit/add_transaction_cubit.dart';
import '../cubit/add_transaction_state.dart';
import '../widgets/category_chips.dart';
import '../widgets/date_picker_widget.dart';

class AddTransactionSheet extends StatefulWidget {
  final TransactionModel? transaction;
  const AddTransactionSheet({super.key, this.transaction});

  @override
  State<AddTransactionSheet> createState() => _AddTransactionSheetState();
}

class _AddTransactionSheetState extends State<AddTransactionSheet> {
  String? _selectedCurrencyCode;
  String? _selectedCurrencyName;
  final _rateController = TextEditingController();
  final _foreignAmountController = TextEditingController();
  final _noteController = TextEditingController();
  double _calculatedEGP = 0;

  static const _currencies = [
    {'code': 'SAR', 'flag': '🇸🇦'},
    {'code': 'USD', 'flag': '🇺🇸'},
    {'code': 'AED', 'flag': '🇦🇪'},
    {'code': 'EUR', 'flag': '🇪🇺'},
  ];

  @override
  void initState() {
    super.initState();
    if (widget.transaction != null) {
      final t = widget.transaction!;
      final cubit = context.read<AddTransactionCubit>();
      cubit.toggleType(t.type == 'expense');
      cubit.setAmount(t.amount);
      cubit.selectCategory(t.category);
      cubit.setDate(t.date);
      cubit.setTitle(t.title);
      if (t.note != null) {
        _noteController.text = t.note!;
        cubit.setNote(t.note!);
      }
    }
  }

  @override
  void dispose() {
    _rateController.dispose();
    _foreignAmountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final isDark = context.isDark;

    return Container(
      height: MediaQuery.of(context).size.height * 0.92,
      decoration: BoxDecoration(
          color: isDark ? AppColors.bgDark : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28))),
      child: BlocConsumer<AddTransactionCubit, AddTransactionState>(
        listener: (context, state) {
          if (state.isSaved) {
            HapticFeedback.mediumImpact();
            Navigator.pop(context);
            context.read<HomeCubit>().loadHomeData();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(children: [
                  const Icon(Icons.check_circle, color: Colors.white),
                  const SizedBox(width: 8),
                  Text(context.tr('success_saved'),
                      style: GoogleFonts.poppins(color: Colors.white)),
                ]),
                backgroundColor: AppColors.income,
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 2),
              ),
            );
          }
if (state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(context.tr(state.error!)),
                  backgroundColor: AppColors.expense,
                  behavior: SnackBarBehavior.floating),
            );
            context.read<AddTransactionCubit>().clearError();
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: EdgeInsets.only(
                left: 20, right: 20, top: 12, bottom: bottomInset + 16),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Center(
                  child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                          color: AppColors.disabled,
                          borderRadius: BorderRadius.circular(4)))),
              Text(
                  widget.transaction != null
                      ? context.tr('save_changes')
                      : context.tr('add_transaction'),
                  style: GoogleFonts.poppins(
                      fontSize: 20, fontWeight: FontWeight.w600)),
              const SizedBox(height: 20),

              // Type Toggle
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                    color: isDark ? AppColors.surfaceDark : AppColors.bgLight,
                    borderRadius: BorderRadius.circular(14)),
                child: Row(children: [
                  Expanded(
                      child: _typeButton(
                          context.tr('expense'),
                          state.isExpense,
                          AppColors.expense,
                          () => context
                              .read<AddTransactionCubit>()
                              .toggleType(true))),
                  Expanded(
                      child: _typeButton(
                          context.tr('income'),
                          !state.isExpense,
                          AppColors.income,
                          () => context
                              .read<AddTransactionCubit>()
                              .toggleType(false))),
                ]),
              ),
              const SizedBox(height: 20),

              // Amount
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: (state.isExpense
                          ? AppColors.expenseLight
                          : AppColors.incomeLight)
                      .withValues(alpha: isDark ? 0.1 : 1.0),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: (state.isExpense
                              ? AppColors.expense
                              : AppColors.income)
                          .withValues(alpha: 0.2)),
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(context.tr('amount'),
                          style: GoogleFonts.poppins(
                              fontSize: 13, color: AppColors.textSecondary)),
                      const SizedBox(height: 8),
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Expanded(
                                child: TextField(
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              onChanged: (val) {
                                final parsed = double.tryParse(val);
                                if (parsed != null && parsed >= 0) {
                                  context
                                      .read<AddTransactionCubit>()
                                      .setAmount(parsed);
                                }
                              },
                              style: GoogleFonts.poppins(
                                  fontSize: 38,
                                  fontWeight: FontWeight.w700,
                                  color: state.isExpense
                                      ? AppColors.expense
                                      : AppColors.income),
                              decoration: const InputDecoration.collapsed(
                                  hintText: '0.00'),
                            )),
                            const SizedBox(width: 8),
                            Text(context.tr('currency_egp'),
                                style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textSecondary)),
                          ]),
                    ]),
              ),
              const SizedBox(height: 20),

              // Categories
              Text(context.tr('category'),
                  style: GoogleFonts.poppins(
                      fontSize: 13, color: AppColors.textSecondary)),
              const SizedBox(height: 10),
              CategoryChips(
                  selectedCategory: state.selectedCategory,
                  isExpense: state.isExpense,
                  onSelected: (cat) =>
                      context.read<AddTransactionCubit>().selectCategory(cat)),
              const SizedBox(height: 16),
              const Divider(color: Color(0xFFE0E0E0), height: 1),
              const SizedBox(height: 12),
              Center(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.currency_exchange,
                      size: 18, color: AppColors.primary),
                  label: Text(context.tr('add_in_different_currency'),
                      style: GoogleFonts.poppins(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                  ),
                  onPressed: _showCurrencySheet,
                ),
              ),
              if (_selectedCurrencyCode != null)
                AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: _currencyFields(context),
                ),

              const SizedBox(height: 16),

              // Note
              TextField(
                controller: _noteController,
                onChanged: (val) =>
                    context.read<AddTransactionCubit>().setNote(val),
                style: GoogleFonts.poppins(fontSize: 14),
                decoration: InputDecoration(
                    hintText: context.tr('add_note'),
                    prefixIcon: const Icon(Icons.edit_note_outlined, size: 20)),
              ),
              const SizedBox(height: 20),

              // Date
              DatePickerWidget(
                  selectedDate: state.selectedDate,
                  onDateChanged: (d) =>
                      context.read<AddTransactionCubit>().setDate(d)),
              const SizedBox(height: 28),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: state.isSaving
                      ? null
                      : () {
                          if (widget.transaction != null) {
                            context
                                .read<AddTransactionCubit>()
                                .updateTransaction(widget.transaction!);
                          } else {
                            context
                                .read<AddTransactionCubit>()
                                .saveTransaction();
                          }
                        },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: state.isExpense
                          ? AppColors.expense
                          : AppColors.income,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16))),
                  child: state.isSaving
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2.5))
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                              const Icon(Icons.check_circle,
                                  color: Colors.white, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                  widget.transaction != null
                                      ? context.tr('save_changes')
                                      : context.tr('save'),
                                  style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white)),
                            ]),
                ),
              ),
              const SizedBox(height: 8),
            ]),
          );
        },
      ),
    );
  }

  Widget _typeButton(
      String label, bool isSelected, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(vertical: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.transparent,
          borderRadius: BorderRadius.circular(11),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                      color: color.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4))
                ]
              : null,
        ),
        child: Text(label,
            style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : AppColors.textSecondary)),
      ),
    );
  }

  String _currencyKey(String code) => code.toLowerCase();

  void _showCurrencySheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(context.tr('select_currency'),
                  style: GoogleFonts.poppins(
                      fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            for (final c in _currencies)
              ListTile(
                leading:
                    Text(c['flag']!, style: GoogleFonts.poppins(fontSize: 28)),
                title: Text(context.tr(_currencyKey(c['code']!)),
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                trailing: Text(c['code']!,
                    style: GoogleFonts.poppins(color: AppColors.textSecondary)),
                onTap: () {
                  Navigator.pop(ctx);
                  _selectCurrency(
                      c['code']!, context.tr(_currencyKey(c['code']!)));
                },
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _selectCurrency(String code, String name) {
    setState(() {
      _selectedCurrencyCode = code;
      _selectedCurrencyName = name;
      _rateController.clear();
      _foreignAmountController.clear();
      _calculatedEGP = 0;
    });
    _syncToCubit();
  }

  void _clearCurrency() {
    setState(() {
      _selectedCurrencyCode = null;
      _selectedCurrencyName = null;
      _rateController.clear();
      _foreignAmountController.clear();
      _calculatedEGP = 0;
    });
    _syncToCubit();
  }

  void _recalculate() {
    final rate = double.tryParse(_rateController.text) ?? 0;
    final amount = double.tryParse(_foreignAmountController.text) ?? 0;
    setState(() => _calculatedEGP = rate * amount);
    _syncToCubit();
  }

  void _syncToCubit() {
    final cubit = context.read<AddTransactionCubit>();
    if (_selectedCurrencyCode == null) {
      cubit.setMultiCurrency(null, null, null, null);
    } else {
      cubit.setMultiCurrency(
        double.tryParse(_foreignAmountController.text),
        _selectedCurrencyCode,
        _selectedCurrencyName,
        double.tryParse(_rateController.text),
      );
    }
  }

  Widget _currencyFields(BuildContext context) {
    final isDark = context.isDark;
    final rate = double.tryParse(_rateController.text.trim()) ?? 0;
    final foreign = double.tryParse(_foreignAmountController.text.trim()) ?? 0;
    final totalEGP = rate * foreign;
    final currencyName = _selectedCurrencyName ?? context.tr('currency');
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.primaryLight : const Color(0xFFF5F3FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: const Icon(Icons.close, size: 20),
              onPressed: _clearCurrency,
            ),
          ),
          const SizedBox(height: 8),
          Text('${context.tr('exchange_rate')} ($_selectedCurrencyCode)',
              style: GoogleFonts.poppins(
                  fontSize: 13, color: AppColors.textSecondary)),
          const SizedBox(height: 8),
TextField(
            controller: _rateController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black),
            decoration: InputDecoration(
              hintText: context.tr('exchange_rate_hint'),
              hintStyle: GoogleFonts.poppins(color: AppColors.textMuted),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none),
            ),
            onChanged: (_) => _recalculate(),
          ),
          const SizedBox(height: 12),
          Text('${context.tr('amount_in_currency')} $_selectedCurrencyName',
              style: GoogleFonts.poppins(
                  fontSize: 13, color: AppColors.textSecondary)),
          const SizedBox(height: 8),
TextField(
            controller: _foreignAmountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black),
            decoration: InputDecoration(
              hintText: context.tr('amount_in_currency_hint'),
              hintStyle: GoogleFonts.poppins(color: AppColors.textMuted),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none),
            ),
            onChanged: (_) => _recalculate(),
          ),
          const SizedBox(height: 16),
          if (foreign > 0 && rate > 0)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text('1 $currencyName = ${_rateController.text} ${context.tr('egp_short')}',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                      textAlign: TextAlign.center),
                  const SizedBox(height: 4),
                  Text('${totalEGP.toStringAsFixed(2)} ${context.tr('egp_full')}',
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF10B981)),
                      textAlign: TextAlign.center),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
