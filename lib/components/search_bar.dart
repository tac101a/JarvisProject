import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget searchBar(
    {TextEditingController? controller,
    String hintText = 'Search',
    Function(String)? onSubmitted,
    Function(String)? onChanged}) {
  return Container(
    width: double.infinity,
    decoration: BoxDecoration(
      color: Colors.grey[200],
      borderRadius: BorderRadius.circular(25),
      border: Border.all(color: Colors.purple.shade200, width: 1),
    ),
    child: Row(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 0),
          child: Icon(
            Icons.search, // search icon
            color: Colors.grey,
          ),
        ),
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
              hintText: hintText,
              border: InputBorder.none, // remove text field border
              hintStyle: const TextStyle(color: Colors.grey),
            ),
            onSubmitted: (value) {
              onSubmitted?.call(value);
            },
            onChanged: (value) {
              onChanged?.call(value);
            },
          ),
        ),
      ],
    ),
  );
}
