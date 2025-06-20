import 'package:flutter/material.dart';

class AdoptionScreen extends StatefulWidget {
  const AdoptionScreen({super.key});

  @override
  State<AdoptionScreen> createState() => _AdoptionScreenState();
}

class _AdoptionScreenState extends State<AdoptionScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  int _selectedIndex = 0;
  int _selectedFilterIndex = 0;

  final List<String> _filters = ['Todos', 'Perros', 'Gatos', 'Otros'];

  final List<Map<String, dynamic>> _pets = [
    {
      'name': 'Bobby',
      'type': 'Perro',
      'breed': 'Mestizo',
      'age': '2 años',
      'gender': 'Macho',
      'size': 'Mediano',
      'location': 'La Paz Centro',
      'description':
          'Bobby es un perro muy cariñoso y juguetón. Le encanta correr y jugar con otros perros.',
      'image':
          'https://images.unsplash.com/photo-1552053831-71594a27632d?w=400&h=400&fit=crop',
      'vaccinated': true,
      'sterilized': false,
      'urgent': false,
      'shelter': 'Refugio Esperanza'
    },
    {
      'name': 'Luna',
      'type': 'Gato',
      'breed': 'Siamés',
      'age': '1 año',
      'gender': 'Hembra',
      'size': 'Pequeño',
      'location': 'La Paz Sur',
      'description':
          'Luna es una gatita muy tranquila y cariñosa. Perfecta para familias con niños.',
      'image':
          'https://images.unsplash.com/photo-1574158622682-e40e69881006?w=400&h=400&fit=crop',
      'vaccinated': true,
      'sterilized': true,
      'urgent': true,
      'shelter': 'Casa de Gatos'
    },
    {
      'name': 'Max',
      'type': 'Perro',
      'breed': 'Golden Retriever',
      'age': '5 años',
      'gender': 'Macho',
      'size': 'Grande',
      'location': 'La Paz Norte',
      'description':
          'Max es un perro adulto muy tranquilo y obediente. Ideal para personas mayores.',
      'image':
          'https://images.unsplash.com/photo-1583337130417-3346a1be7dee?w=400&h=400&fit=crop',
      'vaccinated': true,
      'sterilized': true,
      'urgent': false,
      'shelter': 'Protectora Animal'
    },
    {
      'name': 'Mimi',
      'type': 'Gato',
      'breed': 'Persa',
      'age': '3 años',
      'gender': 'Hembra',
      'size': 'Mediano',
      'location': 'La Paz Centro',
      'description':
          'Mimi es una gata muy elegante y cariñosa. Le gusta la tranquilidad.',
      'image':
          'https://images.unsplash.com/photo-1548247416-ec66f4900b2e?w=400&h=400&fit=crop',
      'vaccinated': true,
      'sterilized': true,
      'urgent': true,
      'shelter': 'Refugio Felino'
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF059669),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '🏠 Adopción',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_outline, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _slideAnimation.value),
            child: Opacity(
              opacity: _fadeAnimation.value,
              child: Column(
                children: [
                  _buildHeader(),
                  _buildFilters(),
                  Expanded(
                    child: _buildPetsList(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: const Color(0xFF059669),
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Encuentra tu compañero perfecto',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 15),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Buscar mascotas...',
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
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Filtrar por tipo',
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
              itemCount: _filters.length,
              itemBuilder: (context, index) {
                final isSelected = _selectedFilterIndex == index;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedFilterIndex = index;
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
                      _filters[index],
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
        ],
      ),
    );
  }

  Widget _buildPetsList() {
    final selectedFilter = _filters[_selectedFilterIndex];
    final filteredPets = selectedFilter == 'Todos'
        ? _pets
        : _pets.where((pet) => pet['type'] == selectedFilter).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView.builder(
        itemCount: filteredPets.length,
        itemBuilder: (context, index) {
          final pet = filteredPets[index];
          return _buildPetCard(pet);
        },
      ),
    );
  }

  Widget _buildPetCard(Map<String, dynamic> pet) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 250,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  image: DecorationImage(
                    image: NetworkImage(pet['image']),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              if (pet['urgent'])
                Positioned(
                  top: 15,
                  left: 15,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEF4444),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Text(
                      '🚨 URGENTE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              Positioned(
                top: 15,
                right: 15,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.favorite_border,
                    size: 20,
                    color: Color(0xFFEF4444),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      pet['name'],
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: pet['gender'] == 'Macho'
                            ? const Color(0xFF3B82F6)
                            : const Color(0xFFEC4899),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        pet['gender'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '${pet['breed']} • ${pet['age']} • ${pet['size']}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 16,
                      color: Colors.grey[500],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      pet['location'],
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      pet['shelter'],
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  pet['description'],
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    _buildStatusChip(
                      icon: Icons.vaccines,
                      label: 'Vacunado',
                      isActive: pet['vaccinated'],
                    ),
                    const SizedBox(width: 8),
                    _buildStatusChip(
                      icon: Icons.healing,
                      label: 'Esterilizado',
                      isActive: pet['sterilized'],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF059669)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        icon: const Icon(
                          Icons.info_outline,
                          size: 18,
                          color: Color(0xFF059669),
                        ),
                        label: const Text(
                          'Más info',
                          style: TextStyle(
                            color: Color(0xFF059669),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF059669),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        icon: const Icon(
                          Icons.favorite,
                          size: 18,
                          color: Colors.white,
                        ),
                        label: const Text(
                          'Adoptar',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
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

  Widget _buildStatusChip({
    required IconData icon,
    required String label,
    required bool isActive,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: isActive
            ? const Color(0xFF10B981).withOpacity(0.1)
            : Colors.grey[100],
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: isActive ? const Color(0xFF10B981) : Colors.grey[300]!,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isActive ? Icons.check_circle : Icons.cancel,
            size: 14,
            color: isActive ? const Color(0xFF10B981) : Colors.grey[500],
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isActive ? const Color(0xFF10B981) : Colors.grey[600],
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
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
    );
  }

  void _navigateToTab(int index) {
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/home');
        break;
      case 1:
        Navigator.pushNamed(context, '/petshop');
        break;
      case 2:
        Navigator.pushNamed(context, '/vet');
        break;
      case 3:
        Navigator.pushNamed(context, '/profile');
        break;
    }
  }
}
