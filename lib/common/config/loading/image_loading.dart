import 'package:flutter/material.dart';
import 'package:flux_ui/flux_ui.dart';

import '../models/loading_config.dart';

class ImageLoading extends StatelessWidget {
  final LoadingConfig loadingConfig;
  const ImageLoading(this.loadingConfig);

  @override
  Widget build(BuildContext context) {
    if (loadingConfig.path?.isEmpty ?? true) return const SizedBox();
    return FluxImage(imageUrl: loadingConfig.path!);
  }
}
