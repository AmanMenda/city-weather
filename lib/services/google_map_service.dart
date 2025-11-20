import 'package:url_launcher/url_launcher.dart';

class MapService {
  Future<void> openMap(double lat, double lon) async {
    final googleMapsUrl = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lon');

    try {
      if (!await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication)) {
        final geoUrl = Uri.parse('geo:$lat,$lon');
        if (!await launchUrl(geoUrl)) {
           throw Exception('Could not launch map');
        }
      }
    } catch (e) {
      throw Exception('Could not launch map: $e');
    }
  }
}