class VerifyOTP {
  int code;
  Data data;

  VerifyOTP({this.code, this.data});

  VerifyOTP.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  String requestId;
  String status;
  String eventId;
  String price;
  String currency;
  String estimatedPriceMessagesSent;

  Data(
      {this.requestId,
        this.status,
        this.eventId,
        this.price,
        this.currency,
        this.estimatedPriceMessagesSent});

  Data.fromJson(Map<String, dynamic> json) {
    requestId = json['request_id'];
    status = json['status'];
    eventId = json['event_id'];
    price = json['price'];
    currency = json['currency'];
    estimatedPriceMessagesSent = json['estimated_price_messages_sent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['request_id'] = this.requestId;
    data['status'] = this.status;
    data['event_id'] = this.eventId;
    data['price'] = this.price;
    data['currency'] = this.currency;
    data['estimated_price_messages_sent'] = this.estimatedPriceMessagesSent;
    return data;
  }
}

