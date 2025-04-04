import 'package:flutter/material.dart';
import 'package:flux_localization/flux_localization.dart';
import 'package:provider/provider.dart';

import '../../../../../models/user_model.dart';
import '../../../../../services/services.dart';
import '../../../common/config.dart';
import '../../../common/tools/navigate_tools.dart';

class CommentInput extends StatefulWidget {
  final dynamic blogId;

  const CommentInput({required this.blogId});

  @override
  State<CommentInput> createState() => _CommentInputState();
}

class _CommentInputState extends State<CommentInput> {
  final comment = TextEditingController();
  final Services _service = Services();
  bool isLoading = false;

  void hideLoading() {
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void showLoading() {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
  }

  void sendComment() async {
    final userModel = Provider.of<UserModel>(context, listen: false);

    try {
      showLoading();
      var commentCreated = await _service.api.createComment(
        blogId: widget.blogId,
        content: comment.text,
        cookie: userModel.user!.cookie,
      );
      if (mounted) {
        setState(() {
          comment.text = '';
        });
      }
      if (commentCreated) {
        final snackBar =
            SnackBar(content: Text(S.of(context).commentSuccessfully));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        const snackBar = SnackBar(content: Text('Comment fail'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
    hideLoading();
    FocusManager.instance.primaryFocus?.unfocus();
  }

  Widget _buildCommentSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Expanded(
          child: TextField(
            controller: comment,
            maxLines: 2,
            decoration: InputDecoration(hintText: S.of(context).writeComment),
          ),
        ),
        GestureDetector(
          onTap: () =>
              comment.text.isNotEmpty && !isLoading ? sendComment() : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: isLoading
                ? CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.secondary)
                : Icon(
                    Icons.send,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildRequiredLoginButton() {
    if (!kLoginSetting.enable) {
      return const SizedBox();
    }
    return Container(
      constraints: const BoxConstraints(
        minHeight: 32,
        maxHeight: 64,
        // maxWidth: 300,
      ),
      height: 50.0,
      child: RawMaterialButton(
        onPressed: () => NavigateTools.navigateToLogin(context),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        elevation: 0,
        fillColor: Theme.of(context).primaryColorLight,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              S.of(context).loginToComment,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_service.api.useCrossBlog) {
      return const SizedBox(height: 30);
    }

    return ListenableProvider.value(
      value: Provider.of<UserModel>(context),
      child: Consumer<UserModel>(
        builder: (context, model, child) {
          return Container(
            margin: const EdgeInsets.only(bottom: 40, top: 15.0),
            padding: const EdgeInsets.only(bottom: 15.0, top: 5.0),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(3.0),
            ),
            child: model.user != null
                ? _buildCommentSection()
                : _buildRequiredLoginButton(),
          );
        },
      ),
    );
  }
}
