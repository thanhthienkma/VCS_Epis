class CategoryModel {
  final int count;
  final String description;
  final int id;
  final String link;
  final String name;
  final int parent;
  final String slug;

  CategoryModel(this.count, this.description, this.id, this.link, this.name,
      this.parent, this.slug);

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
        int.parse(json['count'].toString()),
        json['description'],
        int.parse(json['id'].toString()),
        json['link'],
        json['name'],
        int.parse(json['parent'].toString()),
        json['slug']);
  }
}
