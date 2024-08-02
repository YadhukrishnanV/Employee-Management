class EmployeeListModel {
  String? status;
  List<Employees>? data;
  String? message;

  EmployeeListModel({this.status, this.data, this.message});

  EmployeeListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Employees>[];
      json['data'].forEach((v) {
        data!.add(Employees.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    return data;
  }
}

class Employees {
  int? id;
  String? employeeName;
  int? employeeSalary;
  int? employeeAge;
  String? profileImage;

  Employees(
      {this.id,
        this.employeeName,
        this.employeeSalary,
        this.employeeAge,
        this.profileImage});

  Employees.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    employeeName = json['employee_name'];
    employeeSalary = json['employee_salary'];
    employeeAge = json['employee_age'];
    profileImage = json['profile_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['employee_name'] = employeeName;
    data['employee_salary'] = employeeSalary;
    data['employee_age'] = employeeAge;
    data['profile_image'] = profileImage;
    return data;
  }
}
