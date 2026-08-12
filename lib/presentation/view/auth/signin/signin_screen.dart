import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:kayal_userapp/core/const/app_images.dart';
import 'package:kayal_userapp/presentation/controller/auth/signin_controller.dart';


class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});

  final SignupController controller =
      Get.put(SignupController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFCFA),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ==========================================
              // TITLE
              // ==========================================

              const SizedBox(height: 30),

              const Text(
                'Sign up',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF202733),
                ),
              ),

              // ==========================================
              // LOGO
              // ==========================================

              const SizedBox(height: 12),

              Center(
                child: Image.asset(
                  appLogo,
                  width: 100,
                  height: 100,
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 12),

              // ==========================================
              // FIRST NAME
              // ==========================================

              const _FieldLabel(
                text: 'First Name',
              ),

              const SizedBox(height: 6),

              _SignupTextField(
                controller:
                    controller.firstNameController,
                hintText: 'Enter',
              ),

              const SizedBox(height: 11),

              // ==========================================
              // LAST NAME
              // ==========================================

              const _FieldLabel(
                text: 'Last Name',
              ),

              const SizedBox(height: 6),

              _SignupTextField(
                controller:
                    controller.lastNameController,
                hintText: 'Enter',
              ),

              const SizedBox(height: 11),

              // ==========================================
              // PHONE
              // ==========================================

              const _FieldLabel(
                text: 'Phone No',
              ),

              const SizedBox(height: 6),

              _PhoneField(
                controller:
                    controller.phoneController,
              ),

              const SizedBox(height: 11),

              // ==========================================
              // EMAIL
              // ==========================================

              const _FieldLabel(
                text: 'Email',
              ),

              const SizedBox(height: 6),

              _SignupTextField(
                controller:
                    controller.emailController,
                hintText: 'Enter',
                keyboardType:
                    TextInputType.emailAddress,
              ),

              // ==========================================
              // SPACE
              // ==========================================

              const Spacer(),

              // ==========================================
              // SIGN UP BUTTON
              // ==========================================

              Obx(
                () => SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: ElevatedButton(
                    onPressed:
                        controller.isLoading.value
                            ? null
                            : controller.signUp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFFFF823E),
                      disabledBackgroundColor:
                          const Color(0xFFFF823E),
                      elevation: 0,
                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(6),
                      ),
                    ),
                    child:
                        controller.isLoading.value
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child:
                                    CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Sign up',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight:
                                      FontWeight.w500,
                                ),
                              ),
                  ),
                ),
              ),

              // ==========================================
              // LOGIN
              // ==========================================

              const SizedBox(height: 6),

              Center(
                child: GestureDetector(
                  onTap: controller.goToLogin,
                  child: RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text:
                              'I have an account? ',
                          style: TextStyle(
                            color:
                                Color(0xFF202733),
                            fontSize: 12,
                          ),
                        ),
                        TextSpan(
                          text: 'Login',
                          style: TextStyle(
                            color:
                                Color(0xFFFF823E),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
class _FieldLabel extends StatelessWidget {
  const _FieldLabel({
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Color(0xFF202733),
      ),
    );
  }
}

class _SignupTextField extends StatelessWidget {
  const _SignupTextField({
    required this.controller,
    required this.hintText,
    this.keyboardType,
  });

  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 51,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,

        style: const TextStyle(
          fontSize: 14,
          color: Color(0xFF202733),
        ),

        decoration: InputDecoration(
          hintText: hintText,

          hintStyle: const TextStyle(
            color: Color(0xFFB7BAC0),
            fontSize: 14,
          ),

          contentPadding:
              const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 14,
          ),

          filled: true,
          fillColor: Colors.transparent,

          border: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Color(0xFFF0D8D3),
            ),
          ),

          enabledBorder:
              OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Color(0xFFF0D8D3),
            ),
          ),

          focusedBorder:
              OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Color(0xFFFF823E),
            ),
          ),
        ),
      ),
    );
  }
}


class _PhoneField extends StatelessWidget {
  const _PhoneField({
    required this.controller,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 51,
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.phone,

        style: const TextStyle(
          fontSize: 14,
          color: Color(0xFF202733),
        ),

        decoration: InputDecoration(
          hintText: '0000 000 000',

          hintStyle: const TextStyle(
            color: Color(0xFFB7BAC0),
            fontSize: 14,
          ),

          prefixIcon: const Padding(
            padding: EdgeInsets.only(
              left: 15,
              right: 8,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [

                Text(
                  '+91',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF202733),
                  ),
                ),

                SizedBox(width: 4),

                Icon(
                  Icons.keyboard_arrow_down,
                  size: 16,
                  color: Color(0xFF202733),
                ),

                SizedBox(width: 8),

                SizedBox(
                  height: 22,
                  child: VerticalDivider(
                    width: 1,
                    thickness: 1,
                    color: Color(0xFFE0E0E0),
                  ),
                ),
              ],
            ),
          ),

          contentPadding:
              const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 14,
          ),

          border: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Color(0xFFF0D8D3),
            ),
          ),

          enabledBorder:
              OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Color(0xFFF0D8D3),
            ),
          ),

          focusedBorder:
              OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Color(0xFFFF823E),
            ),
          ),
        ),
      ),
    );
  }
}