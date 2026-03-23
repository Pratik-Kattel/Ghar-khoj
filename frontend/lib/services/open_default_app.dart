import 'package:url_launcher/url_launcher.dart';
class OpenDefaultApp {
  static Future<void> openFacebook() async{
    final Uri url=Uri.parse("https://www.facebook.com/pratik.jodzx");
    if(!await launchUrl(url,mode: LaunchMode.externalApplication)){
      throw Exception("Targeted URL not found, $url");
    }
  }
  static Future<void> openInstagram() async{
    final Uri url=Uri.parse("https://www.instagram.com/_ppprrraaatttiiikkk_/");
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