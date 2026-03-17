import '../../data/models/zikir_category.dart';
import 'package:flutter/material.dart';

class AzkarScreen extends StatelessWidget {
  final ZikirCategory zikirCategory;
  const AzkarScreen({super.key, required this.zikirCategory});

  @override
  Widget build(BuildContext context) {
    bool isFavorite = false;

    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.teal,
        title: Text(zikirCategory.category),
      ),
      body: ListView.builder(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        itemCount: zikirCategory.content.length,
        itemBuilder: (context, index) {
          final details = zikirCategory.content[index];
          return Card(
            elevation: 4,
            margin: EdgeInsets.only(bottom: 12),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ListTile(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  title: Text(
                    textAlign: TextAlign.end,
                    details.text,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: details.description == ""
                      ? SizedBox()
                      : Text(
                          details.description,
                          textAlign: TextAlign.end,
                          style: TextStyle(fontSize: 16),
                        ),
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 8, left: 16, right: 16),
                  child: InkWell(
                    onTap: () {
                      isFavorite != isFavorite;
                    },
                    child: isFavorite == false
                        ? Icon(Icons.favorite_border_outlined)
                        : Icon(Icons.favorite, color: Colors.red),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
