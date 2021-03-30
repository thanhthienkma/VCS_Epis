import 'package:trans/api/local/Note.dart';
import 'package:trans/api/local/PackageFee.dart';
import 'package:trans/api/local/ReceiverAddress.dart';
import 'package:trans/api/local/SenderAddress.dart';
import 'package:trans/api/result/WareHouse.dart' as wh;

class PrepareOrderSupport {
  SenderAddress senderAddress;
  ReceiverAddress receiverAddress;
  Note note;
  PackageFee packageFee;
  wh.Result wareHouse;

  PrepareOrderSupport(
      {this.senderAddress,
      this.receiverAddress,
      this.note,
      this.packageFee,
      this.wareHouse});

  PrepareOrderSupport.fromJson(Map<String, dynamic> json) {
    senderAddress = json['senderAddress'] != null
        ? new SenderAddress.fromJson(json['senderAddress'])
        : null;
    receiverAddress = json['receiverAddress'] != null
        ? new ReceiverAddress.fromJson(json['receiverAddress'])
        : null;
    note = json['note'] != null ? new Note.fromJson(json['note']) : null;
    wareHouse = json['wareHouse'] != null
        ? new wh.Result.fromJson(json['wareHouse'])
        : null;
    packageFee = json['packageFee'] != null
        ? new PackageFee.fromJson(json['packageFee'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.senderAddress != null) {
      data['senderAddress'] = this.senderAddress.toJson();
    }
    if (this.receiverAddress != null) {
      data['receiverAddress'] = this.receiverAddress.toJson();
    }
    if (this.note != null) {
      data['note'] = this.note.toJson();
    }
    if (this.wareHouse != null) {
      data['wareHouse'] = this.wareHouse.toJson();
    }
    if (this.packageFee != null) {
      data['packageFee'] = this.packageFee.toJson();
    }
    return data;
  }
}
