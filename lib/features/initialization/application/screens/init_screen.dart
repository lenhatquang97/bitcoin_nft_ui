import 'package:flutter/material.dart';

class InitializationScreen extends StatefulWidget {
  const InitializationScreen({super.key});

  @override
  State<InitializationScreen> createState() => _InitializationScreenState();
}

class _InitializationScreenState extends State<InitializationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Align(
            alignment: Alignment.center,
            child: Text(
              "Demo Bitcoin NFT UI",
              style: TextStyle(fontSize: 24),
            ),
          ),
          const SizedBox(height: 16.0),
          Row(
            children: [
              const Text("RPC Port"),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: TextFormField(
                    maxLines: 1,
                    obscureText: false,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Port',
                    )),
              )),
            ],
          ),
          const SizedBox(height: 8.0,),
          Row(
            children: [
              const Text("RPC User"),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: TextFormField(
                    maxLines: 1,
                    obscureText: false,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'User',
                    )),
              )),
            ],
          ),
          const SizedBox(height: 8.0),
          Row(
            children: [
              const Text("RPC Password"),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: TextFormField(
                    maxLines: 1,
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                    )),
              ))
            ],
          ),
          const SizedBox(height: 8.0),
          Align(
            alignment: Alignment.center,
            child:
                TextButton(onPressed: () => {}, child: const Text("Connect")),
          ),
          const SizedBox(height: 16.0),
          Expanded(
              child: TextFormField(
                  maxLines: 5,
                  obscureText: false,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Status',
                  )))
        ]),
      ),
    );
  }
}
