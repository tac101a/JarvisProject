import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text("Search"),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white),
                child: const Padding(
                  padding: EdgeInsets.all(16),
                  child: TextField(
                    maxLines: 3,
                  ),
                )),
            const SizedBox(height: 24),
            const Text(
              "Discover",
              style: TextStyle(color: Colors.black12),
            ),
            Expanded(
                child: ListView.builder(
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Image.asset(
                          "assets/Icon-192.png",
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                        title: const Text("Flutter"),
                        subtitle: const Text(
                            "A crossplatform SDK published by Google."),
                      );
                    }))
          ],
        ),
      ),
    );
  }
}
