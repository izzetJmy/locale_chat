import 'package:flutter/material.dart';

class MyGridImages extends StatelessWidget {
  final List<String>? images;

  const MyGridImages({
    super.key,
    required this.images,
  });
  void onImageTap(String imageUrl, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: Image.network(imageUrl).image,
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.0,
        mainAxisSpacing: 10.0,
        crossAxisSpacing: 8.0,
      ),
      scrollDirection: Axis.vertical,
      itemCount: images?.length ?? 0,
      itemBuilder: (context, index) {
        final imageUrl = images?[index];
        return GestureDetector(
          onTap: () => onImageTap(imageUrl ?? '', context),
          child: Image.network(imageUrl ?? '', fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const Center(child: CircularProgressIndicator());
          }),
        );
      },
    );
  }
}
