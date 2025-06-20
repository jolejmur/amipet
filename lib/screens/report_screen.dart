import 'package:flutter/material.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  int _selectedIndex = 0;
  int _selectedTypeIndex = 0;

  final List<String> _reportTypes = [
    'Maltrato Animal',
    'Abandono',
    'Peleas de Animales',
    'Venta Ilegal',
    'Negligencia',
    'Otro'
  ];

  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();

  bool _isAnonymous = false;
  bool _isUrgent = false;

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
    _descriptionController.dispose();
    _locationController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFEF4444),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '🚨 Denuncias',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.white),
            onPressed: () => _showHelpDialog(),
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
                  Expanded(
                    child: _buildForm(),
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
      color: const Color(0xFFEF4444),
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Reporta maltrato animal',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tu denuncia puede salvar una vida. Todos los reportes son confidenciales.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildEmergencyAlert(),
          const SizedBox(height: 25),
          _buildReportTypeSection(),
          const SizedBox(height: 25),
          _buildDescriptionSection(),
          const SizedBox(height: 25),
          _buildLocationSection(),
          const SizedBox(height: 25),
          _buildContactSection(),
          const SizedBox(height: 25),
          _buildOptionsSection(),
          const SizedBox(height: 25),
          _buildPhotoSection(),
          const SizedBox(height: 30),
          _buildSubmitButton(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildEmergencyAlert() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.emergency,
            color: Colors.white,
            size: 24,
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Emergencia',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Si es una emergencia, llama al 911',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFFEF4444),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: const Text(
              'Llamar',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportTypeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tipo de denuncia',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1F2937),
          ),
        ),
        const SizedBox(height: 15),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: List.generate(_reportTypes.length, (index) {
            final isSelected = _selectedTypeIndex == index;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedTypeIndex = index;
                });
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color:
                      isSelected ? const Color(0xFFEF4444) : Colors.grey[100],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFFEF4444)
                        : Colors.grey[300]!,
                  ),
                ),
                child: Text(
                  _reportTypes[index],
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : Colors.grey[700],
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildDescriptionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Descripción del incidente',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1F2937),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Describe lo que viste con el mayor detalle posible',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 15),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: _descriptionController,
            maxLines: 5,
            decoration: const InputDecoration(
              hintText: 'Describe el incidente...',
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLocationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ubicación',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1F2937),
          ),
        ),
        const SizedBox(height: 15),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: _locationController,
            decoration: const InputDecoration(
              hintText: 'Dirección o ubicación aproximada',
              prefixIcon: Icon(Icons.location_on),
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(16),
            ),
          ),
        ),
        const SizedBox(height: 10),
        TextButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.my_location, color: Color(0xFFEF4444)),
          label: const Text(
            'Usar mi ubicación actual',
            style: TextStyle(color: Color(0xFFEF4444)),
          ),
        ),
      ],
    );
  }

  Widget _buildContactSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Información de contacto',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1F2937),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Para poder dar seguimiento al caso',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 15),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: _contactController,
            decoration: const InputDecoration(
              hintText: 'Teléfono o email (opcional)',
              prefixIcon: Icon(Icons.contact_phone),
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOptionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Opciones',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1F2937),
          ),
        ),
        const SizedBox(height: 15),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[200]!),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              CheckboxListTile(
                title: const Text('Denuncia anónima'),
                subtitle: Text(
                  'No se mostrará tu información personal',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                value: _isAnonymous,
                onChanged: (value) {
                  setState(() {
                    _isAnonymous = value ?? false;
                  });
                },
                activeColor: const Color(0xFFEF4444),
              ),
              Divider(height: 1, color: Colors.grey[200]),
              CheckboxListTile(
                title: const Text('Caso urgente'),
                subtitle: Text(
                  'El animal está en peligro inmediato',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                value: _isUrgent,
                onChanged: (value) {
                  setState(() {
                    _isUrgent = value ?? false;
                  });
                },
                activeColor: const Color(0xFFEF4444),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPhotoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Evidencia fotográfica',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1F2937),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Las fotos ayudan a procesar el caso más rápido',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFEF4444)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                icon: const Icon(Icons.camera_alt, color: Color(0xFFEF4444)),
                label: const Text(
                  'Tomar foto',
                  style: TextStyle(color: Color(0xFFEF4444)),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFEF4444)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                icon: const Icon(Icons.photo_library, color: Color(0xFFEF4444)),
                label: const Text(
                  'Galería',
                  style: TextStyle(color: Color(0xFFEF4444)),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => _submitReport(),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFEF4444),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'Enviar Denuncia',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void _submitReport() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Denuncia Enviada'),
        content: const Text(
          'Tu denuncia ha sido enviada exitosamente. Recibirás una notificación cuando sea procesada.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¿Cómo hacer una denuncia?'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('1. Selecciona el tipo de maltrato'),
              SizedBox(height: 8),
              Text('2. Describe el incidente con detalle'),
              SizedBox(height: 8),
              Text('3. Proporciona la ubicación'),
              SizedBox(height: 8),
              Text('4. Adjunta fotos si es posible'),
              SizedBox(height: 8),
              Text('5. Envía tu denuncia'),
              SizedBox(height: 16),
              Text(
                'Recuerda: Si es una emergencia, llama inmediatamente al 911.',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Entendido'),
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
