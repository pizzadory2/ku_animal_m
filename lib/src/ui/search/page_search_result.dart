import 'package:flutter/material.dart';

class PageSearchResult extends StatefulWidget {
  const PageSearchResult({super.key, required this.searchText});

  final String searchText;

  @override
  State<PageSearchResult> createState() => _PageSearchResultState();
}

class _PageSearchResultState extends State<PageSearchResult> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.searchText),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text("title $index"),
                    subtitle: Text("subtitle $index"),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
