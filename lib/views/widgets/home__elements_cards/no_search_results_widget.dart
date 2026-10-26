import 'package:flutter/material.dart';

class NoSearchResultsWidget extends StatelessWidget {
  const NoSearchResultsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off, size: 48, color: Colors.amber),
          SizedBox(height: 12),
          Text(
            'لا توجد ملاحظات تطابق بحثك!',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
