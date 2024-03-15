import 'package:flutter/material.dart';

import 'alert_messenger.dart';

void main() => runApp(const AlertPriorityApp());

class AlertPriorityApp extends StatefulWidget {
  const AlertPriorityApp({super.key});

  @override
  State<AlertPriorityApp> createState() => _AlertPriorityAppState();
}

class _AlertPriorityAppState extends State<AlertPriorityApp>
    with TickerProviderStateMixin {
  static AnimationController createAnimationController(
      {required TickerProvider vsync}) {
    return AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: vsync,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Priority',
      theme: ThemeData(
        useMaterial3: false,
        primarySwatch: Colors.blue,
        iconTheme: const IconThemeData(size: 16.0, color: Colors.white),
        elevatedButtonTheme: const ElevatedButtonThemeData(
          style: ButtonStyle(
            minimumSize: MaterialStatePropertyAll(Size(110, 40)),
          ),
        ),
      ),
      home: AlertMessenger(
        child: Builder(
          builder: (context) {
            return Scaffold(
              backgroundColor: Colors.grey[200],
              appBar: AppBar(
                title: const Text('Alerts'),
                centerTitle: true,
              ),
              body: SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Center(
                        child: Text(
                          AlertMessenger.of(context).message ?? '',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    AlertMessenger.of(context).showAlert(
                                      alert: Alert(
                                        backgroundColor: Colors.red,
                                        leading: const Icon(Icons.error),
                                        priority: AlertPriority.error,
                                        animationController:
                                        createAnimationController(
                                          vsync: this,
                                        ),
                                        child: const Text(
                                            'Oops, ocorreu um erro. Pedimos desculpas.'),
                                      ),
                                    );
                                    setState(() {});
                                  },
                                  style: const ButtonStyle(
                                    backgroundColor:
                                    MaterialStatePropertyAll(Colors.red),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Icon(Icons.error),
                                      SizedBox(width: 4.0),
                                      Text('Error'),
                                    ],
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    AlertMessenger.of(context).showAlert(
                                      alert: Alert(
                                        backgroundColor: Colors.amber,
                                        leading: const Icon(Icons.warning),
                                        priority: AlertPriority.warning,
                                        animationController:
                                        createAnimationController(
                                          vsync: this,
                                        ),
                                        child: const Text(
                                            'Atenção! Você foi avisado.'),
                                      ),
                                    );
                                    setState(() {});
                                  },
                                  style: const ButtonStyle(
                                    backgroundColor:
                                    MaterialStatePropertyAll(Colors.amber),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Icon(Icons.warning_outlined),
                                      SizedBox(width: 4.0),
                                      Text('Warning'),
                                    ],
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    AlertMessenger.of(context).showAlert(
                                      alert: Alert(
                                        backgroundColor: Colors.green,
                                        leading: const Icon(Icons.info),
                                        priority: AlertPriority.info,
                                        animationController:
                                        createAnimationController(
                                          vsync: this,
                                        ),
                                        child: const Text(
                                            'Este é um aplicativo escrito em Flutter.'),
                                      ),
                                    );
                                    setState(() {});
                                  },
                                  style: const ButtonStyle(
                                    backgroundColor: MaterialStatePropertyAll(
                                        Colors.lightGreen),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Icon(Icons.info_outline),
                                      SizedBox(width: 4.0),
                                      Text('Info'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24.0,
                                vertical: 16.0,
                              ),
                              child: ElevatedButton(
                                onPressed: () async {
                                  await AlertMessenger.of(context).hideAlert();
                                  setState(() {});
                                },
                                child: const Text('Hide alert'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
