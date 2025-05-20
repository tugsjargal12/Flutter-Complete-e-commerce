import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ShopPage.dart';
import 'package:day16_shopping/Pages/RegisterPage.dart';
import 'package:day16_shopping/Pages/RegisterWithEmailPage.dart';
import 'package:day16_shopping/Pages/RegisterWithPhonePage.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _userController = TextEditingController(); // Утас эсвэл имэйл
  final _passwordController = TextEditingController();

  Future<bool> checkUserInfo(String user, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final savedPhone = prefs.getString('phone');
    final savedEmail = prefs.getString('email');
    final savedPassword = prefs.getString('password');
    // Хэрэглэгч утас эсвэл имэйлээр нэвтрэх боломжтой
    final isUserMatch = (user == savedPhone || user == savedEmail);
    return isUserMatch && password == savedPassword;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Нэвтрэх"),
        backgroundColor: Colors.black87,
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/splash.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.7), BlendMode.darken),
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              color: Colors.white.withOpacity(0.85),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24)),
              elevation: 8,
              margin: EdgeInsets.symmetric(horizontal: 24),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Нэвтрэх",
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87),
                      ),
                      SizedBox(height: 24),
                      TextFormField(
                        controller: _userController,
                        decoration: InputDecoration(
                          labelText: 'Имэйл эсвэл утасны дугаар',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Имэйл эсвэл утасны дугаараа оруулна уу';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Нууц үг',
                          border: OutlineInputBorder(),
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Нууц үгээ оруулна уу';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black87,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 16),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              bool ok = await checkUserInfo(
                                _userController.text,
                                _passwordController.text,
                              );
                              if (ok) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ShopPage()),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          'Имэйл/утас эсвэл нууц үг буруу байна!')),
                                );
                              }
                            }
                          },
                          child:
                              Text('Нэвтрэх', style: TextStyle(fontSize: 18)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
