// ignore_for_file: deprecated_member_use

import 'dart:ui';

import 'package:edge_swipe/edge_swipe.dart';
import 'package:flutter/material.dart';

void main() => runApp(
      MaterialApp(
        home: HomePage(),
        theme: ThemeData.light(),
        scrollBehavior: const MaterialScrollBehavior().copyWith(
          dragDevices: {
            PointerDeviceKind.touch,
            PointerDeviceKind.mouse,
            PointerDeviceKind.trackpad,
          },
        ),
      ),
    );

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edge Swipe Example'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Scaffold(
                      body: EdgeSwipe(
                        curvedLineColor:
                            Theme.of(context).brightness == Brightness.dark
                                ? Theme.of(context).colorScheme.surface
                                : Colors.white,
                        curvedLineShadowColor: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(.2),
                        onSwipeLeft: () {
                          Navigator.pop(context);
                        },
                        child: const Center(
                          child: Text(
                            'Swipe left to go back',
                            style: TextStyle(
                              fontSize: 24,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
              child: const Text(
                'Go to Example',
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
