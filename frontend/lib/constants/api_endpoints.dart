class ApiEndpoints{
  static final String baseUrl="http://192.168.1.109:5000/api/gharKhoj";
  static final String imageBaseUrl = "http://192.168.1.109:5000/uploads/";
  // static const String imageBaseUrl = "http://10.0.2.2:5000/uploads/";
  static  String login="$baseUrl/loginUser";
  static String register="$baseUrl/registerUser";
  static String validateEmail="$baseUrl/validateEmail";
  static String validateOTP="$baseUrl/validateOTP";
  static String changePassword="$baseUrl/changePassword";
  static String getUserName="$baseUrl/getUsername";
  static String sendLocation="$baseUrl/storeUserLocation";
  static String changeName="$baseUrl/changeName";
  static String uploadHouse="$baseUrl/uploadHouse";
  static String nearByHouses="$baseUrl/nearbyHouses";
  static String hotDeals = "$baseUrl/hotDeals";
}