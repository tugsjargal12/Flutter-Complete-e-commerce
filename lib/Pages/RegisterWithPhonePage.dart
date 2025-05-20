import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'LoginPage.dart';

class RegisterWithPhonePage extends StatefulWidget {
  @override
  State<RegisterWithPhonePage> createState() => _RegisterWithPhonePageState();
}

class _RegisterWithPhonePageState extends State<RegisterWithPhonePage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) return 'Утасны дугаараа оруулна уу';
    final reg = RegExp(r'^\d{8}$');
    if (!reg.hasMatch(value)) return '8 оронтой дугаар оруулна уу';
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Нууц үгээ оруулна уу';
    if (value.length < 8) return 'Нууц үг хамгийн багадаа 8 тэмдэгт байх ёстой';
    final reg =
        RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#\$&*~]).{8,}$');
    if (!reg.hasMatch(value)) {
      return 'Том, жижиг үсэг, тоо, тусгай тэмдэгт агуулсан байх ёстой';
    }
    return null;
  }

  Future<void> saveUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('phone', _phoneController.text);
    await prefs.setString('password', _passwordController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Утасны дугаараар бүртгүүлэх"),
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
                        "Бүртгүүлэх",
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87),
                      ),
                      SizedBox(height: 24),
                      TextFormField(
                        controller: _phoneController,
                        decoration: InputDecoration(
                          labelText: 'Утасны дугаар (8 оронтой)',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: validatePhone,
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Нууц үг',
                          border: OutlineInputBorder(),
                        ),
                        obscureText: true,
                        validator: validatePassword,
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
                              await saveUserInfo();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text('Амжилттай бүртгэгдлээ!')),
                              );
                              await Future.delayed(Duration(seconds: 1));
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()),
                              );
                            }
                          },
                          child: Text('Бүртгүүлэх',
                              style: TextStyle(fontSize: 18)),
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
