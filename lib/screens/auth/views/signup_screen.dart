import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../../constants.dart';
import '../../../route/route_constants.dart';

// ✅ IMPORT YOUR FORM FILE
import 'package:shop/screens/auth/views/components/sign_up_form.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool agree = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              "assets/images/signUp_dark.png",
              height: MediaQuery.of(context).size.height * 0.35,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Let's get started!",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: defaultPadding / 2),
                  const Text(
                    "Create your matrimony profile by entering your details.",
                  ),
                  const SizedBox(height: defaultPadding),

                  /// ✅ TERMS & CONDITIONS
                  Row(
                    children: [
                      Checkbox(
                        value: agree,
                        onChanged: (value) {
                          setState(() {
                            agree = value ?? false;
                          });
                        },
                      ),
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            text: "I agree with the ",
                            children: [
                              TextSpan(
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.pushNamed(
                                      context,
                                      termsOfServicesScreenRoute,
                                    );
                                  },
                                text: "Terms of Service ",
                                style: const TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const TextSpan(text: "& Privacy Policy."),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),

                  const SizedBox(height: defaultPadding * 2),

                  /// ✅ OPEN MATRIMONY FORM
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: agree
                          ? () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const MultiStepForm(),
                                ),
                              );
                            }
                          : null,
                      child: const Text("Create Matrimony Profile"),
                    ),
                  ),

                  const SizedBox(height: defaultPadding),

                  /// ✅ LOGIN LINK
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            logInScreenRoute,
                          );
                        },
                        child: const Text("Log in"),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
