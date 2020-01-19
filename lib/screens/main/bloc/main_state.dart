import 'package:app.callme/models/user_model.dart';
import 'package:app.callme/screens/main/bloc/bloc.dart';


class MainState  {
  final List<User> contact;
  final List<User> histories;
  User callingUser;
  final Map<String, dynamic> webRTCDesc;
  final bool loading;

  static MainState init() {
    return MainState(loading: true);
  }

  MainState({
    this.webRTCDesc, 
    this.contact = const [], 
    this.histories = const [], 
    this.callingUser,
    this.loading = false
  });

  MainState copyWith({ 
    List<User> contact, 
    User callingUser,
    Map<String, dynamic>webRTCDesc,
    bool loading,
    List<User> histories}
  ) {
    return MainState(
      webRTCDesc: webRTCDesc==null?this.webRTCDesc:webRTCDesc,
      contact: contact == null ? this.contact : contact,
      histories: histories == null ? this.histories : histories,
      callingUser: callingUser == null ? this.callingUser : callingUser,
      loading: loading == null ? this.loading : loading,
    );
  }

  MainState callRecieved(User targetUser, {Map<String, dynamic> webRTCDesc}) {
    return this.copyWith(
      webRTCDesc: webRTCDesc,
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
