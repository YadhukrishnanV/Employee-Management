class ApiUrls {
  static const baseUrl = "https://dummy.restapiexample.com/api/v1";
  static const listEmployees = "$baseUrl/employees";
  static  employeeDetails(String id) => "$baseUrl/employee/$id";
  static const createEmployee = "$baseUrl/create";
  static updateEmployee(String id) => "$baseUrl/update/$id";
  static deleteEmployee(String id) => "$baseUrl/delete/$id";
}