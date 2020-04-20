import 'package:app.callme/models/user_model.dart';
import 'package:app.callme/screens/main/bloc/bloc.dart';


class MainState  {
  final List<User> contact;
  final List<User> histories;
  User callingUser;


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
    Map<String, dynamic>offerRecieved,
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

  MainState callRecieved(User targetUser, {Map<String, dynamic> offerRecieved}) {
    return this.copyWith(
      offerRecieved: offerRecieved,
      callingUser: targetUser
    );
  }

  void callToUser(User target) {
    this.callingUser = target;
  }

  MainState contactLoaded(List<User> contact) {
    return this.copyWith(
      contact: contact,
      loading: false
    );
  }

  MainState updateContact(User user) {
    try {
      int indexContact = contact.indexWhere((c) => c.id == user.id);
      contact[indexContact].socketId = user.socketId;
      return copyWith();
    } catch (_) {
      contact.insert(0, user);
      return copyWith();
    }
  }

}
