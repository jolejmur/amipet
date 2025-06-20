import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  int _selectedIndex = 0;
  final PageController _promoController = PageController();
  int _currentPromoIndex = 0;

  final List<Map<String, dynamic>> _promos = [
    {
      'title': '20% OFF en Alimentos Premium',
      'subtitle': 'Válido hasta fin de mes',
      'color': Color(0xFF059669),
      'icon': '🍖',
    },
    {
      'title': 'Consulta Veterinaria Gratis',
      'subtitle': 'Primera visita sin costo',
      'color': Color(0xFF3B82F6),
      'icon': '⚕️',
    },
    {
      'title': 'Adopta y Recibe Kit Gratis',
      'subtitle': 'Incluye collar, correa y juguetes',
      'color': Color(0xFF8B5CF6),
      'icon': '🏠',
    },
  ];

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
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
      begin: 30.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.3, 1.0, curve: Curves.elasticOut),
    ));

    _animationController.forward();

    _startPromoTimer();
  }

  void _startPromoTimer() {
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted && _promoController.hasClients) {
        int nextPage = (_currentPromoIndex + 1) % _promos.length;
        _promoController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        _startPromoTimer();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _promoController.dispose();
    super.dispose();
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
                      _buildHeader(),
                      _buildSearchBar(),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(top: 20),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(32),
                              topRight: Radius.circular(32),
                            ),
                          ),
                          child: Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 12),
                                width: 40,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildPromotionsCarousel(),
                                      const SizedBox(height: 30),
                                      Expanded(
                                        child: GridView.count(
                                          crossAxisCount: 2,
                                          crossAxisSpacing: 16,
                                          mainAxisSpacing: 16,
                                          childAspectRatio: 0.85,
                                          children: [
                                            _buildServiceCard(
                                              title: 'Pet Shop',
                                              subtitle:
                                                  'Productos para\ntu mascota',
                                              icon: '🛍️',
                                              color: const Color(0xFF059669),
                                              onTap: () => _navigateToService(
                                                  'Pet Shop'),
                                            ),
                                            _buildServiceCard(
                                              title: 'Wiki Mascotas',
                                              subtitle:
                                                  'Guías y consejos\ngratuitos',
                                              icon: '📚',
                                              color: const Color(0xFF10B981),
                                              onTap: () =>
                                                  _navigateToService('Wiki'),
                                            ),
                                            _buildServiceCard(
                                              title: 'Adopción',
                                              subtitle:
                                                  'Encuentra tu\ncompañero ideal',
                                              icon: '🏠',
                                              color: const Color(0xFF34D399),
                                              onTap: () => _navigateToService(
                                                  'Adopción'),
                                            ),
                                            _buildServiceCard(
                                              title: 'Denuncias',
                                              subtitle:
                                                  'Reporta maltrato\nanimal',
                                              icon: '🚨',
                                              color: const Color(0xFFEF4444),
                                              onTap: () => _navigateToService(
                                                  'Denuncias'),
                                            ),
                                            _buildServiceCard(
                                              title: 'Veterinaria',
                                              subtitle:
                                                  'Consultas y\nemergecias',
                                              icon: '⚕️',
                                              color: const Color(0xFF3B82F6),
                                              onTap: () => _navigateToService(
                                                  'Veterinaria'),
                                            ),
                                            _buildServiceCard(
                                              title: 'Vacunas',
                                              subtitle:
                                                  'Control de\nvacunación',
                                              icon: '💉',
                                              color: const Color(0xFF8B5CF6),
                                              onTap: () =>
                                                  _navigateToService('Vacunas'),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
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
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Row(
        children: [
          Container(
            width: 55,
            height: 55,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 2,
              ),
              image: const DecorationImage(
                image: NetworkImage(
                    'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '¡Hola, Carlos! 👋',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.9),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const Text(
                  'Cuida a tus peludos',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.2),
            ),
            child: Stack(
              children: [
                const Center(
                  child: Icon(
                    Icons.notifications_outlined,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFFEF4444),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: TextField(
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Buscar servicios, productos...',
          hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 16,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.white.withOpacity(0.8),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildPromotionsCarousel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              '🎉 Promociones',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF047857),
              ),
            ),
            Text(
              'Ver todas',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: 120,
          child: PageView.builder(
            controller: _promoController,
            onPageChanged: (index) {
              setState(() {
                _currentPromoIndex = index;
              });
            },
            itemCount: _promos.length,
            itemBuilder: (context, index) {
              final promo = _promos[index];
              return Container(
                margin: const EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      promo['color'],
                      promo['color'].withOpacity(0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: promo['color'].withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Text(
                        promo['icon'],
                        style: const TextStyle(fontSize: 32),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              promo['title'],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              promo['subtitle'],
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _promos.length,
            (index) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _currentPromoIndex == index ? 20 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: _currentPromoIndex == index
                    ? const Color(0xFF059669)
                    : Colors.grey[300],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildServiceCard({
    required String title,
    required String subtitle,
    required String icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: color.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  icon,
                  style: const TextStyle(fontSize: 28),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF64748B),
                height: 1.3,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          _navigateToTab(index);
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF059669),
        unselectedItemColor: Colors.grey[400],
        selectedFontSize: 12,
        unselectedFontSize: 12,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.store_outlined),
            activeIcon: Icon(Icons.store),
            label: 'Pet Shop',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_hospital_outlined),
            activeIcon: Icon(Icons.local_hospital),
            label: 'Veterinarios',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }

  void _navigateToService(String serviceName) {
    print('Navegando a: $serviceName'); // Para debug
    switch (serviceName) {
      case 'Pet Shop':
        Navigator.pushNamed(context, '/petshop');
        break;
      case 'Wiki':
        Navigator.pushNamed(context, '/wiki');
        break;
      case 'Adopción':
        Navigator.pushNamed(context, '/adoption');
        break;
      case 'Denuncias':
        Navigator.pushNamed(context, '/report');
        break;
      case 'Veterinaria':
        Navigator.pushNamed(context, '/vet');
        break;
      case 'Vacunas':
        Navigator.pushNamed(context, '/vaccine');
        break;
      default:
        print('Servicio no encontrado: $serviceName'); // Para debug
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Abriendo $serviceName...'),
            backgroundColor: const Color(0xFF059669),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
    }
  }

  void _navigateToTab(int index) {
    switch (index) {
      case 1: // Pet Shop
        Navigator.pushNamed(context, '/petshop');
        break;
      case 2: // Veterinarios
        Navigator.pushNamed(context, '/vet');
        break;
      case 3: // Perfil
        Navigator.pushNamed(context, '/profile');
        break;
      default:
        // Ya estamos en Home, no hacer nada
        break;
    }
  }
}
