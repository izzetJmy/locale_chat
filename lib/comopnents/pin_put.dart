// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class PinPut extends StatefulWidget {
  const PinPut({super.key});

  @override
  State<PinPut> createState() => _PinPutState();
}

class _PinPutState extends State<PinPut> {
  final pinController = TextEditingController();
  final focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    pinController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final defaultPinTheme = PinTheme(
      height: size.height * 0.047,
      width: size.width * 0.09,
      textStyle: const TextStyle(
        fontSize: 22,
        color: Color.fromRGBO(0, 0, 0, 1),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xffD3D3D3)),
      ),
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Form(
        key: formKey,
        child: Row(
          children: [
            Directionality(
              textDirection: TextDirection.ltr,
              child: Pinput(
                length: 6,
                controller: pinController,
                focusNode: focusNode,
                androidSmsAutofillMethod:
                    AndroidSmsAutofillMethod.smsUserConsentApi,
                listenForMultipleSmsOnAndroid: true,
                defaultPinTheme: defaultPinTheme.copyWith(
                    decoration: defaultPinTheme.decoration!
                        .copyWith(color: Colors.white)),
                separatorBuilder: (index) => const SizedBox(width: 8),
                validator: (value) {
                  return null;
                },
                hapticFeedbackType: HapticFeedbackType.lightImpact,
                onCompleted: (pin) {},
                onChanged: (value) {},
                cursor: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 9),
                      width: 22,
                      height: 1,
                      color: const Color(0xffD3D3D3),
                    ),
                  ],
                ),
                focusedPinTheme: defaultPinTheme.copyWith(
                  decoration: defaultPinTheme.decoration!.copyWith(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: const Color(0xffD3D3D3),
                      ),
                      color: Colors.white),
                ),
                submittedPinTheme: defaultPinTheme.copyWith(
                  decoration: defaultPinTheme.decoration!.copyWith(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: const Color(0xffD3D3D3),
                    ),
                  ),
                ),
                errorPinTheme: defaultPinTheme.copyBorderWith(
                  border: Border.all(color: Colors.redAccent),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
