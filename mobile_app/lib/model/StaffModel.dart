class StaffModel {
  late int id;
  late String name;
  late int age;
  late String role;
  late String imageURL;
  late String email;
  late String phone;
  StaffModel(this.id, this.name, this.age, this.role, this.imageURL, this.email,
      this.phone);
  factory StaffModel.fromJson(Map<String, dynamic> json) {
    try {
      return StaffModel(
        json['id'],
        json['name'],
        json['age'],
        json['role'],
        json['imageURL'],
        json['email'],
        json['phone'],
      );
    } catch (e) {
      throw const FormatException('Failed to create a StaffModel from JSON');
    }
  }
}
