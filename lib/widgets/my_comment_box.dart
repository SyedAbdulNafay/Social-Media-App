import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyCommentBox extends StatelessWidget {
  final String text;
  final String user;
  final Timestamp timestamp;
  const MyCommentBox(
      {super.key,
      required this.text,
      required this.user,
      required this.timestamp});

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = timestamp.toDate();
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 12),
              ),
              Text(
                text,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    fontSize: 16),
              ),
            ],
          ),
          Text(
            "${dateTime.day}/${dateTime.month}/${dateTime.year}",
            style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontSize: 12),
          )
        ],
      ),
    );
  }
}
