import 'package:flutter/material.dart';

class DateField extends StatelessWidget {
  const DateField({super.key, required this.value, required this.onTap});
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              value,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(width: 10),
            Icon(Icons.calendar_month),
          ],
        ),
      ),
    );
  }
}
