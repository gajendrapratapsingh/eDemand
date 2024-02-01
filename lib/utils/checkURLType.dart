import 'package:path/path.dart' as p;

enum UrlType { image, video, unknown }

class UrlTypeHelper {
  static final List<String> _image_types = [
    'jpg',
    'jpeg',
    'jfif',
    'pjpeg',
    'pjp',
    'png',
    'svg',
    'gif',
    'apng',
    'webp',
    'avif'
  ];

  static final List<String> _video_types = [
    "3g2",
    "3gp",
    "aaf",
    "asf",
    "avchd",
    "avi",
    "drc",
    "flv",
    "m2v",
    "m3u8",
    "m4p",
    "m4v",
    "mkv",
    "mng",
    "mov",
    "mp2",
    "mp4",
    "mpe",
    "mpeg",
    "mpg",
    "mpv",
    "mxf",
    "nsv",
    "ogg",
    "ogv",
    "qt",
    "rm",
    "rmvb",
    "roq",
    "svi",
    "vob",
    "webm",
    "wmv",
    "yuv"
  ];

  static UrlType getType(final url) {
    try {
      final Uri uri = Uri.parse(url);
      String extension = p.extension(uri.path).toLowerCase();
      if (extension.isEmpty) {
        return UrlType.unknown;
      }

      extension = extension.split('.').last;
      if (_image_types.contains(extension)) {
        return UrlType.image;
      } else if (_video_types.contains(extension)) {
        return UrlType.video;
      }
    } catch (e) {
      return UrlType.unknown;
    }
    return UrlType.unknown;
  }
}
