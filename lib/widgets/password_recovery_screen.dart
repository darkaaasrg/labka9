import 'package:flutter/material.dart';

class PasswordRecoveryScreen extends StatefulWidget {
  const PasswordRecoveryScreen({Key? key}) : super(key: key);

  @override
  State<PasswordRecoveryScreen> createState() => _PasswordRecoveryScreenState();
}

class _PasswordRecoveryScreenState extends State<PasswordRecoveryScreen> {
  // 2. Контролер у State
  final TextEditingController _loginController = TextEditingController();

  // 3. Допоміжні функції
  bool _isValidEmail(String email) {
    final emailRegex =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return emailRegex.hasMatch(email);
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Помилка'),
        content: Text(message),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
        ],
      ),
    );
  }

  // 4. Очищуємо контролер
  @override
  void dispose() {
    _loginController.dispose();
    super.dispose();
  }

  // 5. Метод build
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
              TextField(
                controller: _loginController, // Використовуємо контролер зі State
                decoration: const InputDecoration(
                  labelText: 'Логін або Email',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 24.0),
              ElevatedButton(
                child: const Text('Скинути пароль'),
                onPressed: () {
                  // --- 6. НОВА ВАЛІДАЦІЯ ---
                  final email = _loginController.text.trim();

                  if (email.isEmpty) {
                    _showErrorDialog('Будь ласка, введіть логін або email.');
                  } else if (!_isValidEmail(email)) {
                    _showErrorDialog('Будь ласка, введіть коректний Email.');
                  } else {
                    // Успіх
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Готово'),
                        content: Text(
                          'Інструкції для відновлення паролю надіслані на адресу: $email',
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
    );
  }
}
