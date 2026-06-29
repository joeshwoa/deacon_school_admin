import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'loading_app_custom.dart';

class CacheImageCustom extends StatelessWidget {
  final BoxFit? boxFit;
  final String image;
  final double? width;
  final double? height;

  const CacheImageCustom({
    super.key,
    required this.image,
    this.width,
    this.height,
    this.boxFit,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: image,
      width: width,
      height: height,
      fit: boxFit ?? BoxFit.cover,
      placeholder: (context, url) => LoadingAppCustom(
        size: width != null && height != null
            ? (width! < height! ? (width! / 3) : (height! / 3))
            : 30,
      ),
    );
  }
}
