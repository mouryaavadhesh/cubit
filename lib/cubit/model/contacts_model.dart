class ContactsModel {
  String? name;
  String? phones;
  List<int>? photo;

  ContactsModel({this.name, this.phones});

  ContactsModel.fromJson(Map<String, dynamic> json) {
    phones = json['phones'];
    name = json['name'];
    photo = json['photo'].cast<int>()??[];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['phones'] = phones;
    data['name'] = name;
    data['photo'] = photo;

    return data;
  }
}
