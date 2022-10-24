import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_cache_manager/file.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CacheImage extends StatefulWidget {
  const CacheImage(this.url,
      {this.placeholder, this.fit, this.height, this.width, this.borderRadius});

  final String url;
  final Widget? placeholder;
  final BoxFit? fit;
  final double? height;
  final double? width;
  final double? borderRadius;

  @override
  State<CacheImage> createState() => _CacheImageState();
}

class _CacheImageState extends State<CacheImage>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> opacity;
  File? img;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
    opacity = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));
    controller.forward();
  }

  Future<File?> loadImg() async {
    try {
      var dw = DefaultCacheManager();
      FileInfo? fl;
      fl = await dw.getFileFromCache(widget.url);
      fl ??= await dw.downloadFile(widget.url);
      img = fl.file;
      return img;
    } catch (e) {
      print(e);
    }
    return null;
  }

  @override
  void dispose() {
    controller.dispose();
    img = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.borderRadius ?? 0),
      child: img != null
          ? Image.file(img!,
              fit: widget.fit, height: widget.height, width: widget.width)
          : FutureBuilder(
              future: loadImg(),
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.done &&
                    snap.data != null) {
                  return FadeTransition(
                    opacity: opacity,
                    child: Image.file(snap.data as File,
                        fit: widget.fit,
                        height: widget.height,
                        width: widget.width),
                  );
                } else {
                  return widget.placeholder ?? const SizedBox.shrink();
                }
              },
            ),
    );
  }
}
