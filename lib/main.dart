import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const CoinFlipApp());
}

class CoinFlipApp extends StatelessWidget {
  const CoinFlipApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coin Flip Simulator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const CoinFlipPage(),
    );
  }
}

class CoinFlipPage extends StatefulWidget {
  const CoinFlipPage({super.key});

  @override
  _CoinFlipPageState createState() => _CoinFlipPageState();
}

class _CoinFlipPageState extends State<CoinFlipPage> 
    with SingleTickerProviderStateMixin {
  // Coin result
  String _result = '';
  
  // Animation controller
  late AnimationController _controller;
  
  // Rotation animation
  late Animation<double> _rotationAnimation;
  
  // Flipping state
  bool _isFlipping = false;

  @override
  void initState() {
    super.initState();
    
    // Initialize animation controller
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // Create rotation animation
    _rotationAnimation = Tween<double>(
      begin: 0,
      end: pi, // Half rotation
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    // Add listener to reset state after animation
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _isFlipping = false;
        });
      }
    });
  }

  // Coin flip logic
  void _flipCoin() {
    if (!_isFlipping) {
      setState(() {
        _isFlipping = true;
        _result = Random().nextBool() ? 'Heads' : 'Tails';
      });

      // Start the animation
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coin Flip Simulator'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated Coin
            AnimatedBuilder(
              animation: _rotationAnimation,
              builder: (context, child) {
                return Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(_rotationAnimation.value),
                  child: GestureDetector(
                    onTap: _flipCoin,
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.amber,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          _isFlipping ? '' : _result,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            // Flip Button
            ElevatedButton(
              onPressed: _flipCoin,
              child: const Text('Flip Coin'),
            ),
            const SizedBox(height: 20),
            // Result Display
            Text(
              _result.isNotEmpty && !_isFlipping 
                  ? 'Result: $_result' 
                  : '',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}