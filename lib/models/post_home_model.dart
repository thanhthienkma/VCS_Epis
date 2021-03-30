class PostHomeModel {
  Category category;
  int id;
  String title;
  String body;
  String image;
  String date;
  String link;
  bool bookmarked;

  PostHomeModel(
      {this.category,
      this.id,
      this.title,
      this.body,
      this.image,
      this.date,
      this.link,
      this.bookmarked});

  PostHomeModel.fromJson(Map<String, dynamic> json) {
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
    id = json['id'];
    title = json['title'];
    body = json['body'];
    image = json['image'];
    date = json['date'];
    link = json['link'];
    bookmarked = json['bookmarked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.category != null) {
      data['category'] = this.category.toJson();
    }
    data['id'] = this.id;
    data['title'] = this.title;
    data['body'] = this.body;
    data['image'] = this.image;
    data['date'] = this.date;
    data['link'] = this.link;
    data['bookmarked'] = this.bookmarked;
    return data;
  }
}

class Category {
  int id;
  String name;

  Category({this.id, this.name});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
