

class AppConfig {
  static String selectedCompany = '';

  static String databaseName = '';

  static String branchId = '';

  static String branchName = '';

  static String allowedDatabases = '';

  static String userId = '';

  static String userName = '';

  static String designation = "";

    static bool get isAdministrator =>
      designation.trim().toUpperCase() == "ADMINISTRATOR";

  static bool get canApprove =>
      isAdministrator;
}