import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../placeholders..dart';

class BannerShimmer extends StatelessWidget {
  const BannerShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        enabled: true,
        child: const SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              Divider(
                color: Colors.black,
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: ContentPlaceholder(
                  lineType: ContentLineType.twoLines,
                ),
              ),
            ],
          ),
        ));
  }
}
