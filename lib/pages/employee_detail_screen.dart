import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/employee_controller.dart';

class EmployeeDetailScreen extends StatefulWidget {
  final int employeeId;

  const EmployeeDetailScreen({super.key, required this.employeeId});

  @override
  _EmployeeDetailScreenState createState() => _EmployeeDetailScreenState();
}

class _EmployeeDetailScreenState extends State<EmployeeDetailScreen> {
  final EmployeeController employeeController = Get.find<EmployeeController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      employeeController.fetchEmployeeDetails(widget.employeeId);
    });
  }

  void _showEditDialog() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController salaryController = TextEditingController();
    final TextEditingController ageController = TextEditingController();

    final employee = employeeController.employeeDetail;

    nameController.text = employee.value.data!.employeeName!;
    salaryController.text = employee.value.data!.employeeSalary.toString();
    ageController.text = employee.value.data!.employeeAge!.toString();

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
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
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  try {
                    Navigator.pop(context);
                    employeeController.updateEmployeeDetails(
                        widget.employeeId,
                        nameController.text,
                        salaryController.text,
                        ageController.text);
                  } catch (e) {
                    // Handle error
                    Get.snackbar('Error', 'Failed to update employee');
                  }
                },
                child: const Text('Update'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee Details'),
      ),
      body: Obx(() {
        if (employeeController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (employeeController.error.isNotEmpty) {
          return Center(
              child: Text('Error: ${employeeController.error.value}'));
        } else {
          final employee = employeeController.employeeDetail;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: SizedBox(
                height: MediaQuery.of(context).size.height/2,
                width: MediaQuery.of(context).size.width/2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Name: ',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${employee.value.data!.employeeName}',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),

                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Salary: '),
                        Text('${employee.value.data!.employeeSalary}'),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Age: '),
                        Text('${employee.value.data!.employeeAge}'),
                      ],
                    ),
                    const SizedBox(height: 40,),
                    ElevatedButton(
                        onPressed: _showEditDialog,
                      child: const Text('Edit Details'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      }),
    );
  }
}
