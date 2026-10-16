import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );


  runApp(const VitexolApp());
}

class VitexolApp extends StatelessWidget {
  const VitexolApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'VITEXOL',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0A4D8C),
        ),
      ),
      home: const WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: const Color(0xFF0A4D8C),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Icon(
                  Icons.devices,
                  size: 65,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 28),
              const Text(
                'VITEXOL',
                style: TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0A4D8C),
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'La tecnología al alcance de tu mano',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17,
                  color: Color(0xFF556270),
                ),
              ),
              const SizedBox(height: 45),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: FilledButton(
                  onPressed: () {
                    Navigator .push (
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      )
                    );
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF0A4D8C),
                  ),
                  child: const Text(
                    'Iniciar sesión',
                    style: TextStyle(fontSize: 17),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'Crear una cuenta',
                    style: TextStyle(fontSize: 17),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final correoController = TextEditingController();
  final contrasenaController = TextEditingController();

  bool cargando = false;

  @override
  void dispose() {
    correoController.dispose();
    contrasenaController.dispose();
    super.dispose();
  }

  Future<void> _iniciarSesion() async {
    final correo = correoController.text.trim();
    final contrasena = contrasenaController.text.trim();

    if (correo.isEmpty || contrasena.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Completa el correo y la contraseña.'),
        ),
      );
      return;
    }

    setState(() {
      cargando = true;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: correo,
        password: contrasena,
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      String mensaje = 'No se pudo iniciar sesión.';

      if (e.code == 'invalid-credential' ||
          e.code == 'user-not-found' ||
          e.code == 'wrong-password') {
        mensaje = 'Correo o contraseña incorrectos.';
      } else if (e.code == 'invalid-email') {
        mensaje = 'El correo electrónico no es válido.';
      } else if (e.code == 'too-many-requests') {
        mensaje =
        'Demasiados intentos. Intenta nuevamente más tarde.';
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(mensaje),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Ocurrió un error al iniciar sesión.',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          cargando = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA),
      appBar: AppBar(
        title: const Text('Iniciar sesión'),
        backgroundColor: const Color(0xFFF4F7FA),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 35),
              const Icon(
                Icons.lock_outline,
                size: 75,
                color: Color(0xFF0A4D8C),
              ),
              const SizedBox(height: 24),
              const Text(
                'Bienvenido a VITEXOL',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0A4D8C),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Ingresa tus datos para continuar',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF556270),
                ),
              ),
              const SizedBox(height: 35),
              TextField(
                controller: correoController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Correo electrónico',
                  prefixIcon: Icon(Icons.email_outlined),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 18),
              TextField(
                controller: contrasenaController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Contraseña',
                  prefixIcon: Icon(Icons.lock_outline),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: null,
                  child: const Text(
                    '¿Olvidaste tu contraseña?',
                  ),
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                height: 55,
                child: FilledButton(
                  onPressed: cargando ? null : _iniciarSesion,
                  style: FilledButton.styleFrom(
                    backgroundColor:
                    const Color(0xFF0A4D8C),
                  ),
                  child: cargando
                      ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : const Text(
                    'Ingresar',
                    style: TextStyle(fontSize: 17),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nombreController = TextEditingController();
  final correoController = TextEditingController();
  final telefonoController = TextEditingController();
  final contrasenaController = TextEditingController();
  final confirmarContrasenaController = TextEditingController();

  bool cargando = false;

  @override
  void dispose() {
    nombreController.dispose();
    correoController.dispose();
    telefonoController.dispose();
    contrasenaController.dispose();
    confirmarContrasenaController.dispose();
    super.dispose();
  }

  Future<void> _registrarUsuario() async {
    final nombre = nombreController.text.trim();
    final correo = correoController.text.trim();
    final telefono = telefonoController.text.trim();
    final contrasena = contrasenaController.text.trim();
    final confirmarContrasena =
    confirmarContrasenaController.text.trim();

    if (nombre.isEmpty ||
        correo.isEmpty ||
        telefono.isEmpty ||
        contrasena.isEmpty ||
        confirmarContrasena.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Completa todos los campos.'),
        ),
      );
      return;
    }

    if (contrasena != confirmarContrasena) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Las contraseñas no coinciden.'),
        ),
      );
      return;
    }

    if (contrasena.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'La contraseña debe tener al menos 6 caracteres.',
          ),
        ),
      );
      return;
    }

    setState(() {
      cargando = true;
    });

    try {
      final credencial =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: correo,
        password: contrasena,
      );

      final usuario = credencial.user;

      if (usuario != null) {
        await usuario.updateDisplayName(nombre);

        await FirebaseFirestore.instance
            .collection('usuarios')
            .doc(usuario.uid)
            .set({
          'uid': usuario.uid,
          'nombre': nombre,
          'correo': correo,
          'telefono': telefono,
          'fechaRegistro': FieldValue.serverTimestamp(),
        });
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cuenta creada correctamente.'),
        ),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
            (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      String mensaje = 'No se pudo crear la cuenta.';

      if (e.code == 'email-already-in-use') {
        mensaje = 'Ya existe una cuenta con este correo.';
      } else if (e.code == 'invalid-email') {
        mensaje = 'El correo electrónico no es válido.';
      } else if (e.code == 'weak-password') {
        mensaje = 'La contraseña es demasiado débil.';
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(mensaje),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Ocurrió un error al registrar el usuario.',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          cargando = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA),
      appBar: AppBar(
        title: const Text('Crear una cuenta'),
        backgroundColor: const Color(0xFFF4F7FA),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 15),
              const Icon(
                Icons.person_add_alt_1_outlined,
                size: 75,
                color: Color(0xFF0A4D8C),
              ),
              const SizedBox(height: 20),
              const Text(
                'Únete a VITEXOL',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0A4D8C),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Completa tus datos para crear una cuenta',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF556270),
                ),
              ),
              const SizedBox(height: 30),

              TextField(
                controller: nombreController,
                decoration: const InputDecoration(
                  labelText: 'Nombre completo',
                  prefixIcon: Icon(Icons.person_outline),
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),

              TextField(
                controller: correoController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Correo electrónico',
                  prefixIcon: Icon(Icons.email_outlined),
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),

              TextField(
                controller: telefonoController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Número de teléfono',
                  prefixIcon: Icon(Icons.phone_outlined),
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),

              TextField(
                controller: contrasenaController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Contraseña',
                  prefixIcon: Icon(Icons.lock_outline),
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),

              TextField(
                controller: confirmarContrasenaController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Confirmar contraseña',
                  prefixIcon: Icon(Icons.lock_reset_outlined),
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 24),

              SizedBox(
                height: 55,
                child: FilledButton(
                  onPressed:
                  cargando ? null : _registrarUsuario,
                  style: FilledButton.styleFrom(
                    backgroundColor:
                    const Color(0xFF0A4D8C),
                  ),
                  child: cargando
                      ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : const Text(
                    'Registrarme',
                    style: TextStyle(fontSize: 17),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF0A4D8C),
        foregroundColor: Colors.white,
        title: const Text(
          'VITEXOL',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_outlined),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '¡Bienvenido!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0A4D8C),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                '¿Qué deseas realizar hoy?',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF556270),
                ),
              ),
              const SizedBox(height: 25),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: const [
                    ModuleCard(
                      icon: Icons.shopping_bag_outlined,
                      title: 'Productos',
                      description: 'Consulta nuestro catálogo',
                    ),
                    ModuleCard(
                      icon: Icons.build_outlined,
                      title: 'Reparaciones',
                      description: 'Solicita y da seguimiento',
                    ),
                    ModuleCard(
                      icon: Icons.calendar_month_outlined,
                      title: 'Citas',
                      description: 'Programa tu visita',
                    ),
                    ModuleCard(
                      icon: Icons.person_outline,
                      title: 'Mi perfil',
                      description: 'Consulta tus datos',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ModuleCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const ModuleCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          if (title == 'Productos') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ProductsScreen(),
              ),
            );
          } else if (title == 'Reparaciones') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const RepairsScreen(),
              ),
            );
          } else if (title == 'Citas') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AppointmentsScreen(),
              ),
            );
          }
          else if (title == 'Mi perfil') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ProfileScreen(),
              ),
            );
          }
        },


        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 45,
                color: const Color(0xFF0A4D8C),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0A4D8C),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF556270),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  Future<void> _agregarProducto(BuildContext context) async {
    final nombreController = TextEditingController();
    final descripcionController = TextEditingController();
    final precioController = TextEditingController();

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Agregar producto'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nombreController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre del producto',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descripcionController,
                  decoration: const InputDecoration(
                    labelText: 'Descripción',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: precioController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Precio',
                    prefixText: 'RD\$ ',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () async {
                final nombre = nombreController.text.trim();
                final descripcion = descripcionController.text.trim();
                final precio = double.tryParse(
                  precioController.text.trim().replaceAll(',', '.'),
                );

                if (nombre.isEmpty || precio == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Completa el nombre y coloca un precio válido.',
                      ),
                    ),
                  );
                  return;
                }

                await FirebaseFirestore.instance
                    .collection('productos')
                    .add({
                  'nombre': nombre,
                  'descripcion': descripcion,
                  'precio': precio,
                  'fechaRegistro': FieldValue.serverTimestamp(),
                });

                if (dialogContext.mounted) {
                  Navigator.pop(dialogContext);
                }

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Producto guardado correctamente.'),
                    ),
                  );
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A4D8C),
        foregroundColor: Colors.white,
        title: const Text('Productos'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('productos')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Ocurrió un error al cargar los productos.'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final productos = snapshot.data?.docs ?? [];

          if (productos.isEmpty) {
            return const Center(
              child: Text(
                'Todavía no hay productos registrados.',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: productos.length,
            itemBuilder: (context, index) {
              final producto =
              productos[index].data() as Map<String, dynamic>;

              final nombre = producto['nombre'] ?? '';
              final descripcion = producto['descripcion'] ?? '';
              final precio = producto['precio'] ?? 0;

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFF0A4D8C),
                    foregroundColor: Colors.white,
                    child: Icon(Icons.shopping_bag_outlined),
                  ),
                  title: Text(
                    nombre,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(descripcion),
                  trailing: Text(
                    'RD\$ ${precio.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0A4D8C),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _agregarProducto(context),
        backgroundColor: const Color(0xFF0A4D8C),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Agregar producto'),
      ),
    );
  }
}

class RepairsScreen extends StatelessWidget {
  const RepairsScreen({super.key});

  Future<void> _agregarReparacion(BuildContext context) async {
    final clienteController = TextEditingController();
    final equipoController = TextEditingController();
    final problemaController = TextEditingController();

    String estadoSeleccionado = 'Recibido';

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Registrar reparación'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: clienteController,
                      decoration: const InputDecoration(
                        labelText: 'Nombre del cliente',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: equipoController,
                      decoration: const InputDecoration(
                        labelText: 'Equipo',
                        hintText: 'Ej. Samsung Galaxy S24',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: problemaController,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        labelText: 'Problema del equipo',
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: estadoSeleccionado,
                      decoration: const InputDecoration(
                        labelText: 'Estado',
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'Recibido',
                          child: Text('Recibido'),
                        ),
                        DropdownMenuItem(
                          value: 'En reparación',
                          child: Text('En reparación'),
                        ),
                        DropdownMenuItem(
                          value: 'Completado',
                          child: Text('Completado'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            estadoSeleccionado = value;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                  },
                  child: const Text('Cancelar'),
                ),
                FilledButton(
                  onPressed: () async {
                    final cliente = clienteController.text.trim();
                    final equipo = equipoController.text.trim();
                    final problema = problemaController.text.trim();

                    if (cliente.isEmpty ||
                        equipo.isEmpty ||
                        problema.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Completa todos los campos.',
                          ),
                        ),
                      );
                      return;
                    }

                    await FirebaseFirestore.instance
                        .collection('reparaciones')
                        .add({
                      'cliente': cliente,
                      'equipo': equipo,
                      'problema': problema,
                      'estado': estadoSeleccionado,
                      'fechaRegistro': FieldValue.serverTimestamp(),
                    });

                    if (dialogContext.mounted) {
                      Navigator.pop(dialogContext);
                    }

                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Reparación registrada correctamente.',
                          ),
                        ),
                      );
                    }
                  },
                  child: const Text('Guardar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A4D8C),
        foregroundColor: Colors.white,
        title: const Text('Reparaciones'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('reparaciones')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Ocurrió un error al cargar las reparaciones.',
              ),
            );
          }

          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final reparaciones = snapshot.data?.docs ?? [];

          if (reparaciones.isEmpty) {
            return const Center(
              child: Text(
                'Todavía no hay reparaciones registradas.',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: reparaciones.length,
            itemBuilder: (context, index) {
              final reparacion =
              reparaciones[index].data()
              as Map<String, dynamic>;

              final cliente = reparacion['cliente'] ?? '';
              final equipo = reparacion['equipo'] ?? '';
              final problema = reparacion['problema'] ?? '';
              final estado = reparacion['estado'] ?? '';

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFF0A4D8C),
                    foregroundColor: Colors.white,
                    child: Icon(Icons.build_outlined),
                  ),
                  title: Text(
                    equipo,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    '$cliente\n$problema',
                  ),
                  isThreeLine: true,
                  trailing: Text(
                    estado,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0A4D8C),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _agregarReparacion(context),
        backgroundColor: const Color(0xFF0A4D8C),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Registrar reparación'),
      ),
    );
  }
}

class AppointmentsScreen extends StatelessWidget {
  const AppointmentsScreen({super.key});

  Future<void> _agregarCita(BuildContext context) async {
    final clienteController = TextEditingController();
    final servicioController = TextEditingController();

    DateTime? fechaSeleccionada;
    TimeOfDay? horaSeleccionada;

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Programar cita'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: clienteController,
                      decoration: const InputDecoration(
                        labelText: 'Nombre del cliente',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: servicioController,
                      decoration: const InputDecoration(
                        labelText: 'Servicio',
                        hintText: 'Ej. Revisión de equipo',
                      ),
                    ),
                    const SizedBox(height: 16),

                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.calendar_month),
                      title: Text(
                        fechaSeleccionada == null
                            ? 'Seleccionar fecha'
                            : '${fechaSeleccionada!.day}/${fechaSeleccionada!.month}/${fechaSeleccionada!.year}',
                      ),
                      onTap: () async {
                        final fecha = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(
                            const Duration(days: 365),
                          ),
                        );

                        if (fecha != null) {
                          setState(() {
                            fechaSeleccionada = fecha;
                          });
                        }
                      },
                    ),

                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.access_time),
                      title: Text(
                        horaSeleccionada == null
                            ? 'Seleccionar hora'
                            : horaSeleccionada!.format(context),
                      ),
                      onTap: () async {
                        final hora = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );

                        if (hora != null) {
                          setState(() {
                            horaSeleccionada = hora;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                  },
                  child: const Text('Cancelar'),
                ),
                FilledButton(
                  onPressed: () async {
                    final cliente = clienteController.text.trim();
                    final servicio = servicioController.text.trim();

                    if (cliente.isEmpty ||
                        servicio.isEmpty ||
                        fechaSeleccionada == null ||
                        horaSeleccionada == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Completa todos los datos de la cita.',
                          ),
                        ),
                      );
                      return;
                    }

                    final fechaCita = DateTime(
                      fechaSeleccionada!.year,
                      fechaSeleccionada!.month,
                      fechaSeleccionada!.day,
                      horaSeleccionada!.hour,
                      horaSeleccionada!.minute,
                    );

                    await FirebaseFirestore.instance
                        .collection('citas')
                        .add({
                      'cliente': cliente,
                      'servicio': servicio,
                      'fechaCita': Timestamp.fromDate(fechaCita),
                      'estado': 'Programada',
                      'fechaRegistro': FieldValue.serverTimestamp(),
                    });

                    if (dialogContext.mounted) {
                      Navigator.pop(dialogContext);
                    }

                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Cita registrada correctamente.',
                          ),
                        ),
                      );
                    }
                  },
                  child: const Text('Guardar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A4D8C),
        foregroundColor: Colors.white,
        title: const Text('Citas'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('citas')
            .orderBy('fechaCita')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Ocurrió un error al cargar las citas.',
              ),
            );
          }

          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final citas = snapshot.data?.docs ?? [];

          if (citas.isEmpty) {
            return const Center(
              child: Text(
                'Todavía no hay citas programadas.',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: citas.length,
            itemBuilder: (context, index) {
              final cita =
              citas[index].data() as Map<String, dynamic>;

              final cliente = cita['cliente'] ?? '';
              final servicio = cita['servicio'] ?? '';
              final estado = cita['estado'] ?? '';

              final timestamp = cita['fechaCita'] as Timestamp?;
              final fecha = timestamp?.toDate();

              final fechaTexto = fecha == null
                  ? ''
                  : '${fecha.day}/${fecha.month}/${fecha.year} '
                  '${fecha.hour.toString().padLeft(2, '0')}:'
                  '${fecha.minute.toString().padLeft(2, '0')}';

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFF0A4D8C),
                    foregroundColor: Colors.white,
                    child: Icon(Icons.calendar_month_outlined),
                  ),
                  title: Text(
                    servicio,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    '$cliente\n$fechaTexto',
                  ),
                  isThreeLine: true,
                  trailing: Text(
                    estado,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0A4D8C),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _agregarCita(context),
        backgroundColor: const Color(0xFF0A4D8C),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Programar cita'),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<Map<String, dynamic>?> _obtenerDatosUsuario() async {
    final usuario = FirebaseAuth.instance.currentUser;

    if (usuario == null) {
      return null;
    }

    final documento = await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(usuario.uid)
        .get();

    if (!documento.exists) {
      return null;
    }

    return documento.data();
  }

  Future<void> _cerrarSesion(BuildContext context) async {
    await FirebaseAuth.instance.signOut();

    if (!context.mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const WelcomeScreen(),
      ),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A4D8C),
        foregroundColor: Colors.white,
        title: const Text('Mi perfil'),
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _obtenerDatosUsuario(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError || snapshot.data == null) {
            return const Center(
              child: Text(
                'No se pudieron cargar los datos del usuario.',
              ),
            );
          }

          final datos = snapshot.data!;

          final nombre = datos['nombre'] ?? '';
          final correo = datos['correo'] ?? '';
          final telefono = datos['telefono'] ?? '';

          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),

                const CircleAvatar(
                  radius: 50,
                  backgroundColor: Color(0xFF0A4D8C),
                  foregroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: 60,
                  ),
                ),

                const SizedBox(height: 20),

                Text(
                  nombre,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0A4D8C),
                  ),
                ),

                const SizedBox(height: 30),

                Card(
                  child: ListTile(
                    leading: const Icon(
                      Icons.email_outlined,
                      color: Color(0xFF0A4D8C),
                    ),
                    title: const Text('Correo electrónico'),
                    subtitle: Text(correo),
                  ),
                ),

                const SizedBox(height: 12),

                Card(
                  child: ListTile(
                    leading: const Icon(
                      Icons.phone_outlined,
                      color: Color(0xFF0A4D8C),
                    ),
                    title: const Text('Teléfono'),
                    subtitle: Text(telefono),
                  ),
                ),

                const Spacer(),

                SizedBox(
                  height: 55,
                  child: OutlinedButton.icon(
                    onPressed: () => _cerrarSesion(context),
                    icon: const Icon(Icons.logout),
                    label: const Text(
                      'Cerrar sesión',
                      style: TextStyle(fontSize: 17),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}