class Payment {
  String text;
  String code;
  String image;

  Payment({this.text, this.image, this.code});

  factory Payment.fromMap(Map<String, String> map) => Payment(
        text: map['text'],
        code: map['code'],
        image: map['image'],
      );

  /// Init data
  List<Payment> getPayments() {
    List<Payment> list = List();
    list.add(Payment(
        text: 'Thanh toán tận nơi',
        image: 'assets/images/cod.png',
        code: '0'));
//    list.add(Payment(
//        text: 'Thanh toán online',
//        image: 'assets/images/online.png',
//        code: 'Online'));

    return list;
  }
}
