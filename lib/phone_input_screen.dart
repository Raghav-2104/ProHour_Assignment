import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:intern/db_helper.dart';
import 'package:intern/phone_number_display_screen.dart';

class PhoneInputScreen extends StatefulWidget {
  const PhoneInputScreen({super.key});

  @override
  _PhoneInputScreenState createState() => _PhoneInputScreenState();
}

class _PhoneInputScreenState extends State<PhoneInputScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final DBHelper _dbHelper = DBHelper();
  bool _isConnected = true;

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
  }

  void _checkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _isConnected = connectivityResult != ConnectivityResult.none;
    });
  }

  void _savePhoneNumber() async {
    final phone = _phoneController.text;

    if (_isConnected && phone.length == 10) {
      final db = await _dbHelper.database;
      await db.insert(_dbHelper.tableName, {'number': phone});
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PhoneNumberDisplayScreen(phone),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isButtonDisabled = !_isConnected || _phoneController.text.length < 10;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Phone Number Input'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter a 10-digit phone number',
                border: const OutlineInputBorder(),
                errorText: !_isConnected && _phoneController.text.isNotEmpty
                    ? 'Please check your internet connection'
                    : null,
              ),
              maxLength: 10,
              onChanged: (value) {
                setState(() {});
              },
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: isButtonDisabled ? null : _savePhoneNumber,
              style: ButtonStyle(
                backgroundColor: isButtonDisabled
                    ? MaterialStateProperty.all(Colors.grey)
                    : null,
                padding:  MaterialStateProperty.all(
                  const EdgeInsets.all(16.0),
                ),
                overlayColor: MaterialStateProperty.all(Colors.red),
              ),
              child: const Text('Submit')
            ),
          ],
        ),
      ),
    );
  }
}
