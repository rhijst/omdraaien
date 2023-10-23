import 'package:omdraaien/util/util.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("Encrypt password1", () {
    // Encrypt password
    String password = "password1";
    String encryptedPassword = Util.encryptPassword(password);

    // encrypt passwords with SHA256
    // https://10015.io/tools/sha256-encrypt-decrypt
    String expectedEncryptedPassword =
        "0b14d501a594442a01c6859541bcb3e8164d183d32937b851835442f69d5c94e";

    //  check if encryption has worked
    expect(encryptedPassword, expectedEncryptedPassword);
  });
}
