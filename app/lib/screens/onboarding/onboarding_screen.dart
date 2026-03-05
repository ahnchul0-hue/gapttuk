import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../config/constants.dart';
import '../../config/theme.dart';
import '../../providers/service_providers.dart';
import '../../utils/error_utils.dart';

/// 온보딩 화면 — 3페이지 PageView 기반.
///
/// 페이지 1: 환영 (로고 + 기능 소개)
/// 페이지 2: 약관 동의
/// 페이지 3: 완료
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // 약관 동의 상태
  bool _allAgreed = false;
  bool _termsAgreed = false;
  bool _privacyAgreed = false;
  bool _marketingAgreed = false;

  // 추천 코드
  final TextEditingController _referralController = TextEditingController();
  String _referralCode = '';

  static const int _totalPages = 3;

  @override
  void dispose() {
    _pageController.dispose();
    _referralController.dispose();
    super.dispose();
  }

  void _onAllAgreedChanged(bool? value) {
    final agreed = value ?? false;
    setState(() {
      _allAgreed = agreed;
      _termsAgreed = agreed;
      _privacyAgreed = agreed;
      _marketingAgreed = agreed;
    });
  }

  void _updateAllAgreedState() {
    setState(() {
      _allAgreed = _termsAgreed && _privacyAgreed && _marketingAgreed;
    });
  }

  bool get _canProceedFromPage2 => _termsAgreed && _privacyAgreed;

  Future<void> _openUrl(String urlStr) async {
    final uri = Uri.parse(urlStr);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('링크를 열 수 없습니다.')),
        );
      }
    }
  }

  void _goToNextPage() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goToPrevPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _finish() async {
    final referralCode = _referralCode.trim();
    try {
      await ref.read(authServiceProvider).updateConsent(
            termsAgreed: _termsAgreed,
            privacyAgreed: _privacyAgreed,
            marketingAgreed: _marketingAgreed,
            referralCode: referralCode.isNotEmpty ? referralCode : null,
          );
    } catch (e) {
      // 동의 전송 실패해도 앱 사용은 가능 (다음 로그인 시 재시도)
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(friendlyErrorMessage(e))),
        );
      }
    }
    if (mounted) context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // 페이지 뷰
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                children: [
                  _WelcomePage(),
                  _TermsPage(
                    allAgreed: _allAgreed,
                    termsAgreed: _termsAgreed,
                    privacyAgreed: _privacyAgreed,
                    marketingAgreed: _marketingAgreed,
                    referralController: _referralController,
                    onAllAgreedChanged: _onAllAgreedChanged,
                    onTermsChanged: (v) {
                      setState(() => _termsAgreed = v ?? false);
                      _updateAllAgreedState();
                    },
                    onPrivacyChanged: (v) {
                      setState(() => _privacyAgreed = v ?? false);
                      _updateAllAgreedState();
                    },
                    onMarketingChanged: (v) {
                      setState(() => _marketingAgreed = v ?? false);
                      _updateAllAgreedState();
                    },
                    onReferralChanged: (v) => _referralCode = v,
                    onOpenTerms: () => _openUrl(AppConstants.termsUrl),
                    onOpenPrivacy: () => _openUrl(AppConstants.privacyUrl),
                  ),
                  _CompletePage(),
                ],
              ),
            ),

            // 페이지 인디케이터
            _PageIndicator(
              totalPages: _totalPages,
              currentPage: _currentPage,
            ),
            const SizedBox(height: 16),

            // 하단 버튼
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: _buildBottomButtons(),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButtons() {
    switch (_currentPage) {
      case 0:
        return SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: _goToNextPage,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              '다음',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        );
      case 1:
        return Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 52,
                child: OutlinedButton(
                  onPressed: _goToPrevPage,
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('이전'),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: _canProceedFromPage2 ? _goToNextPage : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    '다음',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        );
      case 2:
      default:
        return SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: _finish,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              '시작하기',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        );
    }
  }
}

// ---------------------------------------------------------------------------
// 페이지 1: 환영
// ---------------------------------------------------------------------------

class _WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.trending_down,
            size: 100,
            color: AppTheme.primary,
          ),
          const SizedBox(height: 24),
          Text(
            '값뚝에 오신 걸 환영합니다!',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          _FeatureItem(
            icon: Icons.notifications_active_outlined,
            title: '가격 알림',
            description: '원하는 가격이 되면 즉시 알려드립니다.',
          ),
          const SizedBox(height: 20),
          _FeatureItem(
            icon: Icons.show_chart,
            title: '가격 히스토리',
            description: '상품의 가격 변화를 한눈에 확인하세요.',
          ),
          const SizedBox(height: 20),
          _FeatureItem(
            icon: Icons.star_outline,
            title: '센트(¢) 보상',
            description: '가격 제보와 활동으로 센트를 적립하세요.',
          ),
        ],
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppTheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppTheme.primary),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade600,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// 페이지 2: 약관 동의
// ---------------------------------------------------------------------------

class _TermsPage extends StatelessWidget {
  final bool allAgreed;
  final bool termsAgreed;
  final bool privacyAgreed;
  final bool marketingAgreed;
  final TextEditingController referralController;
  final ValueChanged<bool?> onAllAgreedChanged;
  final ValueChanged<bool?> onTermsChanged;
  final ValueChanged<bool?> onPrivacyChanged;
  final ValueChanged<bool?> onMarketingChanged;
  final ValueChanged<String> onReferralChanged;
  final VoidCallback onOpenTerms;
  final VoidCallback onOpenPrivacy;

  const _TermsPage({
    required this.allAgreed,
    required this.termsAgreed,
    required this.privacyAgreed,
    required this.marketingAgreed,
    required this.referralController,
    required this.onAllAgreedChanged,
    required this.onTermsChanged,
    required this.onPrivacyChanged,
    required this.onMarketingChanged,
    required this.onReferralChanged,
    required this.onOpenTerms,
    required this.onOpenPrivacy,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Text(
            '서비스 이용을 위해\n약관에 동의해 주세요.',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 32),

          // 전체 동의
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: CheckboxListTile(
              title: const Text(
                '전체 동의',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              value: allAgreed,
              onChanged: onAllAgreedChanged,
              controlAffinity: ListTileControlAffinity.leading,
              activeColor: AppTheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          const Divider(),
          const SizedBox(height: 8),

          // 이용약관 (필수)
          _TermsItem(
            title: '이용약관 동의 (필수)',
            value: termsAgreed,
            onChanged: onTermsChanged,
            onViewTap: onOpenTerms,
          ),
          const SizedBox(height: 4),

          // 개인정보처리방침 (필수)
          _TermsItem(
            title: '개인정보처리방침 동의 (필수)',
            value: privacyAgreed,
            onChanged: onPrivacyChanged,
            onViewTap: onOpenPrivacy,
          ),
          const SizedBox(height: 4),

          // 마케팅 수신 (선택)
          _TermsItem(
            title: '마케팅 정보 수신 동의 (선택)',
            value: marketingAgreed,
            onChanged: onMarketingChanged,
            onViewTap: null,
          ),
          const SizedBox(height: 32),

          // 추천 코드 입력
          Text(
            '추천 코드 (선택)',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: referralController,
            onChanged: onReferralChanged,
            decoration: InputDecoration(
              hintText: '추천 코드를 입력하세요',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
            textCapitalization: TextCapitalization.characters,
          ),
          const SizedBox(height: 8),
          Text(
            '추천 코드 입력 시 1¢ 웰컴 보너스를 드립니다.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade600,
                ),
          ),
        ],
      ),
    );
  }
}

class _TermsItem extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool?> onChanged;
  final VoidCallback? onViewTap;

  const _TermsItem({
    required this.title,
    required this.value,
    required this.onChanged,
    this.onViewTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CheckboxListTile(
            title: Text(title, style: const TextStyle(fontSize: 14)),
            value: value,
            onChanged: onChanged,
            controlAffinity: ListTileControlAffinity.leading,
            activeColor: AppTheme.primary,
            contentPadding: EdgeInsets.zero,
            dense: true,
          ),
        ),
        if (onViewTap != null)
          TextButton(
            onPressed: onViewTap,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              minimumSize: const Size(40, 36),
            ),
            child: const Text('보기', style: TextStyle(fontSize: 12)),
          ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// 페이지 3: 완료
// ---------------------------------------------------------------------------

class _CompletePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppTheme.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_circle_outline,
              size: 64,
              color: AppTheme.primary,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            '준비 완료!',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          Text(
            '이제 값뚝과 함께\n최저가 쇼핑을 시작해 보세요.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey.shade600,
                  height: 1.6,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Text(
            '가격이 내려가면 알림을 보내드릴게요.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade500,
                ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 페이지 인디케이터
// ---------------------------------------------------------------------------

class _PageIndicator extends StatelessWidget {
  final int totalPages;
  final int currentPage;

  const _PageIndicator({
    required this.totalPages,
    required this.currentPage,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalPages, (index) {
        final isActive = index == currentPage;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive ? AppTheme.primary : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}
