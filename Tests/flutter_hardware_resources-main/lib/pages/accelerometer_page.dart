import 'package:flutter/material.dart';
import '../controllers/accelerometer_controller.dart';

class AccelerometerPage extends StatefulWidget {
  const AccelerometerPage({super.key});

  @override
  State<AccelerometerPage> createState() => _AccelerometerPageState();
}

class _AccelerometerPageState extends State<AccelerometerPage> {
  late AccelerometerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AccelerometerController();
    _controller.addListener(_onControllerUpdate);
  }

  void _onControllerUpdate() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerUpdate);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Acelerômetro & Giroscópio'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Controle dos Sensores',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: _controller.isMonitoring
                              ? _controller.stopMonitoring
                              : _controller.startMonitoring,
                          icon: Icon(
                            _controller.isMonitoring
                                ? Icons.stop
                                : Icons.play_arrow,
                          ),
                          label: Text(
                            _controller.isMonitoring
                                ? 'Parar Monitoramento'
                                : 'Iniciar Monitoramento',
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _controller.isMonitoring
                                ? Colors.red
                                : Colors.green,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Acelerômetro',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 12),
                      _buildSensorRow(
                        'Eixo X (Horizontal):',
                        _controller.x,
                        Colors.red,
                      ),
                      _buildSensorRow(
                        'Eixo Y (Vertical):',
                        _controller.y,
                        Colors.green,
                      ),
                      _buildSensorRow(
                        'Eixo Z (Profundidade):',
                        _controller.z,
                        Colors.blue,
                      ),
                      const SizedBox(height: 8),
                      _buildInfoRow(
                        'Magnitude:',
                        '${_controller.magnitude.toStringAsFixed(2)} m/s²',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Giroscópio',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 12),
                      _buildSensorRow(
                        'Rotação X (Pitch):',
                        _controller.gyroX,
                        Colors.red,
                      ),
                      _buildSensorRow(
                        'Rotação Y (Roll):',
                        _controller.gyroY,
                        Colors.green,
                      ),
                      _buildSensorRow(
                        'Rotação Z (Yaw):',
                        _controller.gyroZ,
                        Colors.blue,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Visualização',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 12),
                      Center(
                        child: Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: CustomPaint(
                            painter: AccelerometerPainter(
                              _controller.x,
                              _controller.y,
                              _controller.z,
                            ),
                            size: const Size(200, 200),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Orientação dos Eixos',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        '📱 Acelerômetro:\n'
                        '• X (Horizontal): Esquerda (-) / Direita (+)\n'
                        '• Y (Vertical): Baixo (-) / Cima (+)\n'
                        '• Z (Profundidade): Trás (-) / Frente (+)\n\n'
                        '🔄 Giroscópio:\n'
                        '• X (Pitch): Inclinar para baixo (-) / cima (+)\n'
                        '• Y (Roll): Inclinar para esquerda (-) / direita (+)\n'
                        '• Z (Yaw): Girar anti-horário (-) / horário (+)\n\n'
                        '⚡ Valores em m/s² (acelerômetro) e rad/s (giroscópio)',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSensorRow(String label, double value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: LinearProgressIndicator(
              value: (value + 10) / 20, // Normalizar para 0-1
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 60,
            child: Text(
              value.toStringAsFixed(2),
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          Text(value),
        ],
      ),
    );
  }
}

class AccelerometerPainter extends CustomPainter {
  final double x, y, z;

  AccelerometerPainter(this.x, this.y, this.z);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.purple
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);

    // Desenhar círculo base
    canvas.drawCircle(center, size.width / 2 - 10, paint);

    // Desenhar eixos de referência
    final axisPaint = Paint()
      ..color = Colors.grey.withAlpha(5)
      ..strokeWidth = 1;

    // Eixo X (horizontal)
    canvas.drawLine(
      Offset(10, center.dy),
      Offset(size.width - 10, center.dy),
      axisPaint,
    );

    // Eixo Y (vertical)
    canvas.drawLine(
      Offset(center.dx, 10),
      Offset(center.dx, size.height - 10),
      axisPaint,
    );

    // Desenhar labels dos eixos
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    // Label X+
    textPainter.text = const TextSpan(
      text: 'X+',
      style: TextStyle(color: Colors.grey, fontSize: 12),
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(size.width - 25, center.dy - 15));

    // Label Y+
    textPainter.text = const TextSpan(
      text: 'Y+',
      style: TextStyle(color: Colors.grey, fontSize: 12),
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(center.dx + 5, 5));

    // Desenhar ponto baseado na aceleração
    // X: direita (+) / esquerda (-)
    // Y: cima (+) / baixo (-) - sistema de coordenadas canvas
    final pointX = center.dx + (x * 8); // Aumentar sensibilidade
    final pointY = center.dy + (y * 8); // Y normal (sem inversão dupla)

    final pointPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(pointX, pointY), 8, pointPaint);

    // Desenhar linha do centro ao ponto
    final linePaint = Paint()
      ..color = Colors.purple
      ..strokeWidth = 2;

    canvas.drawLine(center, Offset(pointX, pointY), linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
