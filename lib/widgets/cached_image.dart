import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CachedImageWidget extends StatelessWidget {
  final String url;

  CachedImageWidget(this.url);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      fit: BoxFit.cover,
      imageUrl: url,
      placeholder: (context, url) => Image.asset(
          'assets/images/post_placeholder.png',
          width: double.maxFinite,
          height: 120.0,
          fit: BoxFit.cover),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }
}
