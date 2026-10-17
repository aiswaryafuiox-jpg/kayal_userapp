import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:kayal_userapp/core/const/app_color.dart';
import 'package:kayal_userapp/core/const/app_images.dart';
import 'package:kayal_userapp/core/utils/helper/texthelper.dart';
import 'package:kayal_userapp/presentation/controller/auth/otp_controller.dart';
import 'package:kayal_userapp/presentation/widgets/app_button.dart';
import 'package:pinput/pinput.dart';

class OtpVerificationScreen extends GetView<OtpController> {
  const OtpVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 76, 24, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('OTP Verification', style: TextHelper.heading3),
              const SizedBox(height: 14),
              Center(
                child: Text(
                  'Enter the code from the sms we sent',
                  style: TextHelper.heading2.copyWith(
                    color: AppColors.textprimary.withValues(alpha: 0.55),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      controller.formattedPhoneNumber,
                      style: TextHelper.heading2.copyWith(
                        color: AppColors.primary,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 8),
                    InkWell(
                      key: const Key('edit-phone-button'),
                      onTap: controller.editPhoneNumber,
                      borderRadius: BorderRadius.circular(4),
                      child: Padding(
                        padding: const EdgeInsets.all(2),
                        child: SvgPicture.asset(
                          editicon,
                          width: 18,
                          height: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 34),
              Center(child: _OtpInput(controller: controller)),
              const SizedBox(height: 30),
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      controller.countdown,
                      style: TextHelper.heading2.copyWith(
                        color: Colors.red,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.red,
                      ),
                    ),
                    TextButton(
                      onPressed: controller.canResend
                          ? controller.resendOtp
                          : null,
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(0, 32),
                        foregroundColor: Colors.green,
                        disabledForegroundColor: Colors.green.withValues(
                          alpha: 0.55,
                        ),
                      ),
                      child: controller.isResending.value
                          ? const SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.green,
                              ),
                            )
                          : Text(
                              'Resend OTP',
                              style: TextHelper.heading2.copyWith(
                                color: controller.canResend
                                    ? Colors.green
                                    : Colors.green.withValues(alpha: 0.55),
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                decoration: TextDecoration.underline,
                                decorationColor: controller.canResend
                                    ? Colors.green
                                    : Colors.green.withValues(alpha: 0.55),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Obx(
                () => controller.isLoading.value
                    ? const Center(
                        child: SizedBox(
                          height: 48,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      )
                    : AppButton(
                        text: 'Continue',
                        width: double.infinity,
                        onPressed: controller.verifyOtp,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OtpInput extends StatelessWidget {
  const _OtpInput({required this.controller});

  final OtpController controller;

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 54,
      height: 54,
      textStyle: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.textprimary,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.25),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.primary, width: 1.8),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.18),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.primary, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.25),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      textStyle: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    );

    final errorPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.red, width: 1.5),
      ),
      textStyle: defaultPinTheme.textStyle?.copyWith(color: AppColors.red),
    );

    return Pinput(
      length: OtpController.otpLength,
      controller: controller.otpController,
      focusNode: controller.otpFocusNode,
      autofocus: true,
      defaultPinTheme: defaultPinTheme,
      focusedPinTheme: focusedPinTheme,
      submittedPinTheme: submittedPinTheme,
      errorPinTheme: errorPinTheme,
      separatorBuilder: (index) => const SizedBox(width: 12),
      pinAnimationType: PinAnimationType.scale,
      hapticFeedbackType: HapticFeedbackType.lightImpact,
      showCursor: true,
      cursor: Container(
        width: 2,
        height: 22,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(1),
        ),
      ),
      onChanged: controller.onOtpChanged,
      onCompleted: (pin) {
        controller.onOtpChanged(pin);
        controller.verifyOtp();
      },
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
    );
  }
}
