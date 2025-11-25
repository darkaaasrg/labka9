import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();


  final Dio dio = Dio();
  static const String requestCatcherBaseUrl = 'https://laba12.requestcatcher.com/';

  Future<void> sendSignUpData() async {
    final String username = _nameController.text.trim();
    final String email = _loginController.text.trim();
    final String password = _passwordController.text; // Пароль не trim'уємо

    final url = requestCatcherBaseUrl + 'signup'; // Використовуємо /signup ендпоінт

    final Map<String, dynamic> data = {
      'username': username,
      'email': email,
      'password': password,
    };

    try {
      final response = await dio.post(
        url,
        data: data,
        options: Options(contentType: 'application/json'),
      );

      if (response.statusCode == 200) {
        print('Успішно! Дані Sign Up відправлені на Request Catcher.');
        _showSuccessDialog(username);
      } else {
        print('Помилка: Неочікуваний код відповіді ${response.statusCode}');
        _showErrorDialog('Помилка сервера: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('Помилка Dio: ${e.message}');
      _showErrorDialog('Помилка мережі. Перевірте з\'єднання.');
    }
  }

  void _showSuccessDialog(String name) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text('Успішна реєстрація'),
          content: Text(
              "Вітаємо, $name! Ваш обліковий запис створено та дані відправлено на Request Catcher."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Помилка відправки даних: $message'),
        backgroundColor: Colors.red,
      ),
    );
  }


  bool _isValidEmail(String email) {
    final emailRegex =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return emailRegex.hasMatch(email);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Реєстрація'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: "Ім'я користувача",
                    prefixIcon: Icon(Icons.badge_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Будь ласка, введіть ваше ім'я.";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _loginController,
                  decoration: const InputDecoration(
                    labelText: 'Логін (Email)',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  keyboardType: TextInputType.emailAddress,

                  validator: (value) {
                    final email = value?.trim();
                    if (email == null || email.isEmpty) {
                      return 'Будь ласка, введіть Email.';
                    }
                    if (!_isValidEmail(email)) {
                      return 'Будь ласка, введіть коректний Email.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller:
                  _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Пароль',
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                  obscureText: true,
                  validator: (value) {
                    final password = value?.trim();
                    if (password == null || password.isEmpty) {
                      return 'Будь ласка, введіть пароль.';
                    }
                    if (password.length < 7) {
                      return 'Пароль повинен бути не менше 7 символів.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24.0),

                ElevatedButton(
                  child: const Text('Зареєструватися'),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      sendSignUpData();
                    }
                  },
                ),

                const SizedBox(height: 16.0),
                OutlinedButton(
                  child: const Text('Повернутися до авторизації'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}