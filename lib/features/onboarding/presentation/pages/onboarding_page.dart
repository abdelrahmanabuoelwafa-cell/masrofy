import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../data/local/isar_service.dart';
import '../../../../presentation/pages/main_page.dart';
import '../../../locale/presentation/cubit/locale_cubit.dart';
import '../../../locale/presentation/cubit/locale_state.dart';

class OnboardingPage extends StatefulWidget {
  final IsarService isarService;
  const OnboardingPage({super.key, required this.isarService});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final TextEditingController _nameController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String _errorMessage = '';
  String _selectedLanguage = 'ar';

  bool get _isValidName {
    final name = _nameController.text.trim();
    return name.isNotEmpty && name.length >= 2;
  }

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {});
    });
    _nameController.addListener(() {
      setState(() {
        _errorMessage = '';
      });
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _selectLanguage(String language) {
    setState(() {
      _selectedLanguage = language;
    });
    // Instantly change locale
    context.read<LocaleCubit>().setLanguage(language);
  }

  Future<void> _submitName() async {
    final name = _nameController.text.trim();

    if (name.isEmpty || name.length < 2) {
      setState(() {
        _errorMessage = context.tr('name_required');
      });
      return;
    }

    final userBox = Hive.box('user_box');
    await userBox.put('username', name);
    await userBox.put('language', _selectedLanguage);

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => MainPage(isarService: widget.isarService),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleCubit, LocaleState>(
      builder: (context, localeState) {
        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: AppColors.balanceGradient,
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height -
                        MediaQuery.of(context).padding.top -
                        MediaQuery.of(context).padding.bottom,
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            context.tr('enter_your_name'),
                            style: GoogleFonts.poppins(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 32),
                          // Language Selection
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _LanguageButton(
                                label: 'العربية',
                                isSelected: _selectedLanguage == 'ar',
                                onTap: () => _selectLanguage('ar'),
                              ),
                              const SizedBox(width: 16),
                              _LanguageButton(
                                label: 'English',
                                isSelected: _selectedLanguage == 'en',
                                onTap: () => _selectLanguage('en'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: _focusNode.hasFocus
                                    ? const Color(0xFF1E3A8A)
                                    : Colors.white.withValues(alpha: 0.3),
                                width: _focusNode.hasFocus ? 2 : 1,
                              ),
                              boxShadow: _focusNode.hasFocus
                                  ? [
                                      BoxShadow(
                                        color: const Color(0xFF1E3A8A)
                                            .withValues(alpha: 0.3),
                                        blurRadius: 12,
                                        offset: const Offset(0, 4),
                                      ),
                                    ]
                                  : [
                                      BoxShadow(
                                        color:
                                            Colors.black.withValues(alpha: 0.1),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                            ),
                            child: TextField(
                              controller: _nameController,
                              focusNode: _focusNode,
                              textAlign: TextAlign.center,
                              cursorColor: const Color(0xFF1E3A8A),
                              style: GoogleFonts.poppins(
                                fontSize: 22,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                              decoration: InputDecoration(
                                hintText: context.tr('name_placeholder'),
                                hintStyle: GoogleFonts.poppins(
                                  fontSize: 22,
                                  color: Colors.black.withValues(alpha: 0.5),
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 18,
                                ),
                              ),
                            ),
                          ),
                          if (_errorMessage.isNotEmpty) ...[
                            const SizedBox(height: 12),
                            Text(
                              _errorMessage,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.red.shade300,
                              ),
                            ),
                          ],
                          const SizedBox(height: 32),
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: _isValidName ? _submitName : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _isValidName
                                    ? Colors.white
                                    : Colors.white.withValues(alpha: 0.5),
                                foregroundColor: AppColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                context.tr('confirm'),
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: _isValidName
                                      ? AppColors.primary
                                      : AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _LanguageButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color:
              isSelected ? Colors.white : Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                isSelected ? Colors.white : Colors.white.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? AppColors.primary : Colors.white,
          ),
        ),
      ),
    );
  }
}
