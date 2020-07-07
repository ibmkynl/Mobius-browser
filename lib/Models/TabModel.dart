class TabModel {
  int id;
  String link;

  TabModel(this.link);
  TabModel.withId(this.id, this.link);

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['id'] = id;
    map['link'] = link;
    return map;
  }

  TabModel.fromMapObject(Map<String, dynamic> map) {
    this.id = map['id'];
    this.link = map['link'];
  }
}
