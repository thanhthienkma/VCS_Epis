class Photo {
  String path;
  String identifier;

  Photo(this.path, this.identifier);

  bool operator ==(other) {
    return other is Photo && path == other.path && identifier == other.identifier;
  }

  @override
  int get hashCode => path.hashCode;

  Photo.fromJson(Map<String, dynamic> json) {
    path = json['path'];
    identifier = json['identifier'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['path'] = this.path;
    data['identifier'] = this.identifier;
    return data;
  }
}
