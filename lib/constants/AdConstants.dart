// lib/constants/ad_constants.dart
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdConstants {
  static const int maxFailedLoadAttempts = 3;
  static const String adUnitId = 'ca-app-pub-2914276526243261/1514461526';
  static const String adUnitIdIOS = 'ca-app-pub-2914276526243261/6543840589';
  static const AdRequest request = AdRequest(
    keywords: <String>['foo', 'bar'],
    contentUrl: 'http://foo.com/bar.html',
    nonPersonalizedAds: true,
  );
}
