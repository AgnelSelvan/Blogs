import 'package:flutter/material.dart';
import 'package:upi_payment_qrcode_generator/upi_payment_qrcode_generator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'UPI payment QRCode'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final upiDetails = UPIDetails(
    upiID: "Sender UPI ID",
    payeeName: "Sender Name",
    transactionID: "Your Unique ID",
    transactionNote: "Payment for GYM",
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'UPI ID: ${upiDetails.upiID}\n Payee Name: ${upiDetails.payeeName}\n Amount ${upiDetails.amount}',
            ),
            const SizedBox(
              height: 10,
            ),
            UPIPaymentQRCode(
              upiDetails: upiDetails,
              size: 200,
            ),
          ],
        ),
      ),
    );
  }
}
