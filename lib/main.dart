import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CalculatorPage(),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String expression = ""; // history (เก็บ log ล่าสุด)
  String input = "";      // สมการที่พิมพ์ตอนนี้
  String result = "0";    // ผลลัพธ์หลังจากคำนวณ

  void onButtonPressed(String value) {
    setState(() {
      if (value == "=") {
        calculate();
      } else {
        input += value;
      }
    });
  }

  void onClear() {
    setState(() {
      expression = "";
      input = "";
      result = "0";
    });
  }

  void onDelete() {
    setState(() {
      if (input.isNotEmpty) {
        input = input.substring(0, input.length - 1);
      }
    });
  }

  void calculate() {
    try {
      String exp = input;
      exp = exp.replaceAll("x", "*");
      exp = exp.replaceAll("%", "/100");

      Parser p = Parser();
      Expression expParsed = p.parse(exp);
      ContextModel cm = ContextModel();
      double eval = expParsed.evaluate(EvaluationType.REAL, cm);

      // ถ้าเป็นจำนวนเต็ม → ไม่ต้องโชว์ .0
      String evalStr =
          eval == eval.toInt() ? eval.toInt().toString() : eval.toString();

      setState(() {
        expression = input; // ย้าย input ไป history
        result = evalStr;   // แสดงผลลัพธ์
        input = "";         // ล้าง input
      });
    } catch (e) {
      setState(() {
        result = "Error";
        input = "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              // ===== หน้าจอหลัก (history + result) =====
              Expanded(
                child: Container(
                  alignment: Alignment.bottomRight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // history
                      Text(
                        expression,
                        style: const TextStyle(
                          fontSize: 38,
                          color: Colors.grey,
                        ),
                      ),
                      // input / result
                      Text(
                        input.isNotEmpty ? input : result,
                        style: const TextStyle(
                          fontSize: 78,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ===== ปุ่มกด =====
              Row(
                children: [
                  CalculatorButton("AC", color: Colors.grey, onPressed: onClear),
                  CalculatorButton("%", color: Colors.grey, onPressed: () => onButtonPressed("%")),
                  CalculatorButton("DEL", color: Colors.grey, onPressed: onDelete),
                  CalculatorButton("/", color: Colors.orange, onPressed: () => onButtonPressed("/")),
                ],
              ),
              Row(
                children: [
                  CalculatorButton("7", onPressed: () => onButtonPressed("7")),
                  CalculatorButton("8", onPressed: () => onButtonPressed("8")),
                  CalculatorButton("9", onPressed: () => onButtonPressed("9")),
                  CalculatorButton("x", color: Colors.orange, onPressed: () => onButtonPressed("x")),
                ],
              ),
              Row(
                children: [
                  CalculatorButton("4", onPressed: () => onButtonPressed("4")),
                  CalculatorButton("5", onPressed: () => onButtonPressed("5")),
                  CalculatorButton("6", onPressed: () => onButtonPressed("6")),
                  CalculatorButton("-", color: Colors.orange, onPressed: () => onButtonPressed("-")),
                ],
              ),
              Row(
                children: [
                  CalculatorButton("1", onPressed: () => onButtonPressed("1")),
                  CalculatorButton("2", onPressed: () => onButtonPressed("2")),
                  CalculatorButton("3", onPressed: () => onButtonPressed("3")),
                  CalculatorButton("+", color: Colors.orange, onPressed: () => onButtonPressed("+")),
                ],
              ),
              Row(
                children: [
                  CalculatorButton("00", onPressed: () => onButtonPressed("00")),
                  CalculatorButton("0", onPressed: () => onButtonPressed("0")),
                  CalculatorButton(".", onPressed: () => onButtonPressed(".")),
                  CalculatorButton("=", color: Colors.orange, onPressed: () => onButtonPressed("=")),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget ปุ่มกด
class CalculatorButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color;

  const CalculatorButton(
    this.text, {
    super.key,
    required this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color ?? Colors.black87,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 22),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: onPressed,
          child: Text(
            text,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
