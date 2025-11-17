import 'package:flutter/material.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  bool _isValidEmail(String email) {
    final emailRegex =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return emailRegex.hasMatch(email);
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

                TextFormField(
                  // controller: НЕМАЄ
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
                    return null; // Все добре
                  },
                ),
                const SizedBox(height: 16.0),

                TextFormField(
                  // controller: НЕМАЄ
                  decoration: const InputDecoration(
                    labelText: 'Пароль',
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Будь ласка, введіть пароль.';
                    }
                    return null; // Все добре
                  },
                ),
                const SizedBox(height: 24.0),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Валідація пройшла успішно.
                      // Оскільки нам не потрібні дані, просто показуємо успіх
                      showDialog(
                        context: context,
                        builder: (BuildContext ctx) {
                          return const AlertDialog(
                            title: Text('Успіх'),
                            content: Text('Вхід виконано.'),
                          );
                        },
                      );
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