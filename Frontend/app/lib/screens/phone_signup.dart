import 'package:cached_network_image/cached_network_image.dart';
import 'package:country_picker/country_picker.dart';
import 'package:edu_elimu/screens/forgot_password.dart';
import 'package:edu_elimu/screens/signup_screen.dart';
import 'package:edu_elimu/themes/colors.dart';
import 'package:edu_elimu/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:local_auth/local_auth.dart';
import 'package:lottie/lottie.dart';

RegExp specialChar = RegExp(r"[$&+,:;=?@#|'<>.^*()%!-]");
RegExp phoneNumberConfirm = RegExp(r"^[\+254][0-9]{12}");

class PhoneLoginScreen extends StatefulWidget {
  const PhoneLoginScreen({super.key});

  @override
  State<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  bool showPassword = false;
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  final GoogleSignIn googleSignIn = GoogleSignIn();
  FirebaseAuth auth = FirebaseAuth.instance;
  final LocalAuthentication localAuth = LocalAuthentication();
  PhoneAuthCredential? pCredential;

  // Default is Kenya
  Country country = Country.from(json: {
    "e164_cc": "254",
    "iso2_cc": "KE",
    "e164_sc": 0,
    "geographic": true,
    "level": 1,
    "name": "Kenya",
    "example": "712123456",
    "display_name": "Kenya (KE) [+254]",
    "full_example_with_plus_sign": "+254712123456",
    "display_name_no_e164_cc": "Kenya (KE)",
    "e164_key": "254-KE-0"
  });
  bool sendOTP = false;

  User? user;

  @override
  void initState() {
    phoneController.text = "+${country.phoneCode}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Phone Login"),
        elevation: 0.1,
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: ListView(children: [
            // createBanner(),
            Lottie.asset("assets/lottie/phone-and-email-communication.json",
                height: MediaQuery.of(context).size.height * 0.25),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
              child: Text(
                "Create Account",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 28,
                ),
              ),
            ),
            createPhoneBox(context),

            const SizedBox(
              height: 40,
            ),
            if (sendOTP) createPasswordBox(),
            if (sendOTP)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                    "OTP is a 6 digit code sent to your inbox, check your messages"),
              ),
            //const SizedBox(height: 50),
            //createForgotPasswordType(),
            createLoginButton(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Text("OR",
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600, fontSize: 18)),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 7,
                  child: loginWithGoogleButton(),
                ),
                const Spacer(),
                Expanded(
                  flex: 7,
                  child: loginWithPhoneButton(),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const SignupScreen()));
              },
              child: SizedBox(
                height: 50,
                child: Center(
                  child: RichText(
                    text: TextSpan(
                        text: "New to EduElimu? ",
                        style: GoogleFonts.poppins(
                            color: EduColors.blackColor,
                            fontWeight: FontWeight.w600),
                        children: const [
                          TextSpan(
                              text: "Register",
                              style: TextStyle(color: EduColors.appColor))
                        ]),
                  ),
                ),
              ),
            ),
            // Spacer()
          ]),
        ),
      ),
    );
  }

  Widget createForgotPasswordType() {
    return InkWell(
      onTap: () async {
        try {
          final bool didAuthenticate = await localAuth.authenticate(
              localizedReason:
                  "We need to confirm it's you before resetting password");
          if (didAuthenticate) {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const ForgotPasswordPage()));
          } else {
            showOverlayError("User didn't authenticate correctly");
          }
        } on PlatformException catch (e) {
          // ...
          showOverlayError(
              "Error opening local authenticator, cannot reset password");
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Align(
          alignment: Alignment.centerRight,
          child: Text(
            "Forgot Password ?",
            style: GoogleFonts.poppins(
                color: EduColors.blackColor, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  Widget createPhoneBox(BuildContext context) {
    return Row(
      children: [
        Expanded(child: createCountryPicker(context)),
        Expanded(
          flex: 3,
          child: TextFormField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.phone_android),
              isDense: false,
              hintText: country.fullExampleWithPlusSign,
              focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: EduColors.appColor)),
              label: Text("Phone Number",
                  style: TextStyle(
                      fontSize: 15, color: Colors.black.withOpacity(0.7))),
            ),
            textAlign: TextAlign.start,
          ),
        ),
      ],
    );
  }

  Widget createCountryPicker(BuildContext context) {
    return InkWell(
      onTap: () {
        showCountryPicker(
          context: context,
          showPhoneCode: true,
          countryListTheme: CountryListThemeData(
            flagSize: 25,
            backgroundColor: Colors.white,
            textStyle: const TextStyle(fontSize: 16, color: Colors.blueGrey),
            bottomSheetHeight: 500,
            // Optional. Country list modal height
            //Optional. Sets the border radius for the bottomsheet.
            borderRadius: BorderRadius.zero,
            //Optional. Styles the search field.
            inputDecoration: InputDecoration(
              labelText: 'Search',
              hintText: 'Start typing to search',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: const Color(0xFF8C98A8).withOpacity(0.2),
                ),
              ),
            ),
          ),
          // optional. Shows phone code before the country name.
          onSelect: (Country chosenCountry) {
            String initialText =
                phoneController.text.replaceAll("+${country.phoneCode}", "");
            country = chosenCountry;

            phoneController.text = "+${country.phoneCode}$initialText";

            setState(() {});
          },
        );
      },
      child: Row(
        children: [
          Text(country.flagEmoji,style: const TextStyle(fontSize: 22),),
          const SizedBox(
            width: 5,
          ),
          Expanded(child: Text(country.name))
        ],
      ),
    );
  }

  Widget createPasswordBox() {
    return TextField(
      onChanged: (newValue) {},
      controller: passwordController,
      obscureText: showPassword,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          onPressed: () {
            showPassword ^= true;
            setState(() {});
          },
          icon: showPassword
              ? const Icon(Icons.visibility)
              : const Icon(Icons.visibility_off),
        ),
        isDense: false,
        focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: EduColors.appColor)),
        label: Text("OTP",
            style:
                TextStyle(fontSize: 15, color: Colors.black.withOpacity(0.7))),
      ),
      textAlign: TextAlign.start,
    );
  }

  Widget createLoginButton() {
    return InkWell(
      onTap: () async {
        if (phoneController.text.isEmpty) {
          showOverlayError("Email field is empty");
          return;
        }
        if (!phoneRegexp.hasMatch(phoneController.text)) {
          showOverlayError("Phone Number is invalid");
          return;
        }
        if (!sendOTP) {
          EasyLoading.show(status: "loading");

          await FirebaseAuth.instance.verifyPhoneNumber(
            phoneNumber: phoneController.text,
            verificationCompleted: (PhoneAuthCredential credential) async {
              await auth.signInWithCredential(credential);
              showOverlayMessage("Successful sign up");
              EasyLoading.dismiss();
            },
            verificationFailed: (FirebaseAuthException e) {
              EasyLoading.dismiss();
              if (e.code == 'invalid-phone-number') {
                showOverlayError('The provided phone number is not valid.');
              }
              showOverlayError(e.toString());
            },
            codeSent: (String verificationId, int? resendToken) async {
              debugPrint("Verification ID $verificationId");
              sendOTP = true;
              EasyLoading.dismiss();
              setState(() {});

              // Create a PhoneAuthCredential with the code
              PhoneAuthCredential credential = PhoneAuthProvider.credential(
                  verificationId: verificationId,
                  smsCode: passwordController.text);

              // Sign the user in (or link) with the credential
              await auth.signInWithCredential(credential);
              showOverlayMessage("Successful sign up");
              EasyLoading.dismiss();
            },
            codeAutoRetrievalTimeout: (String verificationId) {},
          );
          return;
        }
      },
      child: Container(
        height: 45,
        width: double.infinity,
        decoration: BoxDecoration(
            color: EduColors.appColor, borderRadius: BorderRadius.circular(3)),
        child: Center(
            child: Text(
          sendOTP ? "LOGIN" : "SEND OTP",
          textAlign: TextAlign.center,
          style: const TextStyle(
              color: EduColors.blackColor,
              fontSize: 17,
              fontWeight: FontWeight.w500),
        )),
      ),
    );
  }

  Widget loginWithGoogleButton() {
    return InkWell(
      onTap: () async {
        try {
          EasyLoading.show(status: "Loading");

          final GoogleSignInAccount? googleSignInAccount =
              await googleSignIn.signIn();
          if (googleSignInAccount != null) {
            final GoogleSignInAuthentication googleSignInAuthentication =
                await googleSignInAccount.authentication;

            final AuthCredential credential = GoogleAuthProvider.credential(
              accessToken: googleSignInAuthentication.accessToken,
              idToken: googleSignInAuthentication.idToken,
            );

            try {
              final UserCredential userCredential =
                  await auth.signInWithCredential(credential).then((value) {
                EasyLoading.dismiss();
                return value;
              });

              user = userCredential.user;
              showOverlayMessage("Sign In successful");
            } on FirebaseAuthException catch (e) {
              EasyLoading.dismiss();

              if (e.code == 'account-exists-with-different-credential') {
                // handle the error here
                showOverlayError(e.toString());
              } else if (e.code == 'invalid-credential') {
                // handle the error here
                showOverlayError(e.toString());
              }
            } catch (e) {
              EasyLoading.dismiss();

              // handle the error here
              showOverlayError(e.toString());
            }
          } else {
            EasyLoading.dismiss();
            showOverlayError("Could not sign in to Google :(");
          }
        } on FirebaseAuthException catch (e) {
          EasyLoading.dismiss();
          // print(e.toString());
          showOverlayError(
              "Could not sign up via Google reason : ${e.message}");

          rethrow;
        }
      },
      child: Container(
        height: 45,
        decoration: BoxDecoration(
            color: EduColors.whiteColor,
            border: Border.all(color: EduColors.blackColor),
            borderRadius: BorderRadius.circular(0)),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: CachedNetworkImage(
                  imageUrl:
                      "https://img.icons8.com/fluency/48/google-logo.png"),
            ),
            Center(
                child: Text(
              "Login with Google",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  color: EduColors.blackColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
            )),
          ],
        ),
      ),
    );
  }

  Widget loginWithPhoneButton() {
    return InkWell(
      onTap: () {},
      child: Container(
        height: 45,
        decoration: BoxDecoration(
            color: EduColors.blackColor,
            borderRadius: BorderRadius.circular(0)),
        child: const Center(
            child: Text(
          "Login with  Email",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: EduColors.whiteColor,
              fontSize: 14,
              fontWeight: FontWeight.w500),
        )),
      ),
    );
  }
}
