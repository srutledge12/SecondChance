import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'amplifyconfiguration.dart';
import 'login_screen.dart';
import 'models/ModelProvider.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:amplify_datastore/amplify_datastore.dart';

class AmplifyState {
  bool isAmplifyConfigured = false;
  bool loggedIn = false;
  final AmplifyDataStore _amplifyDataStore =  AmplifyDataStore(modelProvider: ModelProvider.instance,);


  void verifyLogin(BuildContext context, AmplifyState amplifyState) async {
    try {
      while(!isAmplifyConfigured)
        {
          Future.delayed(const Duration(milliseconds: 500), () {
            debugPrint("Waiting on amplifyConfigure...");
          });
        }
      if (isAmplifyConfigured) {
        debugPrint("in verifyLogin: Amplify is configured");
        final awsUser = await Amplify.Auth.getCurrentUser();
        loggedIn = true;
        return;
      }
      debugPrint("Amplify not configured in verifyLogin");
    } on SignedOutException catch (e) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen(key: null, amplifyState: amplifyState)));
      return;
    }
  }
 
  void configureAmplify() async {

    // Add Pinpoint and Cognito Plugins, or any other plugins you want to use
    AmplifyAuthCognito authPlugin = AmplifyAuthCognito();
    AmplifyDataStore datastorePlugin =
            AmplifyDataStore(modelProvider: ModelProvider.instance);
    
    await Amplify.addPlugins([
      datastorePlugin, 
      authPlugin,
      // AmplifyAPI(),
      AmplifyStorageS3()
      ]);
    debugPrint("after adding authPlugin");
    // Once Plugins are added, configure Amplify
    // Note: Amplify can only be configured once.
    try {
      debugPrint("before configure");
      await Amplify.configure(amplifyconfig);
      isAmplifyConfigured = true;
      debugPrint("Amplify Configuration Finished");
    } on AmplifyAlreadyConfiguredException {
      print("Tried to reconfigure Amplify; this can occur when your app restarts on Android.");
    }
  }

  void signUp(String email, String password, String name) async {
    try {
      Map<CognitoUserAttributeKey, String> userInfo = {
        CognitoUserAttributeKey.name: name,
      };

      SignUpResult result = await Amplify.Auth.signUp(
          username: email,
          password: password,
          options: CognitoSignUpOptions(
              userAttributes: userInfo
          )
      );
    } on AuthException catch (e) {
      debugPrint(e.message);
    }

  }
}
