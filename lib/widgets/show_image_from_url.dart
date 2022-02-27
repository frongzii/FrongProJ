// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:frongeasyshop/widgets/show_logo.dart';
import 'package:frongeasyshop/widgets/show_process.dart';

class ShowImageFromUrl extends StatelessWidget {
  final String path;
  const ShowImageFromUrl({
    Key? key,
    required this.path,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      height: 120,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CachedNetworkImage(
          imageUrl: path,
          errorWidget: (BuildContext context, String string, dynamic) =>
              const ShowLogo(),
          placeholder: (BuildContext context, String string) =>
              const ShowProcess(),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
