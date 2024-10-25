class LoginAccount {
  final String email;
  final String password;

  LoginAccount(this.email, this.password);

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
      };
}

class LoginCredentials {
  String email = '';
  String password = '';

  LoginAccount toLogin() {
    return LoginAccount(email, password);
  }
}

class SignUpCredentials {
  String username = '';
  String email = '';
  String password = '';
  String nationalId = '';
  String firstName = '';
  String middleName = '';
  String lastName = '';
  String phoneNumber = '';

  Map<String, dynamic> toJson() => {
        'username': username,
        'email': email,
        'password': password,
        'nationalId': nationalId,
        'firstName': firstName,
        'middleName': middleName,
        'lastName': lastName,
        'phoneNumber': phoneNumber
      };
}
