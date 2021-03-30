import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:trans/base/style/BaseStyle.dart';

class ImageNetworkUtil{
  /// Loading image
  static CachedNetworkImage loadImage(String link,
      {double topLeftRadius = 10.0,
        double topRightRadius = 10.0,
        double bottomLeftRadius = 10.0,
        double bottomRightRadius = 10.0,
        double loadingSize = 20.0,
        BoxFit fit = BoxFit.cover,
        double height,
        BoxFit decorationFit = BoxFit.cover, String failLink = 'assets/images/failure.png'}) {

    CachedNetworkImage image = CachedNetworkImage(
      fit: fit,
      imageBuilder: (context, imageProvider) => Container(
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(topLeftRadius),
              topRight: Radius.circular(topRightRadius),
              bottomRight: Radius.circular(bottomRightRadius),
              bottomLeft: Radius.circular(bottomLeftRadius)),
          image: DecorationImage(image: imageProvider, fit: decorationFit),
        ),
      ),
      imageUrl: link,
      placeholder: (context, url) => Container(
          child:
          SpinKitFadingCube(color: primaryColor, size: loadingSize/2)),
      errorWidget: (context, url, err) =>Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(topLeftRadius),
              topRight: Radius.circular(topRightRadius),
              bottomRight: Radius.circular(bottomRightRadius),
              bottomLeft: Radius.circular(bottomLeftRadius)),
          image: DecorationImage(image: AssetImage(failLink), fit: decorationFit),
        ),
      )
    );
    return image;
  }

  /// Loading image with round corner
  static CachedNetworkImage loadImageAllCorner(String link, double radius,
      {double loadingSize = 30.0,
        double height,
        BoxFit fit = BoxFit.cover,
        BoxFit decorationFit = BoxFit.cover,
        String failLink = 'assets/images/failure.png'}) {
    return loadImage(link,
        topLeftRadius: radius,
        topRightRadius: radius,
        bottomLeftRadius: radius,
        bottomRightRadius: radius,
        loadingSize: loadingSize,
        height: height,
        fit: fit,
        decorationFit: decorationFit, failLink: failLink);
  }

  /// Loading image
  static CachedNetworkImage loadIcon(String link,
      {double loadingSize = 20.0,
        double height,
       String failLink = 'assets/images/failure.png'}) {

    CachedNetworkImage image = CachedNetworkImage(
        imageBuilder: (context, imageProvider) => Container(
          height: height,
          decoration: BoxDecoration(
            image: DecorationImage(image: imageProvider),
          ),
        ),
        imageUrl: link,
        placeholder: (context, url) => Container(
            child:
            SpinKitFadingCube(color: primaryColor, size: loadingSize/2)),
        errorWidget: (context, url, err) =>Container(
          child: Image.asset(failLink),
        )
    );
    return image;
  }
}