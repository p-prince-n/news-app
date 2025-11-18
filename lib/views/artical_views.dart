import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ArticalViews extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDark;
  final String articalUrl;
  const ArticalViews({
    super.key,
    required this.articalUrl,
    required this.toggleTheme,
    required this.isDark,
  });

  @override
  State<ArticalViews> createState() => _ArticalViewsState();
}

class _ArticalViewsState extends State<ArticalViews> {
  late final WebViewController controller;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onPageStarted: (url) {
                setState(() => isLoading = true);
              },
              onPageFinished: (url) {
                setState(() => isLoading = false);
              },
              onWebResourceError: (error) {
                setState(() => isLoading = false);
              },
            ),
          )
          ..loadRequest(Uri.parse(widget.articalUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar(
          title: Text('NEWS APP'),
          centerTitle: true,
          elevation: 1,
          actions: [
            IconButton(
              onPressed: () => widget.toggleTheme(),
              icon: Icon(
                widget.isDark ? Icons.light_mode : Icons.dark_mode,
                color: widget.isDark ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        child:
            isLoading
                ? Center(child: CircularProgressIndicator())
                : WebViewWidget(controller: controller),
      ),
    );
  }
}
