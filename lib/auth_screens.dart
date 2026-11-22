import 'dart:async';
import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'home_screen.dart';

// =============================================================================
// 1. SPLASH SCREEN
// =============================================================================
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _progressController;
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();
    // Progress bar animation over 2.2 seconds
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..forward();

    // Navigate to WelcomeScreen after 2.5 seconds
    _navigationTimer = Timer(const Duration(milliseconds: 2500), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const WelcomeScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _progressController.dispose();
    _navigationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgCream,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 2),

            // Centered Logo
            const Center(
              child: AppLogoWidget(width: 240),
            ),

            const SizedBox(height: 28),

            // Eyebrow Label
            Text(
              'GOOD FOOD. BETTER PLANS.',
              style: AppTheme.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.burntOrange,
                letterSpacing: 1.2,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 10),

            // Main Headline
            Text(
              'Your next table awaits.',
              style: AppTheme.inter(
                fontSize: 30,
                fontWeight: FontWeight.w800,
                color: AppColors.textCharcoal,
                height: 1.2,
              ),
              textAlign: TextAlign.center,
            ),

            const Spacer(flex: 3),

            // Animated Progress Bar (48x4, rounded)
            Container(
              width: 48,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.inputBorder,
                borderRadius: BorderRadius.circular(2),
              ),
              child: AnimatedBuilder(
                animation: _progressController,
                builder: (context, child) {
                  return FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: _progressController.value,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.primaryOrange,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 28),

            // Bottom Brand Name (always written "Boo-KAA")
            Text(
              'Boo-KAA',
              style: AppTheme.inter(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.mutedGray,
                letterSpacing: 1.0,
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// 2. WELCOME SCREEN
// =============================================================================
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final totalHeight = mediaQuery.size.height;
    final photoHeight = totalHeight * 0.55;

    return Scaffold(
      backgroundColor: AppColors.bgCream,
      body: Stack(
        children: [
          // Top ~55% Full-bleed restaurant photo
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: photoHeight,
            child: Image.asset(
              'assets/images/restaurant_hero.jpg',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                // Stylish fallback photo placeholder
                return Container(
                  color: const Color(0xFF23201C),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Opacity(
                          opacity: 0.15,
                          child: Icon(
                            Icons.restaurant,
                            size: 160,
                            color: AppColors.primaryOrange,
                          ),
                        ),
                      ),
                      Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.local_dining,
                              size: 48,
                              color: AppColors.primaryOrange,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Kathmandu Dining',
                              style: AppTheme.inter(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: AppColors.bgCream,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Bottom Sheet with large rounded top corners (radius 32)
          Positioned(
            top: photoHeight - 32,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.bgCream,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Eyebrow Label
                        Text(
                          'Boo-KAA',
                          style: AppTheme.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.burntOrange,
                            letterSpacing: 1.2,
                          ),
                        ),

                        const SizedBox(height: 10),

                        // Headline
                        Text(
                          'Great evenings\nstart with a table.',
                          style: AppTheme.inter(
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textCharcoal,
                            height: 1.15,
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Subtitle
                        Text(
                          'Find a restaurant you\'ll love. Choose your time. Leave the waiting behind.',
                          style: AppTheme.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: AppColors.mutedGray,
                            height: 1.4,
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Get started button -> SignUpScreen
                        PrimaryButton(
                          label: 'Get started',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignUpScreen(),
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 14),

                        // I already have an account button -> LoginScreen
                        SecondaryButton(
                          label: 'I already have an account',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// 3. LOGIN SCREEN
// =============================================================================
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  String? _emailError;
  String? _passwordError;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    setState(() {
      _emailError = null;
      _passwordError = null;
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    bool isValid = true;

    // Email validation
    if (email.isEmpty || !email.contains('@') || !email.contains('.')) {
      _emailError = 'Please enter a valid email address';
      isValid = false;
    }

    // Password validation
    if (password.isEmpty) {
      _passwordError = 'Password cannot be empty';
      isValid = false;
    }

    if (isValid) {
      setState(() {
        _isLoading = true;
      });

      // TODO: Call login API to Flask backend (POST /api/auth/login)
      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const HomeScreen(userName: 'Aayush'),
            ),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgCream,
      body: SafeArea(
        child: Column(
          children: [
            // Top Navigation Bar (Back Arrow)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: AppColors.textCharcoal,
                    size: 22,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),

                    // Headline
                    Text(
                      'Welcome back',
                      style: AppTheme.inter(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textCharcoal,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Subtitle
                    Text(
                      'Log in to find your next favourite table.',
                      style: AppTheme.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: AppColors.mutedGray,
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Email Field
                    AppTextField(
                      label: 'Email address',
                      hint: 'you@example.com',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      errorText: _emailError,
                      onChanged: (_) {
                        if (_emailError != null) {
                          setState(() => _emailError = null);
                        }
                      },
                    ),

                    const SizedBox(height: 20),

                    // Password Field
                    AppTextField(
                      label: 'Password',
                      hint: 'Enter your password',
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      errorText: _passwordError,
                      onChanged: (_) {
                        if (_passwordError != null) {
                          setState(() => _passwordError = null);
                        }
                      },
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: AppColors.mutedGray,
                          size: 22,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Right-aligned "Forgot password?"
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Password reset link sent to email!'),
                              backgroundColor: AppColors.darkCard,
                            ),
                          );
                        },
                        child: Text(
                          'Forgot password?',
                          style: AppTheme.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.burntOrange,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Primary Orange Login Button
                    PrimaryButton(
                      label: 'Log in',
                      isLoading: _isLoading,
                      onPressed: _handleLogin,
                    ),

                    const SizedBox(height: 24),

                    // Centered Text: "New to Boo-KAA? Create an account"
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignUpScreen(),
                            ),
                          );
                        },
                        child: RichText(
                          text: TextSpan(
                            style: AppTheme.inter(
                              fontSize: 14,
                              color: AppColors.textCharcoal,
                            ),
                            children: [
                              const TextSpan(text: 'New to Boo-KAA? '),
                              TextSpan(
                                text: 'Create an account',
                                style: AppTheme.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.burntOrange,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 36),

                    // Bottom Soft Cream Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.softCreamCard,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'A seat for every occasion.',
                            style: AppTheme.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textCharcoal,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Discover. Reserve. Enjoy.',
                            style: AppTheme.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: AppColors.mutedGray,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// 4. SIGN UP SCREEN
// =============================================================================
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  String? _nameError;
  String? _emailError;
  String? _phoneError;
  String? _passwordError;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleSignUp() {
    setState(() {
      _nameError = null;
      _emailError = null;
      _phoneError = null;
      _passwordError = null;
    });

    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final password = _passwordController.text;

    bool isValid = true;

    // Name validation
    if (name.isEmpty) {
      _nameError = 'Full name is required';
      isValid = false;
    }

    // Email validation
    if (email.isEmpty || !email.contains('@') || !email.contains('.')) {
      _emailError = 'Please enter a valid email address';
      isValid = false;
    }

    // Nepal mobile phone validation (10 digits)
    final digitsOnly = phone.replaceAll(RegExp(r'\D'), '');
    if (phone.isEmpty || digitsOnly.length != 10) {
      _phoneError = 'Enter a valid 10-digit mobile number';
      isValid = false;
    }

    // Password validation (at least 8 characters)
    if (password.length < 8) {
      _passwordError = 'Password must be at least 8 characters';
      isValid = false;
    }

    if (isValid) {
      setState(() {
        _isLoading = true;
      });

      // Extract first name for greeting
      final firstName = name.split(' ').first;

      // TODO: Call register API to Flask backend (POST /api/auth/register)
      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(userName: firstName),
            ),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgCream,
      body: SafeArea(
        child: Column(
          children: [
            // Top Navigation Bar (Back Arrow)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: AppColors.textCharcoal,
                    size: 22,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),

                    // Headline
                    Text(
                      'Your table starts here',
                      style: AppTheme.inter(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textCharcoal,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Subtitle
                    Text(
                      'Create an account to make your first booking.',
                      style: AppTheme.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: AppColors.mutedGray,
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Full Name Field
                    AppTextField(
                      label: 'Full name',
                      hint: 'Enter your full name',
                      controller: _nameController,
                      errorText: _nameError,
                      onChanged: (_) {
                        if (_nameError != null) {
                          setState(() => _nameError = null);
                        }
                      },
                    ),

                    const SizedBox(height: 18),

                    // Email Address Field
                    AppTextField(
                      label: 'Email address',
                      hint: 'you@example.com',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      errorText: _emailError,
                      onChanged: (_) {
                        if (_emailError != null) {
                          setState(() => _emailError = null);
                        }
                      },
                    ),

                    const SizedBox(height: 18),

                    // Phone Number Field
                    AppTextField(
                      label: 'Phone number',
                      hint: 'Enter your phone number',
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      errorText: _phoneError,
                      onChanged: (_) {
                        if (_phoneError != null) {
                          setState(() => _phoneError = null);
                        }
                      },
                    ),

                    const SizedBox(height: 18),

                    // Password Field
                    AppTextField(
                      label: 'Password',
                      hint: 'Create a password',
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      errorText: _passwordError,
                      helperText: _passwordError == null ? 'Use at least 8 characters.' : null,
                      onChanged: (_) {
                        if (_passwordError != null) {
                          setState(() => _passwordError = null);
                        }
                      },
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: AppColors.mutedGray,
                          size: 22,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Create Account Button
                    PrimaryButton(
                      label: 'Create account',
                      isLoading: _isLoading,
                      onPressed: _handleSignUp,
                    ),

                    const SizedBox(height: 24),

                    // Centered Text: "Already have an account? Log in"
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        },
                        child: RichText(
                          text: TextSpan(
                            style: AppTheme.inter(
                              fontSize: 14,
                              color: AppColors.textCharcoal,
                            ),
                            children: [
                              const TextSpan(text: 'Already have an account? '),
                              TextSpan(
                                text: 'Log in',
                                style: AppTheme.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.burntOrange,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
