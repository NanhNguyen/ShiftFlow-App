import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../di/di_config.dart';
import '../../../data/constant/enums.dart';
import 'cubit/schedule_form_cubit.dart';
import 'cubit/schedule_form_state.dart';
import '../../../resource/app_strings.dart';
import '../home/cubit/home_cubit.dart';
import '../../theme/app_theme.dart';

/// Shows the schedule registration form as a modal dialog.
/// Returns `true` if the form was submitted successfully, `null` otherwise.
Future<bool?> showScheduleFormModal(
  BuildContext context, {
  required bool isInitialRecurring,
}) {
  return showDialog<bool>(
    context: context,
    barrierColor: Colors.black87,
    builder: (dialogContext) =>
        ScheduleFormModal(isInitialRecurring: isInitialRecurring),
  );
}

class ScheduleFormModal extends StatelessWidget {
  final bool isInitialRecurring;

  const ScheduleFormModal({super.key, required this.isInitialRecurring});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<ScheduleFormCubit>()
            ..setInitialMode(isRecurring: isInitialRecurring),
      child: BlocConsumer<ScheduleFormCubit, ScheduleFormState>(
        listener: (context, state) {
          if (state.status == BaseStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(AppStrings.requestSubmitted),
                backgroundColor: InternaCrystal.accentGreen,
              ),
            );
            getIt<HomeCubit>().loadData();
            Navigator.of(context).pop(true);
          } else if (state.status == BaseStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.errorMessage ?? AppStrings.submissionFailed,
                ),
                backgroundColor: InternaCrystal.accentRed,
              ),
            );
          }
        },
        builder: (context, state) {
          final isRecurring = state.isRecurring;
          final isLoading = state.status == BaseStatus.loading;

          return Dialog(
            backgroundColor: InternaCrystal.bgDeep,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32),
              side: const BorderSide(color: InternaCrystal.borderSubtle, width: 1.5),
            ),
            clipBehavior: Clip.antiAlias,
            insetPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 24,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 520,
                maxHeight: MediaQuery.of(context).size.height * 0.9,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ── Header ──
                  Container(
                    padding: const EdgeInsets.fromLTRB(28, 28, 16, 24),
                    decoration: const BoxDecoration(
                      gradient: InternaCrystal.brandGradient,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isRecurring ? Icons.auto_mode_rounded : Icons.calendar_today_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            isRecurring
                                ? AppStrings.recurringLeave
                                : AppStrings.adhocLeave,
                            style: GoogleFonts.outfit(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => Navigator.of(context).pop(),
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.close_rounded, color: Colors.white, size: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ── Body ──
                  Flexible(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 28,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildToggleRow(context, state),
                          const SizedBox(height: 32),
                          _buildSectionTitle(
                            isRecurring
                                ? AppStrings.recurringDuration
                                : AppStrings.chooseDays,
                          ),
                          if (isRecurring)
                            Row(
                              children: [
                                Expanded(
                                  child: _buildDateCard(
                                    context,
                                    label: AppStrings.start,
                                    date: state.startDate ?? DateTime.now(),
                                    onTap: () => _pickDateResponsive(
                                      context,
                                      initialDate: state.startDate ?? DateTime.now(),
                                      onChanged: (date) => context
                                          .read<ScheduleFormCubit>()
                                          .updateField(startDate: date),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 12),
                                  child: const Icon(
                                    Icons.arrow_forward_rounded,
                                    color: InternaCrystal.textMuted,
                                    size: 20,
                                  ),
                                ),
                                Expanded(
                                  child: _buildDateCard(
                                    context,
                                    label: AppStrings.until,
                                    date: state.endDate ?? DateTime.now(),
                                    onTap: () => _pickDateResponsive(
                                      context,
                                      initialDate: state.endDate ?? DateTime.now(),
                                      minimumDate: state.startDate,
                                      onChanged: (date) => context
                                          .read<ScheduleFormCubit>()
                                          .updateField(endDate: date),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          else
                            _buildMultiDatePicker(context, state),
                          const SizedBox(height: 28),
                          if (isRecurring) ...[
                            _buildSectionTitle(AppStrings.repeatOn),
                            _buildWeekdaySelector(context, state),
                            const SizedBox(height: 28),
                          ],
                          _buildSectionTitle(AppStrings.shift),
                          _buildGlassDropdown(
                            context,
                            value: state.shift,
                            items: [
                              AppStrings.morning,
                              AppStrings.afternoon,
                              AppStrings.allDay,
                            ],
                            onChanged: (v) => context
                                .read<ScheduleFormCubit>()
                                .updateField(shift: v),
                          ),
                          const SizedBox(height: 28),
                          _buildSectionTitle(AppStrings.descriptionLabel),
                          TextField(
                            onChanged: (v) => context
                                .read<ScheduleFormCubit>()
                                .updateField(description: v),
                            maxLines: 4,
                            style: GoogleFonts.inter(
                              color: InternaCrystal.textPrimary,
                              fontSize: 15,
                            ),
                            decoration: InputDecoration(
                              hintText: AppStrings.addNotes,
                              hintStyle: GoogleFonts.inter(
                                color: InternaCrystal.textMuted,
                                fontSize: 15,
                              ),
                              prefixIcon: const Padding(
                                padding: EdgeInsets.only(bottom: 40),
                                child: Icon(
                                  Icons.notes_rounded,
                                  color: InternaCrystal.textSecondary,
                                  size: 22,
                                ),
                              ),
                              filled: true,
                              fillColor: InternaCrystal.bgCard,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(color: InternaCrystal.borderSubtle),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(color: InternaCrystal.borderSubtle),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(
                                  color: InternaCrystal.accentPurple,
                                  width: 2,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ── Footer ──
                  Container(
                    padding: const EdgeInsets.fromLTRB(28, 20, 28, 32),
                    decoration: const BoxDecoration(
                      color: InternaCrystal.bgDeep,
                      border: Border(
                        top: BorderSide(color: InternaCrystal.borderSubtle, width: 1),
                      ),
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: InternaCrystal.brandGradient,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: InternaCrystal.accentPurple.withOpacity(0.4),
                              blurRadius: 15,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : () => context.read<ScheduleFormCubit>().submit(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  height: 28,
                                  width: 28,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 3,
                                  ),
                                )
                              : Text(
                                  isRecurring
                                      ? AppStrings.submitLeave
                                      : AppStrings.confirmRegistration,
                                  style: GoogleFonts.outfit(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ──────────────────────────────────
  // Helper widgets
  // ──────────────────────────────────

  Widget _buildToggleRow(BuildContext context, ScheduleFormState state) {
    final isRecurring = state.isRecurring;
    return Container(
      decoration: BoxDecoration(
        color: InternaCrystal.bgCard,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: InternaCrystal.borderSubtle),
      ),
      padding: const EdgeInsets.all(6),
      child: Row(
        children: [
          _buildToggleBtn(
            context,
            label: AppStrings.recurringLeave,
            icon: Icons.auto_mode_rounded,
            selected: isRecurring,
            onTap: () => context.read<ScheduleFormCubit>().updateField(
                  isRecurring: true,
                ),
          ),
          _buildToggleBtn(
            context,
            label: AppStrings.adhocLeave,
            icon: Icons.calendar_view_day_rounded,
            selected: !isRecurring,
            onTap: () => context.read<ScheduleFormCubit>().updateField(
                  isRecurring: false,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleBtn(
    BuildContext context, {
    required String label,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            gradient: selected ? InternaCrystal.brandGradient : null,
            color: selected ? null : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: InternaCrystal.accentPurple.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: selected ? Colors.white : InternaCrystal.textSecondary,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: selected ? FontWeight.bold : FontWeight.w600,
                    color: selected ? Colors.white : InternaCrystal.textSecondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.outfit(
          fontSize: 13,
          fontWeight: FontWeight.w800,
          color: InternaCrystal.textSecondary,
          letterSpacing: 2.0,
        ),
      ),
    );
  }

  Widget _buildWeekdaySelector(BuildContext context, ScheduleFormState state) {
    final weekdayOptions = {
      'MONDAY': 'Th 2',
      'TUESDAY': 'Th 3',
      'WEDNESDAY': 'Th 4',
      'THURSDAY': 'Th 5',
      'FRIDAY': 'Th 6',
    };
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: weekdayOptions.entries.map((entry) {
        final dbKey = entry.key;
        final label = entry.value;
        final isSelected = state.selectedWeekdays.contains(dbKey);
        return InkWell(
          onTap: () => context.read<ScheduleFormCubit>().toggleWeekday(dbKey),
          borderRadius: BorderRadius.circular(12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected
                  ? InternaCrystal.accentPurple.withOpacity(0.2)
                  : InternaCrystal.bgCard,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? InternaCrystal.accentPurple
                    : InternaCrystal.borderSubtle,
                width: 1.5,
              ),
            ),
            child: Text(
              label,
              style: GoogleFonts.inter(
                color: isSelected
                    ? InternaCrystal.accentPurple
                    : InternaCrystal.textPrimary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMultiDatePicker(BuildContext context, ScheduleFormState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (state.selectedDates.isNotEmpty)
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: state.selectedDates
                .map(
                  (date) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: InternaCrystal.bgElevated,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: InternaCrystal.borderSubtle),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          DateFormat('dd/MM').format(date),
                          style: GoogleFonts.inter(
                            color: InternaCrystal.textPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () => context.read<ScheduleFormCubit>().toggleDate(date),
                          child: const Icon(
                            Icons.cancel_rounded,
                            color: InternaCrystal.accentRed,
                            size: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        const SizedBox(height: 12),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _pickDateResponsive(
              context,
              initialDate: DateTime.now(),
              onChanged: (picked) {
                context.read<ScheduleFormCubit>().toggleDate(picked);
              },
            ),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              width: double.infinity,
              decoration: BoxDecoration(
                color: InternaCrystal.accentPurple.withOpacity(0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: InternaCrystal.accentPurple.withOpacity(0.3),
                  width: 1.5,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.add_rounded,
                    color: InternaCrystal.accentPurple,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    AppStrings.addDate,
                    style: GoogleFonts.outfit(
                      color: InternaCrystal.accentPurple,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateCard(
    BuildContext context, {
    required String label,
    required DateTime date,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: InternaCrystal.bgCard,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: InternaCrystal.borderSubtle),
          ),
          child: Column(
            children: [
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: InternaCrystal.textMuted,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                DateFormat('dd/MM').format(date),
                style: GoogleFonts.outfit(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: InternaCrystal.accentPurple,
                  letterSpacing: -1,
                ),
              ),
              Text(
                DateFormat('yyyy').format(date),
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: InternaCrystal.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGlassDropdown(
    BuildContext context, {
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: InternaCrystal.bgCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: InternaCrystal.borderSubtle),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          items: items
              .map((e) => DropdownMenuItem(
                    value: e,
                    child: Text(
                      e,
                      style: GoogleFonts.inter(
                        color: InternaCrystal.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ))
              .toList(),
          onChanged: onChanged,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: InternaCrystal.textSecondary,
          ),
          dropdownColor: InternaCrystal.bgElevated,
          borderRadius: BorderRadius.circular(20),
          isExpanded: true,
        ),
      ),
    );
  }

  void _pickDateResponsive(
    BuildContext context, {
    required DateTime initialDate,
    DateTime? minimumDate,
    required ValueChanged<DateTime> onChanged,
  }) {
    InternaCrystal.showPremiumDatePicker(
      context,
      initialDate: initialDate,
      minimumDate: minimumDate,
      onChanged: onChanged,
    );
  }

  // _showScrollingDatePicker has been replaced by InternaCrystal.showPremiumDatePicker
}
