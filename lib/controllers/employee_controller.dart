import 'package:get/get.dart';

import '../models/employeeListModel.dart';
import '../models/employee_detail_model.dart';
import '../services/employee_services.dart';

class EmployeeController extends GetxController {
  final EmployeeService _employeeService = EmployeeService();

  var employees = [].obs;
  var isLoading = true.obs;
  var error = ''.obs;
  Rx<EmployeeDetailModel> employeeDetail = EmployeeDetailModel().obs;
  @override
  void onInit() {
    super.onInit();
    fetchEmployees();
  }

  changeIsLoading(bool value){
    isLoading(value);
  }

  Future<void> fetchEmployees() async {
    try {
      isLoading(true);
      final fetchedEmployees = await _employeeService.fetchAllEmployees();
      employees.assignAll(fetchedEmployees.data!);
    } catch (e) {
      error(e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchEmployeeDetails(int id) async {
    try {
      isLoading(true);
      _employeeService.fetchEmployeeById(id).then((value) {
        print("!!!$value");
        employeeDetail(value!);
        isLoading(false);
      },);
    } catch (e) {
      isLoading(false);
      error(e.toString());
    }
  }

  Future<void> updateEmployeeDetails(int employeeId, String name, String salary, String age)async{
    try {
      isLoading(true);
      EmployeeService.updateEmployee(employeeId,
          name,salary,
          age).then((value) {
        print("!!!$value");
        if (value.data != null) {
          employeeDetail.update((employee) {
            employee!.data!.employeeName = value.data!.name;
            employee.data!.employeeSalary = int.parse(value.data!.salary!);
            employee.data!.employeeAge = int.parse(value.data!.age!);
          });
          isLoading(false);
        }
          },);
    } catch (e) {
      isLoading(false);
      error(e.toString());
    }
  }

  Future<void> addEmployee(String name, String salary, String age) async {
    try {
      isLoading(true);
      final response = await _employeeService.createEmployee(name, salary, age);
      Employees employee = Employees();
      employee.employeeName = response.data!.name;
      employee.employeeAge = int.parse(response.data!.age!);
      employee.employeeSalary = int.parse(response.data!.salary!);
      employee.id = response.data!.id;
       employees.add(employee);
      isLoading(false);
    } catch (e) {
      isLoading(false);
      error(e.toString());
    }
  }

  deleteEmployee(String id)async{
    try {
      isLoading(true);
      await _employeeService.deleteEmployee(id);
      employees.removeWhere((employee) {
        return employee.id.toString() == id.toString();
      });
      isLoading(false);
    } catch (e) {
      isLoading(false);
      error(e.toString());
    }
  }

}

