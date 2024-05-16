abstract class Failure implements Exception {
  String? title;
  String? message;

  Failure({
    this.title,
    this.message,
  });
}

class LoginFailure extends Failure {
  LoginFailure({super.message})
      : super(
          title: "Login Failed",
        );
}
