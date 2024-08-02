import 'dart:convert';
import 'package:employee_management/helpers/api_urls.dart';
import 'package:employee_management/models/create_employee_model.dart';
import 'package:employee_management/models/employeeListModel.dart';
import 'package:employee_management/models/employee_detail_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../models/updated_model.dart';

class EmployeeService {

  ///"429 Too Many Requests": retry mechanism
  static Future<http.Response> _retryRequest(Future<http.Response> Function() request,
      {int retries = 20,}) async {
    int sec = 3;
    http.Response response;
    int attempt = 0;
    while (attempt < retries) {
      attempt++;
      response = await request();
      debugPrint("attempt $attempt");
      debugPrint("response ${response.body}");
      if (response.statusCode != 429) {
        return response;
      }
      sec++;
      await Future.delayed(Duration(seconds: sec));
    }
    throw Exception('Failed after $retries attempts');
  }
  
  Future<EmployeeListModel> fetchAllEmployees() async {
    // final response = await http.get(Uri.parse(ApiUrls.listEmployees));
    final response = await _retryRequest(() => http.get(Uri.parse(ApiUrls.listEmployees)));

    if (response.statusCode == 200) {
      return EmployeeListModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load employees');
    }
  }

  Future<EmployeeDetailModel?> fetchEmployeeById(int id) async {
    final response = await _retryRequest(() => http.get(Uri.parse(ApiUrls.employeeDetails(id.toString()))));
    debugPrint(response.toString());
    if (response.statusCode == 200) {
      return EmployeeDetailModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load employee');
    }
  }

  Future<CreateEmployeeModel> createEmployee(String name, String salary, String age) async {
    final response = await _retryRequest(() => http.post(
      Uri.parse(ApiUrls.createEmployee),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'name': name,
        'salary': salary,
        'age': age,
      }),
    )
    );

    if (response.statusCode == 200) {
      debugPrint("response ${response.body}");
      return CreateEmployeeModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create employee');
    }
  }

  static Future<UpdatedEmployeeModel> updateEmployee(int id, String name, String salary, String age) async {
try{
    debugPrint("step 1");
    final response = await _retryRequest(() => http.put(
      Uri.parse(ApiUrls.updateEmployee(id.toString())),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'name': name,
        'salary': salary,
        'age': age,
      }),
    ));
    debugPrint("got response");

    if (response.statusCode == 200) {
      return UpdatedEmployeeModel.fromJson(json.decode(response.body));
    } else {
      debugPrint("wrong status code");
      throw Exception('Failed to update employee');
    }}catch(e){
  debugPrint("exception $e");
  throw Exception(e);
}
  }

  Future<void> deleteEmployee(String id) async {
    final response = await _retryRequest(() => http.delete(Uri.parse(ApiUrls.deleteEmployee(id))));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete employee');
    }
  }
}
