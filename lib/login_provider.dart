import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';

class LoginProvider with ChangeNotifier {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> login(BuildContext context) async {
    if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
      _showErrorDialog(context, 'Please fill in all fields');
      return;
    }

    _setLoading(true);

    String username = usernameController.text;
    String password = passwordController.text;

    var url = Uri.parse('https://suncity.warmonks.com/api/login');
    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': username,
        'password': password,
        'token': '9LntdEP4RIwAfQ9YJkUKiN0PwGiDLSjvaG1MMmZc4RbDpuRpyNL4mYNDGrlo'
      }),
    );

    _setLoading(false);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data['User Details'] != null) {
        Fluttertoast.showToast(
          msg: 'Login successful',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        Navigator.pushReplacementNamed(context, '/dropdown');
      } else {
        _showErrorDialog(context, 'Login failed. Please check your credentials and try again.');
      }
    } else {
      _showErrorDialog(context, 'An error occurred. Please try again later.');
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
