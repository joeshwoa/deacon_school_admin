
import 'dart:developer';

import 'package:url_launcher/url_launcher.dart';

launchLink(Uri uri)async{
  try{
    await launchUrl(uri);
  }catch(e){
    log(e.toString());
  }
}
