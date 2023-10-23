// Encrypt password
import 'dart:convert';
import 'package:crypto/crypto.dart';

class Util {
  static String encryptPassword(String password) {
    // Convert password to bytes
    var bytes = utf8.encode(password);

    // Generate hash using SHA-256
    var sha256Password = sha256.convert(bytes);

    // Convert hash to hexadecimal representation
    var encryptedPassword = sha256Password.toString();

    return encryptedPassword;
  }
}
