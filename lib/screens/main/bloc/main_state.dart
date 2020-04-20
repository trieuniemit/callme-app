import 'package:app.callme/models/call_history.dart';
import 'package:app.callme/models/user_model.dart';

class MainState  {
  final List<User> contact;
  final List<User> history;
  User callingUser;


  final bool contactLoading;
  final bool historyLoading;

  static MainState init() {
    return MainState(contactLoading: true, historyLoading: true);
  }

  MainState({
    this.contact = const [], 
    this.history = const [], 
    this.callingUser,
    this.contactLoading = false,
    this.historyLoading = false
  });

  MainState copyWith({ 
    List<User> contact, 
    User callingUser,
    List<CallHistory> history,
    Map<String, dynamic>offerRecieved,
    bool historyLoading, 
    bool contactLoading}
  ) {
    return MainState(
      contact: contact == null ? this.contact : contact,
      history: history == null ? this.history : history,
      callingUser: callingUser == null ? this.callingUser : callingUser,
      contactLoading: contactLoading == null ? this.contactLoading : contactLoading,
      historyLoading: historyLoading == null ? this.historyLoading : historyLoading,
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
      contactLoading: false,
    );
  }
  
  MainState historyLoaded(List<CallHistory> history) {
    return this.copyWith(
      history: history,
      historyLoading: false
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
