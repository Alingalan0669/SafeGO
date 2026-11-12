import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/constants/routes.dart';
import '../core/theme/app_theme.dart';
import '../widgets/app_logo.dart';
import '../widgets/progress_bar.dart';
import '../widgets/route_preview.dart';
import '../widgets/safe_button.dart';
import '../widgets/tag_pill.dart';

/// Three-page introduction: Prepare, Pack, Evacuate.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _page = 0;

  static const List<_OnboardingPage> _pages = [
    _OnboardingPage(
      step: 'Prepare',
      title: 'A little preparation.\nA safer family.',
      body:
          'Know your risks, save key contacts and agree on a meeting place. SafeGo turns it into four short steps.',
      arts: _ArtType.prepare,
    ),
    _OnboardingPage(
      step: 'Pack',
      title: 'Your family’s\ngo-bag',
      body:
          'A go-bag built around your household — children, seniors, pets and the medicines you actually need.',
      arts: _ArtType.pack,
    ),
    _OnboardingPage(
      step: 'Evacuate',
      title: 'Your safe way out',
      body:
          'Find your nearest evacuation center, call for help in one tap and follow clear steps when it is time to leave.',
      arts: _ArtType.evacuate,
    ),
  ];

  bool get _isLast => _page == _pages.length - 1;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next() {
    if (_isLast) {
      context.go(AppRoutes.setup);
      return;
    }
    _controller.nextPage(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.sm,
                AppSpacing.lg,
                0,
              ),
              child: Row(
                children: [
                  const AppLogo(size: 44),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    'SafeGo',
                    style: AppTypography.subtitle.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => context.go(AppRoutes.setup),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.muted,
                      minimumSize: const Size(48, 48),
                    ),
                    child: Text(
                      'Skip',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.muted,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _pages.length,
                onPageChanged: (value) => setState(() => _page = value),
                itemBuilder: (context, index) {
                  return _PageContent(page: _pages[index]);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.xs,
                AppSpacing.lg,
                AppSpacing.lg,
              ),
              child: Column(
                children: [
                  Text(
                    'Step ${_page + 1} of ${_pages.length} • ${_pages[_page].step}',
                    style: AppTypography.caption,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  ProgressBar(
                    value: (_page + 1) / _pages.length,
                    semanticLabel: 'Onboarding progress',
                  ),
                  const SizedBox(height: AppSpacing.md),
                  SafeButton(
                    label: _isLast ? 'Get started' : 'Next',
                    icon: _isLast ? Icons.check : Icons.arrow_forward,
                    onPressed: _next,
                  ),
                  if (!_isLast) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Takes about a minute. No account needed.',
                      textAlign: TextAlign.center,
                      style: AppTypography.caption,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum _ArtType { prepare, pack, evacuate }

class _OnboardingPage {
  const _OnboardingPage({
    required this.step,
    required this.title,
    required this.body,
    required this.arts,
  });

  final String step;
  final String title;
  final String body;
  final _ArtType arts;
}

class _PageContent extends StatelessWidget {
  const _PageContent({required this.page});

  final _OnboardingPage page;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _OnboardingArt(type: page.arts),
          const SizedBox(height: AppSpacing.lg),
          Text(
            page.title,
            style: AppTypography.h1,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            page.body,
            style: AppTypography.bodyMuted,
          ),
        ],
      ),
    );
  }
}

/// Lightweight, offline illustration built from icons and cards.
class _OnboardingArt extends StatelessWidget {
  const _OnboardingArt({required this.type});

  final _ArtType type;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 264,
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.blueSoft,
        borderRadius: BorderRadius.circular(AppRadii.hero),
      ),
      child: switch (type) {
        _ArtType.prepare => const _PrepareArt(),
        _ArtType.pack => const _PackArt(),
        _ArtType.evacuate => const _EvacuateArt(),
      },
    );
  }
}

class _PrepareArt extends StatelessWidget {
  const _PrepareArt();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: 0,
          right: 0,
          top: 12,
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppRadii.card),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Family plan', style: AppTypography.subtitle),
                const SizedBox(height: AppSpacing.sm),
                const _ArtCheckRow(label: 'Emergency contacts', done: true),
                const _ArtCheckRow(label: 'Meeting point', done: true),
                const _ArtCheckRow(label: 'Important documents', done: false),
              ],
            ),
          ),
        ),
        Positioned(
          right: 4,
          bottom: 4,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: AppColors.blue,
              borderRadius: BorderRadius.circular(AppRadii.progress),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.shield_outlined,
                    size: 18, color: AppColors.white),
                const SizedBox(width: AppSpacing.xxs),
                Text(
                  '3 of 4 ready',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _PackArt extends StatelessWidget {
  const _PackArt();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppRadii.card),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: AppColors.blueSoft,
                        borderRadius: BorderRadius.circular(AppRadii.iconTile),
                      ),
                      child: const Icon(
                        Icons.backpack,
                        color: AppColors.blue,
                        size: 30,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Maria’s go-bag', style: AppTypography.subtitle),
                          const SizedBox(height: 2),
                          Text(
                            'Packed for 5 people',
                            style: AppTypography.caption,
                          ),
                        ],
                      ),
                    ),
                    const TagPill(label: 'Personalised'),
                  ],
                ),
                const Spacer(),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _ArtIcon(icon: Icons.water_drop, label: 'Water'),
                    _ArtIcon(icon: Icons.medical_services, label: 'First aid'),
                    _ArtIcon(icon: Icons.flashlight_on, label: 'Light'),
                    _ArtIcon(icon: Icons.pets, label: 'Pets'),
                  ],
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppRadii.progress),
          ),
          child: Row(
            children: [
              const Icon(Icons.autorenew, size: 18, color: AppColors.blue),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  'Rebuilt when your household changes',
                  style: AppTypography.caption,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _EvacuateArt extends StatelessWidget {
  const _EvacuateArt();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(child: RoutePreview(height: 232)),
        Positioned(
          left: AppSpacing.sm,
          right: AppSpacing.sm,
          bottom: AppSpacing.sm,
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppRadii.progress),
            ),
            child: Row(
              children: [
                const Icon(Icons.location_on, color: AppColors.blue),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'San Isidro Elementary School',
                        style: AppTypography.caption.copyWith(
                          color: AppColors.ink,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text('Evacuation center • 1.2 km',
                          style: AppTypography.caption),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ArtCheckRow extends StatelessWidget {
  const _ArtCheckRow({required this.label, required this.done});

  final String label;
  final bool done;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Row(
        children: [
          Icon(
            done ? Icons.check_circle : Icons.circle_outlined,
            size: 20,
            color: done ? AppColors.green : AppColors.border,
          ),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Text(
              label,
              style: AppTypography.body.copyWith(
                color: done ? AppColors.muted : AppColors.ink,
                decoration: done ? TextDecoration.lineThrough : null,
                decorationColor: AppColors.muted,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _ArtIcon extends StatelessWidget {
  const _ArtIcon({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 44,
          height: 44,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: AppColors.blueSoft,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.blue, size: 22),
        ),
        const SizedBox(height: AppSpacing.xxs),
        Text(label, style: AppTypography.caption),
      ],
    );
  }
}
