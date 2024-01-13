import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.5),
      body: const Center(
        child: SpinKitFadingCircle(
          color: Colors.white,
          size: 60.0,
        ),
      ),
      // body: const Center(
      //   child: CircularProgressIndicator(
      //     color: Colors.white,
      //   ),
      // ),
    );
  }
}
