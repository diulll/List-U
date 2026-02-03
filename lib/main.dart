import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HelioLoginPage(),
    );
  }
}

class HelioLoginPage extends StatefulWidget {
  const HelioLoginPage({super.key});

  @override
  State<HelioLoginPage> createState() => _HelioLoginPageState();
}

class _HelioLoginPageState extends State<HelioLoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 60),
              
              // 1. Logo "Helio"
              Text(
                'Helio',
                textAlign: TextAlign.center,
                style: GoogleFonts.pacifico( // Menggunakan font gaya tulisan tangan
                  fontSize: 40,
                  color: const Color(0xFF2D3B48),
                ),
              ),
              const SizedBox(height: 50),

              // 2. Tombol Login Google
              OutlinedButton.icon(
                onPressed: () {},
                icon: const FaIcon(FontAwesomeIcons.google, color: Colors.red),
                label: const Text(
                  "Log in with Gmail",
                  style: TextStyle(color: Colors.black54),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  side: const BorderSide(color: Colors.grey),
                ),
              ),
              const SizedBox(height: 15),

              // 3. Tombol Login Facebook
              ElevatedButton.icon(
                onPressed: () {},
                icon: const FaIcon(FontAwesomeIcons.facebookF, color: Colors.white),
                label: const Text(
                  "Log in with Facebook",
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3B5998), // Warna biru FB
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              
              const SizedBox(height: 30),
              
              // 4. Divider "OR"
              const Row(
                children: [
                  Expanded(child: Divider(thickness: 1)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text("OR", style: TextStyle(color: Colors.grey)),
                  ),
                  Expanded(child: Divider(thickness: 1)),
                ],
              ),
              const SizedBox(height: 30),

              // 5. Input Email
              const TextField(
                decoration: InputDecoration(
                  labelText: "Email or username",
                  border: UnderlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              // 6. Input Password & Forgot
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: const UnderlineInputBorder(),
                  suffix: TextButton(
                    onPressed: () {},
                    child: const Text("Forgot?", style: TextStyle(fontSize: 12)),
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // 7. Tombol Sign In dengan Gradasi
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF43E97B), Color(0xFF38F9D7)], // Hijau ke Cyan
                  ),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () {
                    // Aksi login nanti disini
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent, // Transparan agar gradasi terlihat
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    "Sign in >",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
              
              const SizedBox(height: 30),

              // 8. Footer Sign Up
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? "),
                  GestureDetector(
                    onTap: () {},
                    child: const Text(
                      "Sign up",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}