import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../core/constants/routes.dart';
import '../core/theme/app_theme.dart';
import '../models/household_profile.dart';
import '../providers/household_provider.dart';
import '../widgets/alert_banner.dart';
import '../widgets/app_top_bar.dart';
import '../widgets/family_stepper.dart';
import '../widgets/hazard_selector.dart';
import '../widgets/safe_button.dart';
import '../widgets/safe_card.dart';
import '../widgets/screen_scroll.dart';
import '../widgets/section_header.dart';
import '../widgets/toggle_row.dart';

/// First-run household setup, also reused for editing from Settings.
class HouseholdSetupScreen extends StatefulWidget {
  const HouseholdSetupScreen({super.key, this.isEditing = false});

  final bool isEditing;

  @override
  State<HouseholdSetupScreen> createState() => _HouseholdSetupScreenState();
}

class _HouseholdSetupScreenState extends State<HouseholdSetupScreen> {
  late final TextEditingController _nameController;
  late int _memberCount;
  late bool _hasChildren;
  late bool _hasSeniors;
  late bool _hasDisability;
  late bool _hasPets;
  late HazardType _hazard;
  String? _nameError;

  @override
  void initState() {
    super.initState();
    // Pre-fill from the saved profile (edit) or the Figma demo defaults.
    final household = context.read<HouseholdProvider>();
    final draft = widget.isEditing
        ? (household.profile ?? household.draft)
        : household.draft;

    _nameController = TextEditingController(text: draft.ownerName);
    _memberCount = draft.memberCount;
    _hasChildren = draft.hasChildren;
    _hasSeniors = draft.hasSeniors;
    _hasDisability = draft.hasDisability;
    _hasPets = draft.hasPets;
    _hazard = draft.hazard;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() => _nameError = 'Please add a name for the household.');
      return;
    }

    setState(() => _nameError = null);

    final household = context.read<HouseholdProvider>();
    final profile = HouseholdProfile(
      ownerName: name,
      memberCount: _memberCount,
      hasChildren: _hasChildren,
      hasSeniors: _hasSeniors,
      hasDisability: _hasDisability,
      hasPets: _hasPets,
      hazard: _hazard,
    );

    final saved = await household.save(profile);
    if (!mounted) return;

    if (!saved) {
      final error = household.takeError();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error ?? 'We could not save your household.')),
      );
      return;
    }

    if (widget.isEditing) {
      context.pop();
    } else {
      context.go(AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final household = context.watch<HouseholdProvider>();

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            if (widget.isEditing)
              AppTopBar(
                title: 'Edit household',
                onBack: () => context.pop(),
              ),
            Expanded(
              child: ScreenScroll(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.isEditing
                          ? 'Keep your plan\nup to date.'
                          : 'Tell us about\nyour household.',
                      style: AppTypography.h1,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'SafeGo uses this to personalise your checklist and go-bag. It never leaves this phone.',
                      style: AppTypography.bodyMuted,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    const AlertBanner(
                      title: 'Saved on this phone',
                      message:
                          'No account, no signal needed. You can edit this any time in Settings.',
                      tone: AlertTone.success,
                      icon: Icons.lock_outline,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    const SectionHeader(title: 'Who is at home?'),
                    TextField(
                      controller: _nameController,
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.next,
                      maxLength: 40,
                      decoration: InputDecoration(
                        labelText: 'Your name',
                        hintText: 'e.g. Maria',
                        errorText: _nameError,
                        counterText: '',
                        prefixIcon: const Icon(Icons.person_outline),
                      ),
                      onChanged: (_) {
                        if (_nameError != null) {
                          setState(() => _nameError = null);
                        }
                      },
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    FamilyStepper(
                      value: _memberCount,
                      onChanged: (value) =>
                          setState(() => _memberCount = value),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    const SectionHeader(title: 'Needs in your household'),
                    SafeCard(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                      ),
                      child: Column(
                        children: [
                          ToggleRow(
                            title: 'Children',
                            subtitle: 'Add child-sized supplies to the go-bag.',
                            value: _hasChildren,
                            icon: Icons.child_care,
                            showDivider: true,
                            onChanged: (value) =>
                                setState(() => _hasChildren = value),
                          ),
                          ToggleRow(
                            title: 'Seniors',
                            subtitle:
                                'Glasses, hearing aids and easy-to-eat food.',
                            value: _hasSeniors,
                            icon: Icons.elderly,
                            showDivider: true,
                            onChanged: (value) =>
                                setState(() => _hasSeniors = value),
                          ),
                          ToggleRow(
                            title: 'Disability support',
                            subtitle:
                                'Mobility aids, extra medicine and a support plan.',
                            value: _hasDisability,
                            icon: Icons.accessible,
                            showDivider: true,
                            onChanged: (value) =>
                                setState(() => _hasDisability = value),
                          ),
                          ToggleRow(
                            title: 'Pets',
                            subtitle:
                                'Food, water, carrier and a leash for your pets.',
                            value: _hasPets,
                            icon: Icons.pets,
                            onChanged: (value) =>
                                setState(() => _hasPets = value),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    const SectionHeader(title: 'Main hazard'),
                    Text(
                      'We use this for tips on Home and your go-bag.',
                      style: AppTypography.caption,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    HazardSelector(
                      selected: _hazard,
                      onChanged: (value) => setState(() => _hazard = value),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      'You can change all of this later in Settings.',
                      style: AppTypography.caption,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.xs,
                AppSpacing.lg,
                AppSpacing.md,
              ),
              child: SafeButton(
                label: widget.isEditing ? 'Save changes' : 'Build my plan',
                icon: Icons.arrow_forward,
                onPressed: household.isSaving ? null : _save,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
