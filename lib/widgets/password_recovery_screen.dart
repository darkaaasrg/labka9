import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class PasswordRecoveryScreen extends StatefulWidget {
  const PasswordRecoveryScreen({Key? key}) : super(key: key);

  @override
  State<PasswordRecoveryScreen> createState() => _PasswordRecoveryScreenState();
}

class _PasswordRecoveryScreenState extends State<PasswordRecoveryScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _loginController = TextEditingController();

  final Dio dio = Dio();
  static const String requestCatcherBaseUrl = 'https://laba12.requestcatcher.com/';

  Future<void> sendResetPasswordData() async {
    final String email = _loginController.text.trim();

    final url = requestCatcherBaseUrl + 'resetpassword';

    final Map<String, dynamic> data = {
      'email': email,
    };

    try {
      final response = await dio.post(
        url,
        data: data,
        options: Options(contentType: 'application/json'),
      );

      if (response.statusCode == 200) {
        print(' Успішно! Дані Reset Password відправлені на Request Catcher.');
        _showSuccessDialog(email);
      } else {
        print('Помилка: Неочікуваний код відповіді ${response.statusCode}');
        _showErrorDialog('Помилка сервера: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('Помилка Dio (Reset): ${e.message}');
      _showErrorDialog('Помилка мережі. Перевірте з\'єднання.');
    }
  }

  void _showSuccessDialog(String email) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Готово'),
        content: Text(
          'Інструкції для відновлення паролю надіслані на адресу: $email. Дані відправлено на Request Catcher.',
        ),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
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
    _loginController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Відновлення паролю'),
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
                const Text(
                  'Введіть ваш логін або email, і ми надішлемо інструкції для відновлення паролю.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
                const SizedBox(height: 24.0),

                TextFormField(
                  controller: _loginController,
                  decoration: const InputDecoration(
                    labelText: 'Логін або Email',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    final email = value?.trim();
                    if (email == null || email.isEmpty) {
                      return 'Будь ласка, введіть логін або email.';
                    }
                    if (!_isValidEmail(email)) {
                      return 'Будь ласка, введіть коректний Email.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24.0),

                ElevatedButton(
                  child: const Text('Скинути пароль'),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      sendResetPasswordData();
                    }
                  },
                ),

                const SizedBox(height: 16.0),
                TextButton(
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