class Auth0State {
  final bool isBusy;
  final bool isLoggedIn;
  final Map? data;
 final String? errorMessage;

 const Auth0State({
    this.isBusy = false,
    this.isLoggedIn = false,
    this.data,
    this.errorMessage,
  });

  Auth0State copyWith({
    bool isBusy = false,
    bool isLoggedIn = false,
    Map? data,
    String? errorMessage,
  }) {
    return Auth0State(
      isBusy: isBusy,
      isLoggedIn: isLoggedIn,
      data: data ?? this.data,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
