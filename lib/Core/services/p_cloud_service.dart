import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

class PCloudService {
  static final String _apiUrl = 'https://eapi.pcloud.com';

  static List<Map<String, dynamic>> accounts = [];

  static Future<void> login({required String email, required String password}) async {
    final response = await http.get(
      Uri.parse('$_apiUrl/login?username=$email&password=$password'),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data['userid'] != null) {
      // Login successful
      accounts.add({
        'email': email,
        'auth': data['auth'],
        'userid': data['userid'],
        'freeSpace': data['quota'] - data['usedquota'],
      });
    } else if (data['error'] == "provide 'code'.") {
      // OTP required, fetch from Mail.tm
      String otpCode = await fetchOTPFromMailTM(email);
      if (otpCode.isNotEmpty) {
        await loginWithOTP(email: email, password: password, otpCode: otpCode);
      } else {
        throw Exception('Failed to retrieve OTP code from Mail.tm');
      }
    } else {
      throw Exception('Login failed: ${data['error'] ?? 'Unknown error'}');
    }
  }

  static Future<String> fetchOTPFromMailTM(String email) async {
    // Get Mail.tm account token
    final tokenResponse = await http.post(
      Uri.parse('https://api.mail.tm/token'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'address': email, 'password': 'your_mailtm_password'}),
    );

    if (tokenResponse.statusCode != 200) {
      throw Exception('Failed to authenticate with Mail.tm');
    }

    final tokenData = jsonDecode(tokenResponse.body);
    String authToken = tokenData['token'];

    // Fetch emails from inbox
    final inboxResponse = await http.get(
      Uri.parse('https://api.mail.tm/messages'),
      headers: {'Authorization': 'Bearer $authToken'},
    );

    if (inboxResponse.statusCode != 200) {
      throw Exception('Failed to fetch emails from Mail.tm');
    }

    final inboxData = jsonDecode(inboxResponse.body);
    List<dynamic> messages = inboxData['hydra:member'];

    // Find the latest email from pCloud
    for (var message in messages) {
      if (message['subject'].contains('verification code')) {
        String messageId = message['id'];

        // Fetch full email content
        final emailResponse = await http.get(
          Uri.parse('https://api.mail.tm/messages/$messageId'),
          headers: {'Authorization': 'Bearer $authToken'},
        );

        if (emailResponse.statusCode == 200) {
          final emailData = jsonDecode(emailResponse.body);
          final otpMatch = RegExp(r'(\d{8})').firstMatch(emailData['text']);
          return otpMatch?.group(1) ?? '';
        }
      }
    }

    return ''; // No OTP found
  }

  static Future<void> loginWithOTP({required String email, required String password, required String otpCode}) async {
    final response = await http.get(
      Uri.parse('$_apiUrl/login?username=$email&password=$password&code=$otpCode'),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data['userid'] != null) {
      // Successful login with OTP
      accounts.add({
        'email': email,
        'auth': data['auth'],
        'userid': data['userid'],
        'freeSpace': data['quota'] - data['usedquota'],
      });
    } else {
      throw Exception('Login with OTP failed: ${data['error'] ?? 'Unknown error'}');
    }
  }

  static Future<int> uploadFile({String selectedEmailAccount = '', required String filePath}) async {
    final file = File(filePath);
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$_apiUrl/uploadfile'),
    );

    if(selectedEmailAccount.isNotEmpty) {
      final account = accounts.firstWhere((element) => element['email'] == selectedEmailAccount);
      request.fields['auth'] = account['auth'];
    } else {
      accounts.sort((a, b) => b['freeSpace'].compareTo(a['freeSpace']));
      final bestAccount = accounts.first;
      request.fields['auth'] = bestAccount['auth'];
    }

    request.files.add(await http.MultipartFile.fromPath('file', file.path));

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      final data = jsonDecode(responseData);
      if (data['metadata'] != null && (data['metadata'] as List<dynamic>).isNotEmpty && data['metadata'][0] != null && data['metadata'][0]['fileid'] != null) {
        int index = accounts.indexWhere((element) => element['email'] == selectedEmailAccount);
        if(index != -1) {
          accounts[index]['freeSpace'] -= data['metadata'][0]['size'];
        }
        return data['metadata'][0]['fileid'];
      } else {
        throw Exception('Failed to get file id: ${data ?? 'Unknown error'}');
      }
    } else {
      throw Exception('Failed to upload file');
    }
  }

  static Future<String> getFileLink({required String authToken, required int fileId}) async {
    final response = await http.get(
      Uri.parse('$_apiUrl/getfilelink?auth=$authToken&fileid=$fileId'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['result'] == 0) {
        return data['hosts'][0]+data['path'];
      } else {
        throw Exception('Failed to get public link: ${data['error'] ?? 'Unknown error'}');
      }
    } else {
      throw Exception('Failed to connect to pCloud');
    }
  }

  static Future<String> uploadAndGetLink({String selectedEmailAccount = ''}) async {

    String authToken = '';
    if(selectedEmailAccount.isNotEmpty) {
      authToken = accounts.firstWhere((element) => element['email'] == selectedEmailAccount)['auth'];
    } else {
      accounts.sort((a, b) => b['freeSpace'].compareTo(a['freeSpace']));
      authToken = accounts.first['auth'];
    }

    FilePickerResult? result = await FilePicker.platform.pickFiles();
    // upload the file using uploadFile function
    if(result != null && result.files.isNotEmpty && result.files.first.path != null && result.files.first.path!.isNotEmpty) {
      final int fileId = await uploadFile(selectedEmailAccount: selectedEmailAccount, filePath: result.files.first.path!);
      final String fileURl = await getFileLink(authToken: authToken, fileId: fileId);
      return fileURl;
    } else {
      throw Exception('Failed to select file');
    }
  }
}