import 'package:flutter/material.dart';

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String inputString = "";

  Widget buildButton(String text,
      {Color color = Colors.grey, Function()? onPressed}) {
    return SizedBox(
      width: 70,
      height: 70,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 8,
          shadowColor: Colors.black54,
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F3FF),
      appBar: AppBar(
        title: const Center(child: Text("Calculator")),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Text(
            inputString,
            style: const TextStyle(fontSize: 36, color: Colors.black),
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildButton("1", onPressed: () {
                setState(() {
                  inputString += "1";
                });
              }),
              buildButton("2", onPressed: () {
                setState(() {
                  inputString += "2";
                });
              }),
              buildButton("3", onPressed: () {
                setState(() {
                  inputString += "3";
                });
              }),
              buildButton("AC", color: Colors.red, onPressed: () {
                setState(() {
                  inputString = "";
                });
              }),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildButton("4", onPressed: () {
                setState(() {
                  inputString += "4";
                });
              }),
              buildButton("5", onPressed: () {
                setState(() {
                  inputString += "5";
                });
              }),
              buildButton("6", onPressed: () {
                setState(() {
                  inputString += "6";
                });
              }),
              buildButton("+", color: Colors.blue, onPressed: () {
                setState(() {
                  inputString += "+";
                });
              }),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildButton("7", onPressed: () {
                setState(() {
                  inputString += "7";
                });
              }),
              buildButton("8", onPressed: () {
                setState(() {
                  inputString += "8";
                });
              }),
              buildButton("9", onPressed: () {
                setState(() {
                  inputString += "9";
                });
              }),
              buildButton("=", color: Colors.green, onPressed: () {
                setState(() {
                  List<String> numbers = inputString.split("+");
                  int sum = numbers.map(int.parse).reduce((a, b) => a + b);
                  inputString = sum.toString();
                });
              }),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildButton("0", onPressed: () {
                setState(() {
                  inputString += "0";
                });
              }),
            ],
          ),
        ],
      ),
    );
  }
}
