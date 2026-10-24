import 'dart:convert';

import 'package:flutter/services.dart';

/// Layout tests isolate geometry from the host's native PNG decoder.
/// The Android integration test renders and captures every real image.
class LayoutAssets extends CachingAssetBundle {
  static final _pixel = base64Decode(
    'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAIAAACQd1PeAAAADElEQVR4nGP4//8/AAX+Av4N70a4AAAAAElFTkSuQmCC',
  );
  @override
  Future<ByteData> load(String key) async {
    if (key.startsWith('assets/images/')) return ByteData.sublistView(_pixel);
    if (key == 'AssetManifest.bin') {
      const codec = StandardMessageCodec();
      final manifest = Map<Object?, Object?>.from(
        codec.decodeMessage(await rootBundle.load(key)) as Map,
      );
      for (final asset in manifest.keys.toList()) {
        if (asset.toString().startsWith('assets/images/')) {
          manifest[asset] = [
            {'asset': 'assets/images/layout-pixel.png', 'dpr': 1.0},
          ];
        }
      }
      return codec.encodeMessage(manifest)!;
    }
    return rootBundle.load(key);
  }
}
