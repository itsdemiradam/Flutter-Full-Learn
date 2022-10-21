import 'package:url_launcher/url_launcher_string.dart';

mixin LaunchMixin {

  void name(params); 
    
  Future<void> launchUrl(String url) async {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);}
    }
}