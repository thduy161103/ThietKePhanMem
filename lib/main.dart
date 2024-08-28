import 'package:flutter/material.dart';
import 'package:musicapp/screens/drawer.dart';
import 'package:musicapp/home.dart';
import 'package:phone_email_auth/phone_email_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/homepage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  /// Initialize phone email function with
  /// Client Id
  PhoneEmail.initializeApp(clientId: '18867652854888250695');

  runApp( MyApp(isLoggin: isLoggedIn));
}

class MyApp extends StatefulWidget {
   MyApp({super.key, required this.isLoggin});
  bool isLoggin;
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Phone Email',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 4, 201, 135),
        ),
        useMaterial3: true,
      ),
      //home: PhoneEmailAuthWidget(),
      home: widget.isLoggin ? HomePage() : PhoneEmailAuthWidget(),
    );
  }
}

class PhoneEmailAuthWidget extends StatefulWidget {
  const PhoneEmailAuthWidget({super.key});

  @override
  State<PhoneEmailAuthWidget> createState() => _PhoneEmailAuthWidgetState();
}

class _PhoneEmailAuthWidgetState extends State<PhoneEmailAuthWidget> {
  String userAccessToken = "";
  String jwtUserToken = "";
  bool hasUserLogin = false;
  PhoneEmailUserModel? phoneEmailUserModel;
  final phoneEmail = PhoneEmail();
  String emailCount = '';

  void updateUserLoginState(bool loginState, String accessToken, String jwtToken) {
    setState(() {
      hasUserLogin = loginState;
      userAccessToken = accessToken;
      jwtUserToken = jwtToken;
    });
  }
  
  /// Get email count after getting jwt token
  void getTotalEmailCount() async {
    await PhoneEmail.getEmailCount(
      jwtUserToken,
      onEmailCount: (count) {
        setState(() {
          emailCount = count;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
 
  
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Phone Email'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!hasUserLogin) ...[
                /// Button With extra rounded corner
                /// and background color
                /// and different text
                Align(
                  alignment: Alignment.center,
                  child: PhoneLoginButton(
                    borderRadius: 15,
                    buttonColor: Colors.green,
                    label: 'Sign in with Number',
                    onSuccess: (String accessToken, String jwtToken) {
                      // debugPrint("Access Token :: $accessToken");
                      // debugPrint("Client ID :: $jwtToken");
                      if (accessToken.isNotEmpty) {
                        setState(() {
                          userAccessToken = accessToken;
                          jwtUserToken = jwtToken;
                          hasUserLogin = true;
                        });
                        Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
                        PhoneEmail.getUserInfo(
                          accessToken: userAccessToken,
                          clientId: phoneEmail.clientId,
                          onSuccess: (userData) {
                            setState(() {
                              phoneEmailUserModel = userData;
                              var countryCode = phoneEmailUserModel?.countryCode;
                              var phoneNumber = phoneEmailUserModel?.phoneNumber;
                              var firstName = phoneEmailUserModel?.firstName;
                              var lastName = phoneEmailUserModel?.lastName;
                              debugPrint("countryCode :: $countryCode");
                              debugPrint("phoneNumber :: $phoneNumber");
                              debugPrint("firstName :: $firstName");
                              debugPrint("lastName :: $lastName");
                              getTotalEmailCount();
  
                            });
                          },
                        );
  
                      }
                    },
                  ),
                ),
              ],
            
              ],
            // ],
          ),
        ),
      );
      
      // Add a default return statement
      return Container();
    }
}