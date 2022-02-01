class Emp {
  late String empName;
  late int empCode;
  late String empPassword;
  late int secLevel;

  Emp({
    required this.empName, required this.empCode, required this.empPassword , required this.secLevel
    });
  Emp.fromJson(Map<String, dynamic> json) {
    empName = json['EmpName'];
    empCode = json['EmpCode'];
    empPassword = json['EmpPassword'];
    secLevel = json['SecLevel'];
  }

  static Emp newInstance() {
    return new Emp(
      empName:"",
      empCode:0,
      empPassword:"",
      secLevel:0,
    );
  }
}
