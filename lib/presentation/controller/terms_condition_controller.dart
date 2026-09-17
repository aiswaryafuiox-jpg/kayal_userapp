import 'package:get/get.dart';
import 'package:kayal_userapp/core/di/service_locator.dart';
import 'package:kayal_userapp/core/service/api_service.dart';
import 'package:kayal_userapp/data/repository/get_terms_repository_impl.dart';
import 'package:kayal_userapp/domain/usecase/get_terms_usecase.dart';

class TermsConditionController extends GetxController {
  final GetTermsUseCase _getTermsUseCase;

  TermsConditionController({GetTermsUseCase? getTermsUseCase})
      : _getTermsUseCase = getTermsUseCase ??
            (sl.isRegistered<GetTermsUseCase>()
                ? sl<GetTermsUseCase>()
                : GetTermsUseCase(GetTermsRepositoryImpl(ApiService())));

  final termsTitle = 'Terms & Conditions'.obs;
  final termsContent = ''.obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  static const String defaultTermsContent =
      '1. Acceptance of Terms\n'
      'By accessing or using our application and services, you agree to be bound by these Terms and Conditions and our Privacy Policy.\n\n'
      '2. Account & Security\n'
      'You are responsible for maintaining the confidentiality of your account credentials and for all activities that occur under your account.\n\n'
      '3. Orders & Payments\n'
      'All orders placed through the app are subject to availability and confirmation of the order price. Payments must be made via authorized payment gateways or cash on delivery.\n\n'
      '4. Cancellations & Refunds\n'
      'Orders can be cancelled before they are out for delivery. Refund eligibility depends on the stage of preparation and reason for cancellation.\n\n'
      '5. Modifications\n'
      'We reserve the right to modify these terms at any time. Continued use of the service constitutes acceptance of modified terms.';

  @override
  void onInit() {
    super.onInit();
    fetchTerms();
  }

  Future<void> fetchTerms() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await _getTermsUseCase();
      if (response.success && response.data != null && response.data!.hasContent) {
        termsTitle.value = response.data!.displayTitle;
        termsContent.value = response.data!.displayContent;
      } else {
        // Use default fallback if server does not have custom terms configured yet
        termsContent.value = defaultTermsContent;
      }
    } catch (e) {
      // Fallback gracefully so the UI displays terms while recording status
      termsContent.value = defaultTermsContent;
    } finally {
      isLoading.value = false;
    }
  }
}
