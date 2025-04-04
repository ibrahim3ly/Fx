import 'package:flutter/material.dart';
import 'package:flux_ui/flux_ui.dart';
import 'package:inspireui/extensions/color_extension.dart';

import '../../models/entities/blog.dart';
import 'detailed_blog_mixin.dart';

class HalfImageType extends StatelessWidget with DetailedBlogMixin {
  final Blog item;

  const HalfImageType({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final blogData = item;
    final size = MediaQuery.sizeOf(context);
    return Stack(
      children: <Widget>[
        SizedBox(
          height: size.height * 0.6,
          width: size.width,
          child: FluxImage(
            imageUrl: blogData.imageFeature,
            fit: BoxFit.cover,
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            leading: GestureDetector(
              onTap: Navigator.of(context).pop,
              child: Container(
                margin: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .surface
                      .withValueOpacity(0.3),
                  borderRadius: BorderRadius.circular(30.0),
                ),
                padding: const EdgeInsets.only(left: 5),
                child: Icon(
                  Icons.arrow_back_ios,
                  size: 18.0,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
            actions: [
              renderBlogFunctionButtons(blogData, context),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                top: size.height * 0.35,
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                constraints: const BoxConstraints(minHeight: 400),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(35.0),
                    topRight: Radius.circular(35.0),
                  ),
                ),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 15.0,
                        top: 30.0,
                      ),
                      child: Text(
                        blogData.title,
                        softWrap: true,
                        style: TextStyle(
                          fontSize: 25,
                          color: Theme.of(context).colorScheme.secondary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    renderAuthorInfo(blogData, context),
                    const SizedBox(height: 10),
                    renderAudioWidget(blogData, context),
                    renderBlogContentWithTextEnhancement(blogData),
                    renderRelatedBlog(blogData.categoryId),
                    renderCommentLayout(blogData.id),
                    renderCommentInput(blogData.id),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
