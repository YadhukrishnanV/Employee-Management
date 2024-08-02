class CreateEmployeeModel {
  String? status;
  Data? data;
  String? message;

  CreateEmployeeModel({this.status, this.data, this.message});

  CreateEmployeeModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = message;
    return data;
  }
}

class Data {
  String? name;
  String? salary;
  String? age;
  int? id;

  Data({this.name, this.salary, this.age, this.id});

  Data.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    salary = json['salary'];
    age = json['age'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['salary'] = salary;
    data['age'] = age;
    data['id'] = id;
    return data;
  }
}
