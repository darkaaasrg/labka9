import 'package:flutter/material.dart';
import 'package:dio/dio.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  // 1. КОНТРОЛЕРИ ДЛЯ ПОЛІВ
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // -----------------------------------------------------------------------------
  // 2. КОНФІГУРАЦІЯ DIO ТА ФУНКЦІЯ ВІДПРАВКИ
  // -----------------------------------------------------------------------------
  final Dio dio = Dio();
  // !!! Ваш субдомен: https://laba12.requestcatcher.com/ !!!
  static const String requestCatcherBaseUrl = 'https://laba12.requestcatcher.com/';

  Future<void> sendLoginData() async {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text;

    final url = requestCatcherBaseUrl + 'login'; // Ендпоінт /login

    final Map<String, dynamic> data = {
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
        print('✅ Успішно! Дані Login відправлені на Request Catcher.');
        // Викликаємо діалогове вікно про успіх ПІСЛЯ успішної відправки
        _showSuccessDialog();
      } else {
        print('❌ Помилка: Неочікуваний код відповіді ${response.statusCode}');
        _showErrorDialog('Помилка сервера: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('🚨 Помилка Dio (Login): ${e.message}');
      _showErrorDialog('Помилка мережі. Перевірте з\'єднання.');
    }
  }

  // -----------------------------------------------------------------------------
  // 3. ДОПОМІЖНІ ФУНКЦІЇ UI
  // -----------------------------------------------------------------------------

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text('Успіх'),
          content: const Text('Дані входу відправлено на Request Catcher.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
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
    // Очищення контролерів
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Авторизація'),
        automaticallyImplyLeading: false,
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
                Icon(Icons.lock_person,
                    size: 100, color: Theme.of(context).primaryColor),
                const SizedBox(height: 32.0),

                // --- ПОЛЕ EMAIL (ЗМІНЕНО: додано controller) ---
                TextFormField(
                  controller: _emailController, // Підключаємо контролер
                  decoration: const InputDecoration(
                    labelText: 'Логін (Email)',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    final email = value?.trim();
                    if (email == null || email.isEmpty) {
                      return 'Будь ласка, заповніть це поле.';
                    }
                    if (!_isValidEmail(email)) {
                      return 'Будь ласка, введіть коректний Email.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),

                // --- ПОЛЕ PASSWORD (ЗМІНЕНО: додано controller) ---
                TextFormField(
                  controller: _passwordController, // Підключаємо контролер
                  decoration: const InputDecoration(
                    labelText: 'Пароль',
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Будь ласка, введіть пароль.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24.0),

                // --- КНОПКА "УВІЙТИ" (ОНОВЛЕНО: логіка відправки) ---
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Викликаємо функцію відправки даних
                      sendLoginData();
                    }
                  },
                  child: const Text('Увійти'),
                ),

                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      child: const Text('Забули пароль?'),
                      onPressed: () {
                        Navigator.pushNamed(context, '/recovery');
                      },
                    ),
                    TextButton(
                      child: const Text('Реєстрація'),
                      onPressed: () {
                        Navigator.pushNamed(context, '/register');
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}