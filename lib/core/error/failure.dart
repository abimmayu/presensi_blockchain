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

class HomeFailure extends Failure {
  HomeFailure({super.message})
      : super(
          title: "Home Data failed to Get!",
        );
}

class PresentFailure extends Failure {
  PresentFailure({super.message})
      : super(
          title: "Present data failed to Send!",
        );
}
