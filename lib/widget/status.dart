import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'dart:math';
import 'package:attendance/view_model/home_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Status extends ConsumerWidget {
  const Status({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size size = MediaQuery.of(context).size;
    final clr1 = Colors.green;
    final clr2 = Colors.red[800]!;

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
                child: DefaultTextStyle.merge(
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold),
                  child: IconTheme.merge(
                    data: const IconThemeData(color: Colors.white),
                    child: SizedBox(
                      width: double.infinity,
                      child: AnimatedToggleSwitch<bool>.dual(
                        current: ref.watch(HomeService.current),
                        first: false,
                        second: true,
                        spacing: 45.0,
                        animationDuration: const Duration(milliseconds: 600),
                        style: const ToggleStyle(
                          borderColor: Colors.transparent,
                          indicatorColor: Colors.white,
                          backgroundColor: Colors.black,
                        ),
                        customStyleBuilder: (context, local, global) {
                          if (global.position <= 0.0) {
                            return ToggleStyle(backgroundColor: clr2);
                          }
                          return ToggleStyle(
                              backgroundGradient: LinearGradient(
                            colors: [clr1, clr2],
                            stops: [
                              global.position -
                                  (1 - 2 * max(0, global.position - 0.5)) * 0.7,
                              global.position +
                                  max(0, 2 * (global.position - 0.5)) * 0.7,
                            ],
                          ));
                        },
                        borderWidth: 6.0,
                        height: 68.0,
                        padding: EdgeInsets.all(10),
                        loadingIconBuilder: (context, global) =>
                            CupertinoActivityIndicator(
                                color: Color.lerp(clr2, clr1, global.position)),
                        onChanged: (b) async =>
                            await HomeService.addStatus(ref, b),
                        iconBuilder: (value) => value
                            ? Icon(Icons.arrow_back, color: clr1, size: 32.0)
                            : Icon(Icons.arrow_forward,
                                color: clr2, size: 32.0),
                        textBuilder: (value) => value
                            ? const Center(child: Text('Swipe to Check-Out'))
                            : const Center(child: Text('Swipe to Check-In')),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
