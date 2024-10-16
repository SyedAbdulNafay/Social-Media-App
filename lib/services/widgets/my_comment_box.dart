import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Get.theme.colorScheme.secondary,
          borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user,
                  style: const TextStyle(fontSize: 12),
                ),
                Text(
                  text,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          Text(
            "${dateTime.day}/${dateTime.month}/${dateTime.year}",
            style: const TextStyle(fontSize: 12),
          )
        ],
      ),
    );
  }
}
