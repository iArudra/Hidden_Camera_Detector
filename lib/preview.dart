
import 'package:flutter/material.dart';
import 'package:hidden_camera/Login.dart';

class Preview extends StatefulWidget {
  const Preview({super.key});

  @override
  State<Preview> createState() => _PreviewState();
}

class _PreviewState extends State<Preview> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 6), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const login()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.black , centerTitle: true,
        title: const Text(
          "Disclaimer",
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 35),
        ),
      ),
      body: const Center(
        child: Text(
          "This app is designed to detect hidden cameras using the best resources available, but it is not 100% accurate. "
              "Certain shiny objects, such as metal surfaces or reflective items, may cause false positives. "
              "Please use this tool as a supplemental aid, and for complete security, "
              "consider combining it with other detection methods. Thank you for your understanding!",
          style: TextStyle(color: Colors.white, fontSize: 28),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
