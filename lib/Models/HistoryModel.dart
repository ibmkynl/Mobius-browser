class HistoryModel {
  String link;
  int id;
  int date;

  HistoryModel(this.link, this.date);

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['id'] = id;
    map['link'] = link;
    map['date'] = date;
    return map;
  }

  HistoryModel.fromMapObject(Map<String, dynamic> map) {
    this.id = map['id'];
    this.link = map['link'];
    this.date = map['date'];
  }
}
