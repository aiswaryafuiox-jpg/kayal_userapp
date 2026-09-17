import 'package:get/get.dart';
import 'package:kayal_userapp/core/di/service_locator.dart';
import 'package:kayal_userapp/core/service/api_service.dart';
import 'package:kayal_userapp/data/repository/get_privacy_policy_repository_impl.dart';
import 'package:kayal_userapp/domain/usecase/get_privacy_policy_usecase.dart';

class PrivacyPolicyController extends GetxController {
  final GetPrivacyPolicyUseCase _getPrivacyPolicyUseCase;

  PrivacyPolicyController({GetPrivacyPolicyUseCase? getPrivacyPolicyUseCase})
      : _getPrivacyPolicyUseCase = getPrivacyPolicyUseCase ??
            (sl.isRegistered<GetPrivacyPolicyUseCase>()
                ? sl<GetPrivacyPolicyUseCase>()
                : GetPrivacyPolicyUseCase(
                    GetPrivacyPolicyRepositoryImpl(ApiService()),
                  ));

  final policyTitle = 'Privacy Policy'.obs;
  final policyContent = ''.obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  static const String defaultPolicyContent =
      '1. Information We Collect\n'
      'We collect information you provide directly to us, such as when you create an account, update your profile, place an order, or contact customer support.\n\n'
      '2. How We Use Information\n'
      'We use the information we collect to provide, maintain, and improve our services, process transactions, deliver orders, send notifications, and personalize your experience.\n\n'
      '3. Information Sharing & Disclosure\n'
      'We do not sell your personal data. We only share necessary delivery details with our restaurant partners and delivery personnel to fulfill your orders.\n\n'
      '4. Data Security\n'
      'We implement appropriate security measures to protect your personal information from unauthorized access, alteration, disclosure, or destruction.\n\n'
      '5. Your Rights & Choices\n'
      'You may update or delete your account information at any time through the profile settings in the app.\n\n'
      '6. Contact Us\n'
      'If you have any questions about this Privacy Policy or our practices, please reach out to our support team.';

  @override
  void onInit() {
    super.onInit();
    fetchPrivacyPolicy();
  }

  Future<void> fetchPrivacyPolicy() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await _getPrivacyPolicyUseCase();
      if (response.success && response.data != null && response.data!.hasContent) {
        policyTitle.value = response.data!.displayTitle;
        policyContent.value = response.data!.displayContent;
      } else {
        // Use default fallback if server does not have custom policy configured yet
        policyContent.value = defaultPolicyContent;
      }
    } catch (e) {
      // Fallback gracefully so the UI displays policy while recording status
      policyContent.value = defaultPolicyContent;
    } finally {
      isLoading.value = false;
    }
  }
}
