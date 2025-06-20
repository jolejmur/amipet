import 'package:flutter/material.dart';
import 'home_screen.dart';

class WikiScreen extends StatefulWidget {
  const WikiScreen({super.key});

  @override
  State<WikiScreen> createState() => _WikiScreenState();
}

class _WikiScreenState extends State<WikiScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  int _selectedIndex = 0;
  int _selectedCategoryIndex = 0;

  final List<Map<String, dynamic>> _categories = [
    {'name': 'Cuidados', 'icon': '💚', 'color': Color(0xFF059669)},
    {'name': 'Salud', 'icon': '⚕️', 'color': Color(0xFF3B82F6)},
    {'name': 'Entrenamiento', 'icon': '🎯', 'color': Color(0xFF8B5CF6)},
    {'name': 'Nutrición', 'icon': '🥗', 'color': Color(0xFF10B981)},
    {'name': 'Comportamiento', 'icon': '🧠', 'color': Color(0xFFF59E0B)},
  ];

  final Map<String, List<Map<String, dynamic>>> _articles = {
    'Cuidados': [
      {
        'title': 'Cómo bañar a tu perro correctamente',
        'description': 'Guía completa para el baño perfecto de tu mascota',
        'readTime': '5 min',
        'image':
            'https://images.unsplash.com/photo-1544717297-fa95b6ee9643?w=300&h=200&fit=crop',
        'difficulty': 'Fácil',
        'author': 'Dr. María González'
      },
      {
        'title': 'Cuidado de uñas en mascotas',
        'description': 'Todo lo que necesitas saber sobre el corte de uñas',
        'readTime': '3 min',
        'image':
            'https://images.unsplash.com/photo-1601758228041-f3b2795255f1?w=300&h=200&fit=crop',
        'difficulty': 'Intermedio',
        'author': 'Vet. Carlos Ruiz'
      },
    ],
    'Salud': [
      {
        'title': 'Vacunas esenciales para cachorros',
        'description': 'Calendario completo de vacunación para tu mascota',
        'readTime': '8 min',
        'image':
            'https://images.unsplash.com/photo-1559181567-c3190ca9959b?w=300&h=200&fit=crop',
        'difficulty': 'Importante',
        'author': 'Dra. Ana Martín'
      },
      {
        'title': 'Síntomas de alarma en mascotas',
        'description': 'Cuándo es necesario acudir al veterinario',
        'readTime': '6 min',
        'image':
            'https://images.unsplash.com/photo-1576201836106-db1758fd1c97?w=300&h=200&fit=crop',
        'difficulty': 'Crítico',
        'author': 'Dr. Luis Hernández'
      },
    ],
    'Entrenamiento': [
      {
        'title': 'Comandos básicos para cachorros',
        'description': 'Enseña a tu perro los comandos fundamentales',
        'readTime': '10 min',
        'image':
            'https://images.unsplash.com/photo-1552053831-71594a27632d?w=300&h=200&fit=crop',
        'difficulty': 'Fácil',
        'author': 'Entrenador José Pérez'
      },
    ],
    'Nutrición': [
      {
        'title': 'Alimentación por edades',
        'description': 'Qué darle de comer según la edad de tu mascota',
        'readTime': '7 min',
        'image':
            'https://images.unsplash.com/photo-1589924691995-400dc9ecc119?w=300&h=200&fit=crop',
        'difficulty': 'Intermedio',
        'author': 'Nutricionista Pet Laura Silva'
      },
    ],
    'Comportamiento': [
      {
        'title': 'Cómo reducir la ansiedad en mascotas',
        'description': 'Técnicas para calmar a tu mascota',
        'readTime': '9 min',
        'image':
            'https://images.unsplash.com/photo-1548199973-03cce0bbc87b?w=300&h=200&fit=crop',
        'difficulty': 'Intermedio',
        'author': 'Etóloga Marta López'
      },
    ],
  };

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
                              _buildCategoriesSection(),
                              Expanded(
                                child: _buildArticlesList(),
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
                  '📚 Wiki Mascotas',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Aprende todo sobre el cuidado',
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
              Icons.bookmark_outline,
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
          hintText: 'Buscar artículos...',
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

  Widget _buildCategoriesSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Categorías',
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
                  color: Color(0xFF059669),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = _selectedCategoryIndex == index;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategoryIndex = index;
                    });
                  },
                  child: Container(
                    width: 110,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? category['color'] : Colors.grey[100],
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: category['color'].withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : [],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          category['icon'],
                          style: const TextStyle(fontSize: 24),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          category['name'],
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isSelected ? Colors.white : Colors.grey[700],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArticlesList() {
    final selectedCategory = _categories[_selectedCategoryIndex]['name'];
    final articles = _articles[selectedCategory] ?? [];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Artículos - $selectedCategory',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF047857),
            ),
          ),
          const SizedBox(height: 15),
          Expanded(
            child: ListView.builder(
              itemCount: articles.length,
              itemBuilder: (context, index) {
                final article = articles[index];
                return _buildArticleCard(article);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArticleCard(Map<String, dynamic> article) {
    Color difficultyColor;
    switch (article['difficulty']) {
      case 'Fácil':
        difficultyColor = const Color(0xFF10B981);
        break;
      case 'Intermedio':
        difficultyColor = const Color(0xFFF59E0B);
        break;
      case 'Importante':
        difficultyColor = const Color(0xFF3B82F6);
        break;
      case 'Crítico':
        difficultyColor = const Color(0xFFEF4444);
        break;
      default:
        difficultyColor = Colors.grey;
    }

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 150,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              image: DecorationImage(
                image: NetworkImage(article['image']),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.3),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: difficultyColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      article['difficulty'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 12,
                  left: 12,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.access_time,
                          size: 12,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          article['readTime'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  article['title'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  article['description'],
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 12,
                      backgroundColor: const Color(0xFF059669),
                      child: Text(
                        article['author'].split(' ').first[0],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        article['author'],
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF059669),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Leer',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
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
