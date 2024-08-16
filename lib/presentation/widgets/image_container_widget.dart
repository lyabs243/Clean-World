import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:structure/utils/constants.dart';

class ImageContainerWidget extends StatelessWidget {

  final ImageProvider image;
  final double? width, height;
  final Widget? child;
  final EdgeInsetsGeometry padding;
  final ColorFilter? colorFilter;
  final BorderRadius borderRadius;

  const ImageContainerWidget({super.key, required this.image, this.width, this.height, this.child,
    this.padding = EdgeInsets.zero, this.colorFilter, this.borderRadius = BorderRadius.zero});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        color: colorPrimary,
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: borderRadius,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    filterQuality: FilterQuality.high,
                    image: image,
                    fit: BoxFit.cover,
                    colorFilter: colorFilter,
                  ),
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius:
              BorderRadius.circular(25),
              image: DecorationImage(
                filterQuality: FilterQuality.high,
                image: image,
                colorFilter: colorFilter,
              ),
            ),
          ),
          Padding(
            padding: padding,
            child: child ?? const SizedBox(),
          ),
        ],
      ),
    );
  }

}