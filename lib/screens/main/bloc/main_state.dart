import 'package:app.callme/models/call_history.dart';
import 'package:app.callme/models/user_model.dart';
import 'package:app.callme/screens/main/bloc/bloc.dart';

class MainState  {
  final List<User> contact;
  final List<CallHistory> history;
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
    bool historyLoading, 
    bool contactLoading}
  ) {
    return MainState(
      contact: contact == null ? this.contact : contact,
      history: history == null ? this.history : history,
      callingUser: callingUser,
      contactLoading: contactLoading == null ? this.contactLoading : contactLoading,
      historyLoading: historyLoading == null ? this.historyLoading : historyLoading,
    );
  }

  MainState callRecieved(User targetUser, {Map<String, dynamic> offerRecieved}) {
    return this.copyWith(
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
    List<CallHistory> his = List.from(this.history);
    his.addAll(history);

    return this.copyWith(
      history: his,
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

  MainState addHistory(CallHistory history) {
    List<CallHistory> his = List.from(this.history);
    his.add(history);
    return this.copyWith(
      history: his,
      callingUser: null
    );
  }

}
