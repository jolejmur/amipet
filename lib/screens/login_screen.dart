import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../core/services/auth_service.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _pawController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _pawAnimation;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _pawController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _slideAnimation = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.3, 1.0, curve: Curves.elasticOut),
    ));

    _pawAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pawController,
      curve: Curves.elasticOut,
    ));

    _animationController.forward();
    _pawController.repeat(reverse: true);

    // Verificar si el usuario ya está autenticado
    _checkAuthState();
  }

  void _checkAuthState() {
    if (AuthService.isSignedIn) {
      // Si ya está autenticado, ir directamente al home
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pawController.dispose();
    super.dispose();
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF059669)),
          ),
        );
      },
    );
  }

  void _hideLoadingDialog() {
    Navigator.of(context).pop();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleGoogleLogin() async {
    try {
      setState(() => _isLoading = true);
      _showLoadingDialog();

      final userCredential = await AuthService.signInWithGoogle();

      if (userCredential != null) {
        _hideLoadingDialog();

        // Mostrar mensaje de éxito
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                '¡Bienvenido ${userCredential.user?.displayName ?? 'Usuario'}!'),
            backgroundColor: const Color(0xFF10B981),
            duration: const Duration(milliseconds: 1500),
          ),
        );

        // Navegar al home
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        }
      } else {
        _hideLoadingDialog();
        // El usuario canceló el sign in
      }
    } catch (e) {
      _hideLoadingDialog();
      _showErrorDialog('Error al iniciar sesión con Google: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleAppleLogin() async {
    try {
      setState(() => _isLoading = true);
      _showLoadingDialog();

      final userCredential = await AuthService.signInWithApple();

      if (userCredential != null) {
        _hideLoadingDialog();

        // Mostrar mensaje de éxito
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                '¡Bienvenido ${userCredential.user?.displayName ?? 'Usuario'}!'),
            backgroundColor: const Color(0xFF047857),
            duration: const Duration(milliseconds: 1500),
          ),
        );

        // Navegar al home
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        }
      }
    } catch (e) {
      _hideLoadingDialog();
      _showErrorDialog('Error al iniciar sesión con Apple: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF047857),
              Color(0xFF059669),
              Color(0xFF10B981),
              Color(0xFF34D399),
            ],
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: SafeArea(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _slideAnimation.value),
                child: Opacity(
                  opacity: _fadeAnimation.value,
                  child: Column(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildAnimatedLogo(),
                              const SizedBox(height: 32),
                              const Text(
                                'AmiPet',
                                style: TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      offset: Offset(2, 2),
                                      blurRadius: 4,
                                      color: Colors.black26,
                                    ),
                                  ],
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Tu compañero digital para\nel cuidado de mascotas',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300,
                                  height: 1.4,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(32),
                              topRight: Radius.circular(32),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(32),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const Column(
                                  children: [
                                    Text(
                                      '¡Bienvenido de vuelta!',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF047857),
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Inicia sesión para continuar',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xFF64748B),
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    _buildLoginButton(
                                      icon: Container(
                                        width: 20,
                                        height: 20,
                                        child: const Text(
                                          'G',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      text: 'Continuar con Google',
                                      backgroundColor: const Color(0xFF10B981),
                                      textColor: Colors.white,
                                      onTap: _isLoading
                                          ? null
                                          : _handleGoogleLogin,
                                    ),
                                    const SizedBox(height: 16),
                                    _buildLoginButton(
                                      icon: const Icon(
                                        Icons.apple,
                                        size: 24,
                                        color: Colors.white,
                                      ),
                                      text: 'Continuar con Apple',
                                      backgroundColor: const Color(0xFF047857),
                                      textColor: Colors.white,
                                      onTap:
                                          _isLoading ? null : _handleAppleLogin,
                                    ),
                                  ],
                                ),
                                const Text(
                                  'Al continuar, aceptas nuestros\nTérminos de Servicio y Política de Privacidad',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF64748B),
                                    height: 1.4,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
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
      ),
    );
  }

  Widget _buildAnimatedLogo() {
    return AnimatedBuilder(
      animation: _pawAnimation,
      builder: (context, child) {
        return Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Transform.scale(
                scale: 1.0 + (_pawAnimation.value * 0.1),
                child: const Icon(
                  Icons.pets,
                  size: 60,
                  color: Colors.white,
                ),
              ),
              ..._buildFloatingPaws(),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildFloatingPaws() {
    return [
      Positioned(
        top: 10 + (_pawAnimation.value * 5),
        right: 15 + (_pawAnimation.value * 3),
        child: Transform.rotate(
          angle: _pawAnimation.value * 0.2,
          child: Icon(
            Icons.pets,
            size: 16,
            color: Colors.white.withOpacity(0.6),
          ),
        ),
      ),
      Positioned(
        bottom: 15 + (_pawAnimation.value * 4),
        left: 20 + (_pawAnimation.value * 2),
        child: Transform.rotate(
          angle: -_pawAnimation.value * 0.15,
          child: Icon(
            Icons.pets,
            size: 12,
            color: Colors.white.withOpacity(0.4),
          ),
        ),
      ),
      Positioned(
        top: 30 + (_pawAnimation.value * 3),
        left: 10 + (_pawAnimation.value * 4),
        child: Transform.rotate(
          angle: _pawAnimation.value * 0.25,
          child: Icon(
            Icons.pets,
            size: 14,
            color: Colors.white.withOpacity(0.5),
          ),
        ),
      ),
    ];
  }

  Widget _buildLoginButton({
    required Widget icon,
    required String text,
    required Color backgroundColor,
    required Color textColor,
    required VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: onTap == null
                ? backgroundColor.withOpacity(0.5)
                : backgroundColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: onTap == null
                ? []
                : [
                    BoxShadow(
                      color: backgroundColor.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              const SizedBox(width: 12),
              Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: onTap == null ? textColor.withOpacity(0.5) : textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
