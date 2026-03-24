import 'package:url_launcher/url_launcher.dart';
class OpenDefaultApp {
  static Future<void> openFacebook() async{
    final Uri url=Uri.parse("https://www.facebook.com/pratik.jodzx");
    if(!await launchUrl(url,mode: LaunchMode.externalApplication)){
      throw Exception("Targeted URL not found, $url");
    }
  }
  static Future<void> openGit() async{
    final Uri url=Uri.parse("https://github.com/Pratik-Kattel");
    if(!await launchUrl(url,mode: LaunchMode.externalApplication)){
      throw Exception("Targeted URL not found, $url");
    }
  }

  static Future<void> openLinkedin() async{
    final Uri url=Uri.parse("https://www.linkedin.com/in/pratik-kattel-281a71326/");
    if(!await launchUrl(url,mode: LaunchMode.externalApplication)){
      throw Exception("Targeted URL not found, $url");
    }
  }

  static Future<void> openPhone() async{
    final Uri url=Uri.parse("tel:9827388429");
    if(!await launchUrl(url,mode: LaunchMode.externalApplication)){
      throw Exception("Targeted URL not found, $url");
    }
  }
}