
import 'package:app.callme/config/constants.dart';
import 'package:app.callme/services/api_service.dart';

class ContactRepository {
  Future<Map<String, dynamic>> getContact(token) async {
    return await ApiService.request(
      method: Request.GET,
      path: Constants.GET_CONTACT,
      apiHeaders: {
        "Authorization":  "Bearer $token"
      }
    );
  }
}