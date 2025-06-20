import 'package:flutter/material.dart';
import 'home_screen.dart';

class VetScreen extends StatefulWidget {
  const VetScreen({super.key});

  @override
  State<VetScreen> createState() => _VetScreenState();
}

class _VetScreenState extends State<VetScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  int _selectedIndex = 2; // Veterinarios tab
  int _selectedTypeIndex = 0;

  final List<String> _serviceTypes = [
    'Todos',
    'Consulta',
    'Emergencia',
    'Cirugía',
    'Vacunación',
    'Grooming'
  ];

  final List<Map<String, dynamic>> _veterinarians = [
    {
      'name': 'Dr. María González',
      'specialty': 'Medicina General',
      'rating': 4.9,
      'reviews': 127,
      'distance': '0.8 km',
      'price': 45,
      'available': true,
      'emergency': true,
      'image':
          'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?w=150&h=150&fit=crop&crop=face',
      'clinic': 'VetCare Centro'
    },
    {
      'name': 'Dr. Carlos Ruiz',
      'specialty': 'Cirugía Veterinaria',
      'rating': 4.8,
      'reviews': 89,
      'distance': '1.2 km',
      'price': 65,
      'available': false,
      'emergency': true,
      'image':
          'https://images.unsplash.com/photo-1612349317150-e413f6a5b16d?w=150&h=150&fit=crop&crop=face',
      'clinic': 'Hospital Animal Plus'
    },
    {
      'name': 'Dra. Ana Martín',
      'specialty': 'Dermatología',
      'rating': 4.7,
      'reviews': 156,
      'distance': '2.1 km',
      'price': 55,
      'available': true,
      'emergency': false,
      'image':
          'https://images.unsplash.com/photo-1594824763093-943ed1b4eacb?w=150&h=150&fit=crop&crop=face',
      'clinic': 'Clínica Veterinaria Sur'
    },
    {
      'name': 'Dr. Luis Hernández',
      'specialty': 'Medicina Interna',
      'rating': 4.9,
      'reviews': 203,
      'distance': '0.5 km',
      'price': 50,
      'available': true,
      'emergency': true,
      'image':
          'https://images.unsplash.com/photo-1622902046580-2b47f47f5471?w=150&h=150&fit=crop&crop=face',
      'clinic': 'VetExpress 24h'
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _slideAnimation = Tween<double>(
      begin: 30.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
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
                              _buildEmergencyAlert(),
                              _buildServiceTypes(),
                              Expanded(
                                child: _buildVeterinariansList(),
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
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.2),
            ),
            child: const Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '⚕️ Veterinarios',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Encuentra atención veterinaria',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                    fontWeight: FontWeight.w400,
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
            child: const Icon(
              Icons.location_on_outlined,
              color: Colors.white,
              size: 24,
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
          hintText: 'Buscar veterinarios...',
          hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 16,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.white.withOpacity(0.8),
          ),
          suffixIcon: Icon(
            Icons.tune,
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

  Widget _buildEmergencyAlert() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFEF4444).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.emergency,
              color: Color(0xFFEF4444),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '🚨 Emergencia Veterinaria',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Atención 24/7 disponible',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Llamar',
              style: TextStyle(
                color: Color(0xFFEF4444),
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceTypes() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Servicios',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF047857),
            ),
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _serviceTypes.length,
              itemBuilder: (context, index) {
                final isSelected = _selectedTypeIndex == index;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedTypeIndex = index;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF059669)
                          : Colors.grey[100],
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF059669)
                            : Colors.grey[300]!,
                      ),
                    ),
                    child: Text(
                      _serviceTypes[index],
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.white : Colors.grey[700],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildVeterinariansList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView.builder(
        itemCount: _veterinarians.length,
        itemBuilder: (context, index) {
          final vet = _veterinarians[index];
          return _buildVeterinarianCard(vet);
        },
      ),
    );
  }

  Widget _buildVeterinarianCard(Map<String, dynamic> vet) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Stack(
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(vet['image']),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                if (vet['available'])
                  Positioned(
                    bottom: 2,
                    right: 2,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          vet['name'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                      ),
                      if (vet['emergency'])
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEF4444),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            '24h',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    vet['specialty'],
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    vet['clinic'],
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        size: 14,
                        color: Colors.amber[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${vet['rating']} (${vet['reviews']})',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(
                        Icons.location_on,
                        size: 14,
                        color: Colors.grey[500],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        vet['distance'],
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Desde \$${vet['price']}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF059669),
                        ),
                      ),
                      Row(
                        children: [
                          OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFF059669)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                            ),
                            child: const Text(
                              'Ver perfil',
                              style: TextStyle(
                                color: Color(0xFF059669),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: vet['available'] ? () {} : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: vet['available']
                                  ? const Color(0xFF059669)
                                  : Colors.grey[300],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                            ),
                            child: Text(
                              vet['available'] ? 'Agendar' : 'No disponible',
                              style: TextStyle(
                                color: vet['available']
                                    ? Colors.white
                                    : Colors.grey[600],
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
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

  void _navigateToTab(int index) {
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      List<String> tabs = ['Inicio', 'Pet Shop', 'Veterinarios', 'Perfil'];
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Navegando a ${tabs[index]}...'),
          backgroundColor: const Color(0xFF059669),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }
}
