class Regexs {
  static RegExp phonenumber = RegExp(r'^[0-9]{9,12}$');
  static RegExp password = RegExp(r'^.{5,}$');
  static RegExp name = RegExp(r'^.{2,}$');
}