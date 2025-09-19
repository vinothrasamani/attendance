import 'package:attendance/main.dart';
import 'package:attendance/view_model/home_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slide_to_act/slide_to_act.dart';

class Status extends ConsumerWidget {
  const Status({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Container(
        constraints: BoxConstraints(minHeight: size.height - 200),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                constraints: BoxConstraints(maxHeight: 300, maxWidth: 300),
                child: Image.asset('assets/vector.png'),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.withAlpha(50),
                  border: Border.all(
                    color: Colors.grey.withAlpha(100),
                  ),
                ),
                child: Text(
                  'Swipe the button below to mark your attendance.',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: SlideAction(
                  innerColor: Colors.green,
                  outerColor: baseColor,
                  textStyle: TextStyle(fontSize: 20, color: Colors.white),
                  text: 'Slide to Mark',
                  onSubmit: () => HomeService.addStatus(ref),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
