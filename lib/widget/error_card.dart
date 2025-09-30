import 'package:flutter/material.dart';

class ErrorCard extends StatelessWidget {
  const ErrorCard({super.key, required this.icon, required this.err});

  final IconData icon;
  final String err;

  @override
  Widget build(BuildContext context) {
    final c = Colors.red[800]!;

    return Center(
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: c.withAlpha(80)),
          color: c.withAlpha(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: c, size: 40),
            SizedBox(height: 10),
            Text(err, style: TextStyle(color: c)),
          ],
        ),
      ),
    );
  }
}
