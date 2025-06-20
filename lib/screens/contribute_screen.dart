import 'package:flutter/material.dart';

class ContributeScreen extends StatelessWidget {
  const ContributeScreen({super.key});

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'If you liked my work, feel free to contribute',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Image.asset('assets/images/contribute.webp'),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (ctx) {
                          return Center(
                              child: Container(
                            height: 600,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: const Color(0xFFF3F6FD),
                            ),
                            padding: const EdgeInsets.all(20),
                            margin: const EdgeInsets.all(25),
                            child: Center(
                              child: Image.asset('assets/images/Qr_code.jpg'),
                            ),    
                          ));
                        });
                  },
                  child: const Text("Contribute"))
            ]),
      ),
    );
  }
}
