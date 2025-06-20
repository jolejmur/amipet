import 'package:flutter/material.dart';

class VaccineScreen extends StatefulWidget {
  const VaccineScreen({super.key});

  @override
  State<VaccineScreen> createState() => _VaccineScreenState();
}

class _VaccineScreenState extends State<VaccineScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  int _selectedIndex = 0;
  int _selectedPetIndex = 0;

  final List<Map<String, dynamic>> _pets = [
    {
      'name': 'Max',
      'type': 'Perro',
      'age': '3 años',
      'image':
          'https://images.unsplash.com/photo-1552053831-71594a27632d?w=150&h=150&fit=crop',
    },
    {
      'name': 'Luna',
      'type': 'Gato',
      'age': '2 años',
      'image':
          'https://images.unsplash.com/photo-1574158622682-e40e69881006?w=150&h=150&fit=crop',
    },
  ];

  final Map<String, List<Map<String, dynamic>>> _vaccines = {
    'Max': [
      {
        'name': 'Vacuna Antirrábica',
        'status': 'completed',
        'date': '2024-03-15',
        'nextDate': '2025-03-15',
        'veterinarian': 'Dr. Carlos Ruiz',
        'clinic': 'VetCare Centro',
        'batch': 'VAC-2024-001',
        'urgent': false,
      },
      {
        'name': 'Vacuna Múltiple (DHPP)',
        'status': 'completed',
        'date': '2024-02-20',
        'nextDate': '2025-02-20',
        'veterinarian': 'Dr. Carlos Ruiz',
        'clinic': 'VetCare Centro',
        'batch': 'VAC-2024-002',
        'urgent': false,
      },
      {
        'name': 'Vacuna Bordetella',
        'status': 'pending',
        'date': null,
        'nextDate': '2025-07-15',
        'veterinarian': null,
        'clinic': null,
        'batch': null,
        'urgent': true,
      },
      {
        'name': 'Desparasitación',
        'status': 'overdue',
        'date': '2024-01-10',
        'nextDate': '2024-04-10',
        'veterinarian': 'Dra. Ana Martín',
        'clinic': 'Clínica Veterinaria Sur',
        'batch': 'DES-2024-001',
        'urgent': true,
      },
    ],
    'Luna': [
      {
        'name': 'Vacuna Antirrábica',
        'status': 'completed',
        'date': '2024-04-10',
        'nextDate': '2025-04-10',
        'veterinarian': 'Dra. María González',
        'clinic': 'Hospital Animal Plus',
        'batch': 'VAC-2024-003',
        'urgent': false,
      },
      {
        'name': 'Vacuna Triple Felina',
        'status': 'completed',
        'date': '2024-03-05',
        'nextDate': '2025-03-05',
        'veterinarian': 'Dra. María González',
        'clinic': 'Hospital Animal Plus',
        'batch': 'VAC-2024-004',
        'urgent': false,
      },
      {
        'name': 'Vacuna Leucemia Felina',
        'status': 'pending',
        'date': null,
        'nextDate': '2025-06-20',
        'veterinarian': null,
        'clinic': null,
        'batch': null,
        'urgent': false,
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF8B5CF6),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '💉 Control de Vacunas',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () => _showAddVaccineDialog(),
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
                  _buildPetSelector(),
                  Expanded(
                    child: _buildVaccinesList(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showScheduleDialog(),
        backgroundColor: const Color(0xFF8B5CF6),
        child: const Icon(Icons.calendar_month, color: Colors.white),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: const Color(0xFF8B5CF6),
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Mantén a tus mascotas protegidas',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Lleva un control completo de vacunas y desparasitaciones',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPetSelector() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Selecciona tu mascota',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _pets.length,
              itemBuilder: (context, index) {
                final pet = _pets[index];
                final isSelected = _selectedPetIndex == index;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedPetIndex = index;
                    });
                  },
                  child: Container(
                    width: 120,
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF8B5CF6).withOpacity(0.1)
                          : Colors.grey[100],
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF8B5CF6)
                            : Colors.grey[300]!,
                        width: 2,
                      ),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage(pet['image']),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                pet['name'],
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected
                                      ? const Color(0xFF8B5CF6)
                                      : Colors.grey[700],
                                ),
                              ),
                              Text(
                                '${pet['type']} • ${pet['age']}',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: isSelected
                                      ? const Color(0xFF8B5CF6)
                                      : Colors.grey[600],
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
        ],
      ),
    );
  }

  Widget _buildVaccinesList() {
    final selectedPet = _pets[_selectedPetIndex]['name'];
    final vaccines = _vaccines[selectedPet] ?? [];

    // Separar vacunas por estado
    final urgentVaccines = vaccines.where((v) => v['urgent'] == true).toList();
    final completedVaccines =
        vaccines.where((v) => v['status'] == 'completed').toList();
    final pendingVaccines = vaccines
        .where((v) => v['status'] == 'pending' && v['urgent'] != true)
        .toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (urgentVaccines.isNotEmpty) ...[
            _buildSectionHeader(
                '⚠️ Urgentes', urgentVaccines.length, Colors.red),
            const SizedBox(height: 10),
            ...urgentVaccines
                .map((vaccine) => _buildVaccineCard(vaccine, true)),
            const SizedBox(height: 20),
          ],
          if (pendingVaccines.isNotEmpty) ...[
            _buildSectionHeader(
                '📅 Próximas', pendingVaccines.length, const Color(0xFF8B5CF6)),
            const SizedBox(height: 10),
            ...pendingVaccines
                .map((vaccine) => _buildVaccineCard(vaccine, false)),
            const SizedBox(height: 20),
          ],
          if (completedVaccines.isNotEmpty) ...[
            _buildSectionHeader('✅ Completadas', completedVaccines.length,
                const Color(0xFF10B981)),
            const SizedBox(height: 10),
            ...completedVaccines
                .map((vaccine) => _buildVaccineCard(vaccine, false)),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, int count, Color color) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            count.toString(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVaccineCard(Map<String, dynamic> vaccine, bool isUrgent) {
    Color statusColor;
    IconData statusIcon;
    String statusText;

    switch (vaccine['status']) {
      case 'completed':
        statusColor = const Color(0xFF10B981);
        statusIcon = Icons.check_circle;
        statusText = 'Completada';
        break;
      case 'pending':
        statusColor = const Color(0xFF8B5CF6);
        statusIcon = Icons.schedule;
        statusText = 'Pendiente';
        break;
      case 'overdue':
        statusColor = const Color(0xFFEF4444);
        statusIcon = Icons.warning;
        statusText = 'Vencida';
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.help;
        statusText = 'Desconocido';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isUrgent ? Colors.red.withOpacity(0.3) : Colors.grey[200]!,
          width: isUrgent ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    statusIcon,
                    color: statusColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        vaccine['name'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      Text(
                        statusText,
                        style: TextStyle(
                          fontSize: 12,
                          color: statusColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isUrgent)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'URGENTE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            if (vaccine['date'] != null) ...[
              _buildInfoRow('Última aplicación:', _formatDate(vaccine['date'])),
              const SizedBox(height: 4),
            ],
            if (vaccine['nextDate'] != null) ...[
              _buildInfoRow('Próxima dosis:', _formatDate(vaccine['nextDate'])),
              const SizedBox(height: 4),
            ],
            if (vaccine['veterinarian'] != null) ...[
              _buildInfoRow('Veterinario:', vaccine['veterinarian']),
              const SizedBox(height: 4),
            ],
            if (vaccine['clinic'] != null) ...[
              _buildInfoRow('Clínica:', vaccine['clinic']),
              const SizedBox(height: 4),
            ],
            if (vaccine['batch'] != null) ...[
              _buildInfoRow('Lote:', vaccine['batch']),
              const SizedBox(height: 12),
            ],
            if (vaccine['status'] != 'completed') ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _scheduleVaccine(vaccine),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: statusColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Agendar',
                        style: TextStyle(color: statusColor),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _markAsCompleted(vaccine),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: statusColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Marcar completada',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF1F2937),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    final months = [
      'Ene',
      'Feb',
      'Mar',
      'Abr',
      'May',
      'Jun',
      'Jul',
      'Ago',
      'Sep',
      'Oct',
      'Nov',
      'Dic'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  void _scheduleVaccine(Map<String, dynamic> vaccine) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Agendar ${vaccine['name']}'),
        content: const Text('¿Deseas agendar una cita para esta vacuna?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Cita agendada exitosamente'),
                  backgroundColor: Color(0xFF8B5CF6),
                ),
              );
            },
            child: const Text('Agendar'),
          ),
        ],
      ),
    );
  }

  void _markAsCompleted(Map<String, dynamic> vaccine) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Marcar ${vaccine['name']} como completada'),
        content: const Text('¿Confirmas que esta vacuna ya fue aplicada?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                vaccine['status'] = 'completed';
                vaccine['date'] = DateTime.now().toString().split(' ')[0];
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Vacuna marcada como completada'),
                  backgroundColor: Color(0xFF10B981),
                ),
              );
            },
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }

  void _showAddVaccineDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Agregar Nueva Vacuna'),
        content: const Text('¿Deseas agregar una nueva vacuna al calendario?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Función próximamente disponible'),
                  backgroundColor: Color(0xFF8B5CF6),
                ),
              );
            },
            child: const Text('Agregar'),
          ),
        ],
      ),
    );
  }

  void _showScheduleDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Calendario de Vacunas'),
        content:
            const Text('¿Deseas ver el calendario completo de vacunación?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Abriendo calendario...'),
                  backgroundColor: Color(0xFF8B5CF6),
                ),
              );
            },
            child: const Text('Ver Calendario'),
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
