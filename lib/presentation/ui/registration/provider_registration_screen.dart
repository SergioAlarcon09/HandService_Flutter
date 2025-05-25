import 'package:flutter/material.dart';

class ProviderRegistrationScreen extends StatefulWidget {
  const ProviderRegistrationScreen({super.key});

  @override
  State<ProviderRegistrationScreen> createState() =>
      _ProviderRegistrationScreenState();
}

class _ProviderRegistrationScreenState
    extends State<ProviderRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _documentController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _professionController = TextEditingController();
  final _titleController = TextEditingController();
  final _passwordController = TextEditingController();

  String? _selectedGender;
  List<String> _selectedServiceTypes = [];

  final List<String> _serviceTypes = ['Hogar', 'Vehículos', 'Ocio'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de Prestador'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'REGISTRO DE PRESTADOR',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),

              // Nombre
              _buildTextField(
                controller: _firstNameController,
                label: 'Nombre',
                icon: Icons.person,
                validator: (value) =>
                    value!.isEmpty ? 'Ingrese su nombre' : null,
              ),

              // Apellido
              _buildTextField(
                controller: _lastNameController,
                label: 'Apellido',
                icon: Icons.person_outline,
                validator: (value) =>
                    value!.isEmpty ? 'Ingrese su apellido' : null,
              ),

              // Documento
              _buildTextField(
                controller: _documentController,
                label: 'Número de documento',
                icon: Icons.credit_card,
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Ingrese su documento' : null,
              ),

              // Email
              _buildTextField(
                controller: _emailController,
                label: 'Email',
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                validator: (value) =>
                    !value!.contains('@') ? 'Email inválido' : null,
              ),

              // Teléfono
              _buildTextField(
                controller: _phoneController,
                label: 'Teléfono',
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
                validator: (value) =>
                    value!.isEmpty ? 'Ingrese su teléfono' : null,
              ),

              // Sexo
              const Text(
                'Sexo',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              Row(
                children: ['M', 'F', 'O'].map((gender) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: _selectedGender == gender
                              ? Colors.orange.withOpacity(0.2)
                              : null,
                          side: BorderSide(
                            color: _selectedGender == gender
                                ? Colors.orange
                                : Colors.grey,
                          ),
                        ),
                        onPressed: () =>
                            setState(() => _selectedGender = gender),
                        child: Text(gender),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              // Profesión
              _buildTextField(
                controller: _professionController,
                label: 'Profesión',
                icon: Icons.work,
                validator: (value) =>
                    value!.isEmpty ? 'Ingrese su profesión' : null,
              ),

              // Título
              _buildTextField(
                controller: _titleController,
                label: 'Título que ostenta',
                icon: Icons.school,
                validator: (value) =>
                    value!.isEmpty ? 'Ingrese su título' : null,
              ),

              // Tipo de servicio
              const Text(
                'Qué tipo de servicio ofrece',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _serviceTypes.map((service) {
                  return FilterChip(
                    label: Text(service),
                    selected: _selectedServiceTypes.contains(service),
                    selectedColor: Colors.orange.withOpacity(0.2),
                    checkmarkColor: Colors.orange,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedServiceTypes.add(service);
                        } else {
                          _selectedServiceTypes.remove(service);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              // Contraseña
              _buildTextField(
                controller: _passwordController,
                label: 'Contraseña',
                icon: Icons.lock,
                obscureText: true,
                validator: (value) =>
                    value!.length < 6 ? 'Mínimo 6 caracteres' : null,
              ),
              const SizedBox(height: 30),

              // Botón de Registro
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('REGISTRAR'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscureText = false,
    required String? Function(String?) validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          prefixIcon: Icon(icon, color: Colors.orange),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.orange),
          ),
        ),
        keyboardType: keyboardType,
        obscureText: obscureText,
        validator: validator,
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() &&
        _selectedGender != null &&
        _selectedServiceTypes.isNotEmpty) {
      // Procesar registro
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registro exitoso'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Complete todos los campos requeridos'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _documentController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _professionController.dispose();
    _titleController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
