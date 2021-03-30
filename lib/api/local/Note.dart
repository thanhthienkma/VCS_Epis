class Note {
  String shipText;
  String noteText;

  Note({this.shipText, this.noteText});

  Note.fromJson(Map<String, dynamic> json) {
    shipText = json['shippingText'];
    noteText = json['noteText'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['shippingText'] = this.shipText;
    data['noteText'] = this.noteText;
    return data;
  }

}