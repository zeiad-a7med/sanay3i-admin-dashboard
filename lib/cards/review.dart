import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:maintenanceservices/main.dart';
import '../Part2/Home.dart';

class Review extends StatelessWidget {
  dynamic review;

  Review(this.review);
  @override

  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.reviews),
            title: const Text('Review'),
            subtitle: Text(
              '${review}',
              style: TextStyle(color: Colors.black.withOpacity(0.6)),
            ),
          ),


        ],
      ),
    );
  }

}

