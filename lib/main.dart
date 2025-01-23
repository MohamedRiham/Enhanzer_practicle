import 'package:enhanzer_practicle/custom_widgets/custom_button.dart';
import 'package:enhanzer_practicle/custom_widgets/custom_text_box.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';
import 'network_service/api_service.dart';
import 'database/db_manager.dart';
import 'models/api_request.dart';
import 'models/api_response.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
return MaterialApp(
        title: 'Enhanzer Practicle',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const LoginPage(),

    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _showPassword = false;
  bool _isLoading = false;
  final _dbManager = DbManager();

  Future<void> _handleLogin() async {
    if (_userNameController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    // Check for network connectivity
    final List<ConnectivityResult> connectivityResult =
        await (Connectivity().checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.none)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No network connection')),
        );
      }
      return;
    }

    try {
      setState(() {
        _isLoading = true;
      });

      final apiRequest = ApiRequest(
        apiBody: ApiBody(
          uniqueId: 'u1',
          password: _passwordController.text,
        ),
        apiAction: 'GetUserData',
        companyCode: _userNameController.text,
      );

      final response = await ApiService().postRequest(
        url: 'https://api.ezuite.com/api/External_Api/Mobile_Api/Invoke',
        body: apiRequest.toJson(),
      );
      ApiResponse apiResponse = ApiResponse.fromJson(response);
      if (apiResponse.statusCode > 300 &&
          apiResponse.message != null &&
          (apiResponse.responseBody?.isEmpty ?? true)) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(apiResponse.message!)),
          );
        }
        return;
      }

      // Save data to the local database
      for (var responseBody in apiResponse.responseBody ?? []) {
        await _dbManager.insertApiResponse(responseBody);
      }

      // Navigate to HomePage
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An unexpected error occurred')),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade400, Colors.blue.shade800],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 30.0,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Welcome Back!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade800,
                      ),
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      controller: _userNameController,
                      label: 'Username',
                      icon: Icons.person,
                    ),
                    const SizedBox(height: 15),
                    CustomTextField(
                      controller: _passwordController,
                      label: 'Password',
                      icon: Icons.lock,
                      obscureText: !_showPassword,
                      suffixIcon: IconButton(
                        icon: Icon(_showPassword
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _showPassword = !_showPassword;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    _isLoading
                        ? const CircularProgressIndicator()
                        : CustomButton(
                            text: 'Login',
                            onPressed: _handleLogin,
                          ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
