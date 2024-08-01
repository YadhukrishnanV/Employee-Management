import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/employee_controller.dart';
import '../models/employeeListModel.dart';
import 'employee_detail_screen.dart';

class HomePage extends StatelessWidget {
  final EmployeeController employeeController = Get.put(EmployeeController());

  void _showAddEmployeeDialog() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController salaryController = TextEditingController();
    final TextEditingController ageController = TextEditingController();

    showDialog(
      context: Get.context!,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Employee'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: salaryController,
                decoration: const InputDecoration(labelText: 'Salary'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: ageController,
                decoration: const InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  Navigator.pop(context);
                  await employeeController.addEmployee(
                    nameController.text,
                    salaryController.text,
                    ageController.text,
                  );
                } catch (e) {
                  Get.snackbar('Error', 'Failed to add employee');
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text('Employee List'),
            const SizedBox(width: 80),
            InkWell(
              onTap: _showAddEmployeeDialog,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.add),
                  Text("ADD")
                ],
              ),
            ),
          ],
        ),
      ),
      body: Obx(() {
        if (employeeController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (employeeController.error.isNotEmpty) {
          return Center(child: Text('Error: ${employeeController.error.value}'));
        } else {
          return ListView.builder(
            itemCount: employeeController.employees.length,
            itemBuilder: (context, index) {
              Employees employee = employeeController.employees[index];
              return ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(employee.employeeName!),
                    InkWell(
                      onTap: () {
                        try {
                          employeeController.deleteEmployee(
                            employee.id.toString()
                          );
                        } catch (e) {
                          Get.snackbar('Error', 'Failed to add employee');
                        }
                      },
                      child: const Icon(Icons.delete),
                    )
                  ],
                ),
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
