import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyBKJijgQv4ek0TDCRdxRnJbxfQIhLYqvyk",
        authDomain: "latihan-pertama-c6f4e.firebaseapp.com",
        projectId: "latihan-pertama-c6f4e",
        storageBucket: "latihan-pertama-c6f4e.firebasestorage.app",
        messagingSenderId: "1052082250635",
        appId: "1:1052082250635:web:e05ddf1fb62e764c8f7c05",
      ),
    );
  } catch (e) {
    debugPrint('Firebase initialization error: $e');
  }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
      ),
      home: const HelioLoginPage(),
    );
  }
}

// Halaman Login Ini

class HelioLoginPage extends StatefulWidget {
  const HelioLoginPage({super.key});

  @override
  State<HelioLoginPage> createState() => _HelioLoginPageState();
}

class _HelioLoginPageState extends State<HelioLoginPage> {
  bool _isLoading = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Fungsi Login dengan Email/Password
  Future<void> _signInWithEmailPassword() async {
    // Validasi input
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter email and password')),
      );
      return;
    }

    setState(() => _isLoading = true);
    
    // Simulasi delay network
    await Future.delayed(const Duration(seconds: 1));
    

    // Mock login - langsung berhasil
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login successful!')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage(
          userName: _emailController.text.split('@')[0],
          userEmail: _emailController.text,
        )),
      );
    }
    
    setState(() => _isLoading = false);
  }

  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        clientId: '747567749375-sgtoakl5c8idauv3je1tj7r37j7d4kg4.apps.googleusercontent.com',
      );
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        setState(() => _isLoading = false);
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage(
            userName: userCredential.user?.displayName ?? 'User',
            userEmail: userCredential.user?.email ?? '',
          )),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Google Sign-In Error: $e')),
        );
      }
    }
    setState(() => _isLoading = false);
  }

  Future<void> _signInWithFacebook() async {
    setState(() => _isLoading = true);
    try {
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        final AccessToken accessToken = result.accessToken!;
        final OAuthCredential credential =
            FacebookAuthProvider.credential(accessToken.tokenString);

        final UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage(
              userName: userCredential.user?.displayName ?? 'User',
              userEmail: userCredential.user?.email ?? '',
            )),
          );
        }
      } else if (result.status == LoginStatus.cancelled) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Facebook login cancelled')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Facebook Sign-In Error: $e')),
        );
      }
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 35.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 60),

              // Logo "Helio"
              Text(
                'Helio',
                textAlign: TextAlign.center,
                style: GoogleFonts.pacifico(
                  fontSize: 42,
                  color: const Color(0xFF2D3B48),
                ),
              ),
              const SizedBox(height: 50),

              // Input Email
              _buildTextField(
                controller: _emailController,
                label: "Email",
              ),
              const SizedBox(height: 15),

              // Input Password dengan Forgot
              _buildPasswordField(
                controller: _passwordController,
                label: "Password",
                onForgotPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ForgotPasswordPage()),
                  );
                },
              ),
              const SizedBox(height: 35),

              // Tombol Sign In
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _buildGradientButton(
                      onPressed: _signInWithEmailPassword,
                      label: "Sign in  >",
                    ),

              const SizedBox(height: 30),

              // Footer Sign Up
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SignUpPage()),
                      );
                    },
                    child: const Text(
                      "Sign up",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Color(0xFF2D3B48),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

// ==================== SIGN UP PAGE ====================
class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _isLoading = false;
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Fungsi Sign Up dengan Email/Password
  Future<void> _signUpWithEmailPassword() async {
    // Validasi input
    if (_usernameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    if (_passwordController.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password must be at least 6 characters')),
      );
      return;
    }

    setState(() => _isLoading = true);
    
    // Simulasi delay network
    await Future.delayed(const Duration(seconds: 1));
    
    // Mock sign up - langsung berhasil
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account created successfully!')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage(
          userName: _usernameController.text,
          userEmail: _emailController.text,
        )),
      );
    }
    
    setState(() => _isLoading = false);
  }

  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        clientId: '747567749375-sgtoakl5c8idauv3je1tj7r37j7d4kg4.apps.googleusercontent.com',
      );
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        setState(() => _isLoading = false);
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage(
            userName: userCredential.user?.displayName ?? 'User',
            userEmail: userCredential.user?.email ?? '',
          )),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Google Sign-In Error: $e')),
        );
      }
    }
    setState(() => _isLoading = false);
  }

  Future<void> _signUpWithFacebook() async {
    setState(() => _isLoading = true);
    try {
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        final AccessToken accessToken = result.accessToken!;
        final OAuthCredential credential =
            FacebookAuthProvider.credential(accessToken.tokenString);

        final UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage(
              userName: userCredential.user?.displayName ?? 'User',
              userEmail: userCredential.user?.email ?? '',
            )),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Facebook Sign-Up Error: $e')),
        );
      }
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 35.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 60),

              // Logo "Helio"
              Text(
                'Helio',
                textAlign: TextAlign.center,
                style: GoogleFonts.pacifico(
                  fontSize: 42,
                  color: const Color(0xFF2D3B48),
                ),
              ),
              const SizedBox(height: 50),

              // Input Username
              _buildTextField(
                controller: _usernameController,
                label: "Username",
              ),
              const SizedBox(height: 15),

              // Input Email
              _buildTextField(
                controller: _emailController,
                label: "Email",
              ),
              const SizedBox(height: 15),

              // Input Password
              _buildTextField(
                controller: _passwordController,
                label: "Password",
                isPassword: true,
              ),
              const SizedBox(height: 35),

              // Tombol Sign Up
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _buildGradientButton(
                      onPressed: _signUpWithEmailPassword,
                      label: "Sign up  >",
                    ),

              const SizedBox(height: 30),

              // Footer Sign In
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account? ",
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Text(
                      "Sign in",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Color(0xFF2D3B48),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

// ==================== FORGOT PASSWORD PAGE ====================
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 35.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 60),

              // Ilustrasi Gembok
              SizedBox(
                height: 200,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Background circle
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[100],
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                    ),
                    // Lock icon
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Colors.grey[300]!, Colors.grey[400]!],
                        ),
                      ),
                      child: const Icon(
                        Icons.lock_outline,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    // Floating icons
                    Positioned(
                      top: 20,
                      right: 60,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF38F9D7),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.vpn_key,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 30,
                      left: 60,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF6B6B),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.security,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    // Small dots decorations
                    Positioned(
                      top: 40,
                      left: 80,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFE0E0E0),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 50,
                      right: 80,
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFE0E0E0),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 80,
                      left: 50,
                      child: const Icon(
                        Icons.add,
                        size: 14,
                        color: Color(0xFFBDBDBD),
                      ),
                    ),
                    Positioned(
                      top: 30,
                      left: 120,
                      child: const Icon(
                        Icons.circle_outlined,
                        size: 10,
                        color: Color(0xFFBDBDBD),
                      ),
                    ),
                    Positioned(
                      bottom: 60,
                      right: 50,
                      child: const Icon(
                        Icons.add,
                        size: 14,
                        color: Color(0xFFBDBDBD),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Title
              const Text(
                'Forgot Password',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3B48),
                ),
              ),
              const SizedBox(height: 15),

              // Subtitle
              Text(
                'Please enter your email address or phone\nnumber to reset your password',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 40),

              // Input Email
              _buildTextField(
                controller: _emailController,
                label: "Email",
              ),
              const SizedBox(height: 35),

              // Tombol Send
              _buildGradientButton(
                onPressed: () {
                  if (_emailController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter your email')),
                    );
                    return;
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Password reset link sent to your email!')),
                  );
                  Navigator.pop(context);
                },
                label: "Send  >",
              ),

              const SizedBox(height: 25),

              // Cancel link
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[500],
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

// ==================== HOME PAGE (redirect to onboarding) ====================
class HomePage extends StatelessWidget {
  final String? userName;
  final String? userEmail;
  const HomePage({super.key, this.userName, this.userEmail});

  @override
  Widget build(BuildContext context) {
    return OnboardingPage(userName: userName, userEmail: userEmail);
  }
}

// ==================== ONBOARDING PAGE ====================
class OnboardingPage extends StatefulWidget {
  final String? userName;
  final String? userEmail;
  const OnboardingPage({super.key, this.userName, this.userEmail});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _pages = [
    OnboardingData(
      title: "Multiple device",
      description: "Please enter your email address or phone\nnumber to reset your password",
      icon: Icons.devices,
      iconColor: const Color(0xFF38F9D7),
      secondaryIcon: Icons.person,
      secondaryColor: const Color(0xFFFF9F43),
    ),
    OnboardingData(
      title: "Grate Reminder",
      description: "Please enter your email address or phone\nnumber to reset your password",
      icon: Icons.checklist,
      iconColor: const Color(0xFFFFBE76),
      secondaryIcon: Icons.notifications,
      secondaryColor: const Color(0xFFE056FD),
    ),
    OnboardingData(
      title: "Time Saving & Productive",
      description: "Please enter your email address or phone\nnumber to reset your password",
      icon: Icons.show_chart,
      iconColor: const Color(0xFF38F9D7),
      secondaryIcon: Icons.bar_chart,
      secondaryColor: const Color(0xFFFF6B6B),
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Go to Dashboard
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DashboardPage(userName: widget.userName, userEmail: widget.userEmail)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return _buildOnboardingContent(_pages[index]);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Page Indicators
                  Row(
                    children: List.generate(
                      _pages.length,
                      (index) => Container(
                        margin: const EdgeInsets.only(right: 8),
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentPage == index
                              ? const Color(0xFF43E97B)
                              : Colors.grey[300],
                        ),
                      ),
                    ),
                  ),
                  // Next / Get Started Button
                  _currentPage == _pages.length - 1
                      ? _buildGetStartedButton()
                      : GestureDetector(
                          onTap: _nextPage,
                          child: Text(
                            "Next",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[500],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOnboardingContent(OnboardingData data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration
          SizedBox(
            height: 250,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Background circle
                Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[100],
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 30,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                ),
                // Main content box
                Container(
                  width: 120,
                  height: 140,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Icon(
                    data.icon,
                    size: 50,
                    color: Colors.grey[400],
                  ),
                ),
                // Floating icon top right
                Positioned(
                  top: 30,
                  right: 60,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: data.secondaryColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      data.secondaryIcon,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
                // Floating icon bottom left
                Positioned(
                  bottom: 40,
                  left: 60,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: data.iconColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      data.icon == Icons.devices ? Icons.sync : Icons.edit,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
                // Decorative dots
                Positioned(
                  top: 50,
                  left: 80,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFE0E0E0),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 70,
                  right: 70,
                  child: const Icon(
                    Icons.add,
                    size: 16,
                    color: Color(0xFFBDBDBD),
                  ),
                ),
                Positioned(
                  top: 80,
                  left: 50,
                  child: const Icon(
                    Icons.add,
                    size: 14,
                    color: Color(0xFFBDBDBD),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 50),
          // Title
          Text(
            data.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3B48),
            ),
          ),
          const SizedBox(height: 20),
          // Description
          Text(
            data.description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGetStartedButton() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF43E97B), Color(0xFF38F9D7)],
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF43E97B).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _nextPage,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: const Text(
          "Get Started  >",
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

// Onboarding Data Model
class OnboardingData {
  final String title;
  final String description;
  final IconData icon;
  final Color iconColor;
  final IconData secondaryIcon;
  final Color secondaryColor;

  OnboardingData({
    required this.title,
    required this.description,
    required this.icon,
    required this.iconColor,
    required this.secondaryIcon,
    required this.secondaryColor,
  });
}

// ==================== DASHBOARD PAGE ====================
class DashboardPage extends StatefulWidget {
  final String? userName;
  final String? userEmail;
  const DashboardPage({super.key, this.userName, this.userEmail});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Color(0xFF2D3B48)),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Color(0xFF2D3B48)),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              const SizedBox(height: 30),
              // Illustration - Empty State
              SizedBox(
                height: 200,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Background circle
                    Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[100],
                      ),
                    ),
                    // Calendar card
                    Container(
                      width: 100,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.calendar_today, color: Colors.grey[300], size: 30),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              3,
                              (index) => Container(
                                margin: const EdgeInsets.symmetric(horizontal: 2),
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey[300],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Check icon
                    Positioned(
                      top: 20,
                      right: 60,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF43E97B),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Icon(
                          Icons.check,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    // Note icon
                    Positioned(
                      bottom: 20,
                      left: 60,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE056FD),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.description,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    // Decorative elements
                    Positioned(
                      top: 40,
                      left: 80,
                      child: const Icon(Icons.add, size: 14, color: Color(0xFFBDBDBD)),
                    ),
                    Positioned(
                      bottom: 50,
                      right: 70,
                      child: const Icon(Icons.add, size: 14, color: Color(0xFFBDBDBD)),
                    ),
                    Positioned(
                      top: 60,
                      right: 100,
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFE0E0E0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              // Title
              const Text(
                "You haven't planned yet anything",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3B48),
                ),
              ),
              const SizedBox(height: 15),
              // Subtitle
              Text(
                "Please enter your email address or phone\nnumber to reset your password",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      ),
      // Bottom Navigation Bar
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(Icons.home_outlined, 0),
                _buildNavItem(Icons.bar_chart, 1),
                _buildAddButton(),
                _buildNavItem(Icons.calendar_today_outlined, 3),
                _buildNavItem(Icons.settings_outlined, 4),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() => _selectedIndex = index);
      },
      child: Icon(
        icon,
        size: 26,
        color: isSelected ? const Color(0xFF43E97B) : Colors.grey[400],
      ),
    );
  }

  Widget _buildAddButton() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF43E97B), Color(0xFF38F9D7)],
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF43E97B).withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: const Icon(
        Icons.add,
        size: 26,
        color: Colors.white,
      ),
    );
  }
}

// ==================== REUSABLE WIDGETS ====================

Widget _buildGoogleButton({
  required VoidCallback? onPressed,
  required String label,
}) {
  return OutlinedButton.icon(
    onPressed: onPressed,
    icon: Image.network(
      'https://www.google.com/favicon.ico',
      width: 20,
      height: 20,
      errorBuilder: (context, error, stackTrace) =>
          const FaIcon(FontAwesomeIcons.google, color: Colors.red, size: 18),
    ),
    label: Text(
      label,
      style: TextStyle(color: Colors.grey[700], fontSize: 14),
    ),
    style: OutlinedButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      side: BorderSide(color: Colors.grey[300]!),
    ),
  );
}

Widget _buildFacebookButton({
  required VoidCallback? onPressed,
  required String label,
}) {
  return ElevatedButton.icon(
    onPressed: onPressed,
    icon: const FaIcon(FontAwesomeIcons.facebookF, color: Colors.white, size: 18),
    label: Text(
      label,
      style: const TextStyle(color: Colors.white, fontSize: 14),
    ),
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF3B5998),
      padding: const EdgeInsets.symmetric(vertical: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      elevation: 0,
    ),
  );
}

Widget _buildDivider() {
  return Row(
    children: [
      Expanded(child: Divider(thickness: 1, color: Colors.grey[300])),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Text(
          "OR",
          style: TextStyle(color: Colors.grey[400], fontSize: 12),
        ),
      ),
      Expanded(child: Divider(thickness: 1, color: Colors.grey[300])),
    ],
  );
}

Widget _buildTextField({
  required TextEditingController controller,
  required String label,
  bool isPassword = false,
}) {
  return TextField(
    controller: controller,
    obscureText: isPassword,
    style: const TextStyle(fontSize: 14),
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Color(0xFF43E97B)),
      ),
    ),
  );
}

Widget _buildPasswordField({
  required TextEditingController controller,
  required String label,
  required VoidCallback onForgotPressed,
}) {
  return TextField(
    controller: controller,
    obscureText: true,
    style: const TextStyle(fontSize: 14),
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Color(0xFF43E97B)),
      ),
      suffixIcon: TextButton(
        onPressed: onForgotPressed,
        child: const Text(
          "Forgot?",
          style: TextStyle(
            fontSize: 12,
            color: Color(0xFF38B6FF),
          ),
        ),
      ),
    ),
  );
}

Widget _buildGradientButton({
  required VoidCallback onPressed,
  required String label,
}) {
  return Container(
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [Color(0xFF43E97B), Color(0xFF38F9D7)],
      ),
      borderRadius: BorderRadius.circular(30),
      boxShadow: [
        BoxShadow(
          color: const Color(0xFF43E97B).withOpacity(0.3),
          blurRadius: 15,
          offset: const Offset(0, 8),
        ),
      ],
    ),
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
  );
}
