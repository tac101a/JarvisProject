import 'package:flutter/material.dart';

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
          padding: EdgeInsets.only(left: 12),
          child: Icon(
            Icons.search, // search icon
            color: Colors.grey,
          ),
        ),
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.all(10),
              hintText: hintText,
              border: InputBorder.none,
              // remove text field border
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
