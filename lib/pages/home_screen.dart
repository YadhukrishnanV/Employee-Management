import 'package:employee_management/pages/employee_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/employee_controller.dart';
import '../models/employeeListModel.dart';

class HomePage extends StatelessWidget {
  final EmployeeController employeeController = Get.put(EmployeeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Employee List'),
      ),
      body: Obx(() {
        if (employeeController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        } else if (employeeController.error.isNotEmpty) {
          return Center(child: Text('Error: ${employeeController.error.value}'));
        } else {
          return ListView.builder(
            itemCount: employeeController.employees.length,
            itemBuilder: (context, index) {
              Employees employee = employeeController.employees[index];
              return ListTile(
                title: Text(employee.employeeName!),
                subtitle: Text('Salary: ${employee.employeeSalary}'),
                onTap: () {
                  Get.to(EmployeeDetailScreen(employeeId: employee.id!));
                },
              );
            },
          );
        }
      }),
    );
  }
}
