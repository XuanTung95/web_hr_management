class UserModel {

  static const String TYPE_GIAO_VIEN = "giao_vien";
  static const String TYPE_NHAN_VIEN = "nhan_vien";
  static const String TYPE_GIAM_HIEU = "giam_hieu";

  String? id;
  String? image;
  String? name;
  String? birth;
  String? address;
  String? education;
  String? position;
  String? achievements;
  String? type;

  UserModel(
      {this.image,
        this.id,
        this.name,
        this.birth,
        this.address,
        this.education,
        this.position,
        this.type,
        this.achievements});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    name = json['name'];
    birth = json['birth'];
    address = json['address'];
    education = json['education'];
    position = json['position'];
    type = json['type'];
    achievements = json['achievements'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    data['name'] = this.name;
    data['birth'] = this.birth;
    data['type'] = this.type;
    data['address'] = this.address;
    data['education'] = this.education;
    data['position'] = this.position;
    data['achievements'] = this.achievements;
    return data;
  }
}