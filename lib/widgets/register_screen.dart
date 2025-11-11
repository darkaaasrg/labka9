import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // 2. Контролери тепер у State
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // 3. Допоміжні функції (такі самі, як у LoginScreen)
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

  // 4. Очищуємо всі три контролери
  @override
  void dispose() {
    _nameController.dispose();
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // 5. Метод build
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _nameController, // Використовуємо контролер зі State
                decoration: const InputDecoration(
                  labelText: "Ім'я користувача",
                  prefixIcon: Icon(Icons.badge_outlined),
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _loginController, // Використовуємо контролер зі State
                decoration: const InputDecoration(
                  labelText: 'Логін (Email)',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller:
                _passwordController, // Використовуємо контролер зі State
                decoration: const InputDecoration(
                  labelText: 'Пароль',
                  prefixIcon: Icon(Icons.lock_outline),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 24.0),
              ElevatedButton(
                child: const Text('Зареєструватися'),
                onPressed: () {
                  // --- 6. НОВА РОЗШИРЕНА ВАЛІДАЦІЯ ---
                  final name = _nameController.text.trim();
                  final email = _loginController.text.trim();
                  final password = _passwordController.text.trim();

                  if (name.isEmpty || email.isEmpty || password.isEmpty) {
                    _showErrorDialog('Будь ласка, заповніть усі поля.');
                  } else if (!_isValidEmail(email)) {
                    _showErrorDialog('Будь ласка, введіть коректний Email.');
                  } else if (password.length < 7) {
                    _showErrorDialog('Пароль повинен бути не менше 7 символів.');
                  } else {
                    // Якщо вся валідація пройдена
                    showDialog(
                      context: context,
                      builder: (BuildContext ctx) {
                        return AlertDialog(
                          title: const Text('Успішна реєстрація'),
                          content: Text(
                              "Вітаємо, $name! Ваш обліковий запис створено."),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(ctx).pop(); // Закриваємо діалог
                                Navigator.pop(
                                    context); // Повертаємо на екран логіну
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
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
    );
  }
}