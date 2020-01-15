import 'package:app.callme/models/user_model.dart';


class MainState  {
  final List<User> contact;
  final List<User> histories;
  final User callingUser;
  final bool loading;

  static MainState init() {
    return MainState(loading: true);
  }

  MainState({
    this.contact = const [], 
    this.histories = const [], 
    this.callingUser,
    this.loading = false
  });

  MainState copyWith({ 
    List<User> contact, 
    User callingUser,
    bool loading,
    List<User> histories}
  ) {
    return MainState(
      contact: contact == null ? this.contact : contact,
      histories: histories == null ? this.histories : histories,
      callingUser: callingUser == null ? this.callingUser : callingUser,
      loading: loading == null ? this.loading : loading,
    );
  }

  MainState callRecieved(User targetUser) {
    return this.copyWith(
      callingUser: targetUser
    );
  }

  MainState contactLoaded(List<User> contact) {
    return this.copyWith(
      contact: contact,
      loading: false
    );
  }

}
