class FavModel {
  String name;
  String link;
  int id;

  FavModel(this.link, this.name);

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['id'] = id;
    map['link'] = link;
    map['name'] = name;
    return map;
  }

  FavModel.fromMapObject(Map<String, dynamic> map) {
    this.id = map['id'];
    this.link = map['link'];
    this.name = map['name'];
  }
}
