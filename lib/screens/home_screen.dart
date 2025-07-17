import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('YOweMe')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Summary',
              style: TextStyle(fontSize: 24, color: Color(0xFF1A3C34)),
            ),
            const SizedBox(height: 10),
            Card(
              color: Colors.white,
              child: ListTile(
                title: const Text(
                  'Overall',
                  style: TextStyle(color: Color(0xFF1A3C34)),
                ),
                trailing: const Text(
                  '\$0.00',
                  style: TextStyle(color: Color(0xFFDC3545)),
                ),
              ),
            ),
            Card(
              color: Colors.white,
              child: ListTile(
                title: const Text(
                  'I owe',
                  style: TextStyle(color: Color(0xFF1A3C34)),
                ),
                trailing: const Text(
                  '\$126.00',
                  style: TextStyle(color: Color(0xFFDC3545)),
                ),
              ),
            ),
            Card(
              color: Colors.white,
              child: ListTile(
                title: const Text(
                  'Owes me',
                  style: TextStyle(color: Color(0xFF1A3C34)),
                ),
                trailing: const Text(
                  '\$260.00',
                  style: TextStyle(color: Color(0xFF28A745)),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF007BFF),
              ),
              child: const Text('Add Expense'),
            ),
          ],
        ),
      ),
    );
  }
}
