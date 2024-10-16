import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Para abrir el enlace de GitHub

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // Función para abrir la URL de GitHub
  Future<void> _launchGitHub() async {
    final Uri url =
        Uri.parse('https://github.com/marco014');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'No se pudo abrir el enlace $url';
    }
  }

  @override
  Widget build(BuildContext context) {
  // Definir una paleta de colores agradables y elegantes
  const Color pastelPurple = Color(0xFFE1BEE7);
  const Color pastelPink = Color.fromARGB(255, 0, 151, 252);
  const Color accentGreen = Color.fromRGBO(0, 174, 255, 1);
  const Color lightBackground = Color(0xFFF2F4F8); // Fondo claro
  const Color whiteColor = Colors.white;
  const Color textColor = Color(0xFF333333); // Color de texto amigable
  
  return Scaffold(
    backgroundColor: lightBackground,
    body: Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo centrado con borde pastel
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: pastelPurple,
                  width: 3,
                ),
              ),
              child: ClipOval(
                child: Image.asset(
                  'asset/img/uplogo.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 25),
            // Nombre destacado
            const Text(
              'Marco Ortiz',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textColor,
                fontSize: 26,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.6,
              ),
            ),
            const SizedBox(height: 15),
            // Información adicional
            const Text(
              'Ingeniería en Desarrollo de Software',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textColor,
                fontSize: 18,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              'Programación para Móviles',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: pastelPink,
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              '221213  -  9°A',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textColor,
                fontSize: 16,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(height: 35),
            // Botón estilizado con fondo de color suave
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/chatbot');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: accentGreen, // Fondo verde pastel suave
                padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0),
                ),
                elevation: 3, // Ligera sombra para dar profundidad
              ),
              child: const Text(
                'Iniciar ChatBot',
                style: TextStyle(
                  color: whiteColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 30),
            // Enlace estilizado a GitHub con el mismo estilo que el botón
            ElevatedButton.icon(
              onPressed: _launchGitHub,
              icon: const Icon(
                Icons.link,
                color: whiteColor,
                size: 20,
              ),
              label: const Text(
                'Ver repositorio en GitHub',
                style: TextStyle(
                  color: whiteColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF03DAC6), // Color verde-azul claro
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0),
                ),
                elevation: 3, // Ligera sombra
              ),
            ),
          ],
        ),
      ),
    ),
  );
}





}
