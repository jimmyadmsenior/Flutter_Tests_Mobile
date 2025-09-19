import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:async';
import 'dart:math';

/// Controller responsável por detectar e analisar rotações do dispositivo
/// 
/// Este controller utiliza dados do giroscópio para detectar movimentos
/// rotacionais, calcular orientação e implementar estabilização visual.
class RotationDetectorController extends ChangeNotifier {
  // ===== SEÇÃO: DADOS DO GIROSCÓPIO =====
  // Velocidades angulares nos três eixos (rad/s)
  double _gyroX = 0.0, _gyroY = 0.0, _gyroZ = 0.0;
  
  // Subscription para escutar eventos do giroscópio
  StreamSubscription<GyroscopeEvent>? _gyroscopeSubscription;
  
  // Flag indicando se o monitoramento está ativo
  bool _isMonitoring = false;

  // ===== SEÇÃO: DETECTOR DE ROTAÇÃO =====
  // Flag indicando se há rotação detectada
  bool _isRotating = false;
  
  // Limite de velocidade angular para considerar rotação
  double _rotationThreshold = 0.5;
  
  // Direção principal da rotação detectada
  String _rotationDirection = 'Parado';

  // ===== SEÇÃO: ORIENTAÇÃO DO DISPOSITIVO =====
  // Ângulos de orientação em graus (integrados do giroscópio)
  double _pitch = 0.0; // Rotação em X (inclinar para frente/trás)
  double _roll = 0.0;  // Rotação em Y (inclinar para esquerda/direita)
  double _yaw = 0.0;   // Rotação em Z (girar no plano horizontal)

  // ===== SEÇÃO: ESTATÍSTICAS DE ROTAÇÃO =====
  // Contador de rotações significativas detectadas
  int _rotationCount = 0;
  
  // Somatório total de rotação acumulada
  double _totalRotation = 0.0;

  // ===== SEÇÃO: ESTABILIZADOR VISUAL =====
  // Coordenadas compensadas para estabilização visual
  double _stabilizedX = 0.0;
  double _stabilizedY = 0.0;
  
  // Flag para ativar/desativar estabilização
  bool _stabilizerEnabled = false;

  // ===== SEÇÃO: GETTERS PÚBLICOS =====
  // Permitem acesso seguro aos dados internos do controller
  double get gyroX => _gyroX;
  double get gyroY => _gyroY;
  double get gyroZ => _gyroZ;
  bool get isMonitoring => _isMonitoring;
  bool get isRotating => _isRotating;
  String get rotationDirection => _rotationDirection;
  double get pitch => _pitch;
  double get roll => _roll;
  double get yaw => _yaw;
  int get rotationCount => _rotationCount;
  double get totalRotation => _totalRotation;
  double get rotationThreshold => _rotationThreshold;
  double get stabilizedX => _stabilizedX;
  double get stabilizedY => _stabilizedY;
  bool get stabilizerEnabled => _stabilizerEnabled;

  // ===== SEÇÃO: CONFIGURAÇÃO DE PARÂMETROS =====
  /// Define o limite de sensibilidade para detecção de rotação
  /// 
  /// Valores menores detectam rotações mais sutis,
  /// valores maiores requerem rotações mais intensas.
  void setRotationThreshold(double threshold) {
    _rotationThreshold = threshold;
    notifyListeners();
  }

  /// Reseta as estatísticas de rotação
  /// 
  /// Zera o contador de rotações e o total acumulado,
  /// útil para reiniciar o monitoramento.
  void resetRotationCount() {
    _rotationCount = 0;
    _totalRotation = 0.0;
    notifyListeners();
  }

  /// Alterna o estado do estabilizador visual
  /// 
  /// Ativa ou desativa a compensação de rotação para
  /// estabilização visual de elementos da interface.
  void toggleStabilizer() {
    _stabilizerEnabled = !_stabilizerEnabled;
    if (!_stabilizerEnabled) {
      _stabilizedX = 0.0;
      _stabilizedY = 0.0;
    }
    notifyListeners();
  }

  // ===== SEÇÃO: CONTROLE DE MONITORAMENTO =====
  /// Inicia o monitoramento de rotação
  /// 
  /// Configura o listener do giroscópio e inicia a análise
  /// em tempo real dos dados para detectar rotações e calcular orientação.
  void startMonitoring() {
    _isMonitoring = true;
    notifyListeners();

    // Configurar listener do giroscópio
    _gyroscopeSubscription = gyroscopeEventStream().listen((
      GyroscopeEvent event,
    ) {
      // Capturar velocidades angulares dos três eixos
      _gyroX = event.x;  // Pitch (rotação em torno do eixo X)
      _gyroY = -event.y; // Roll (rotação em torno do eixo Y) - invertido
      _gyroZ = event.z;  // Yaw (rotação em torno do eixo Z)

      // Executar análises de rotação
      _detectRotation();
      _updateOrientation();
      _updateStabilizer();

      notifyListeners();
    });
  }

  // ===== SEÇÃO: ALGORITMOS DE DETECÇÃO =====
  /// Detecta rotação baseada na magnitude das velocidades angulares
  /// 
  /// Calcula a magnitude total da rotação e determina a direção
  /// principal do movimento rotacional.
  void _detectRotation() {
    // Calcular magnitude total da rotação (velocidade angular resultante)
    double rotationMagnitude = sqrt(
      _gyroX * _gyroX + _gyroY * _gyroY + _gyroZ * _gyroZ,
    );

    // Verificar se excede o limite configurado
    _isRotating = rotationMagnitude > _rotationThreshold;

    if (_isRotating) {
      // Determinar qual eixo tem a maior rotação
      double maxRotation = [
        _gyroX.abs(),
        _gyroY.abs(),
        _gyroZ.abs(),
      ].reduce(max);

      // Identificar direção baseada no eixo dominante
      if (maxRotation == _gyroX.abs()) {
        _rotationDirection = _gyroX > 0
            ? 'Inclinando para baixo'
            : 'Inclinando para cima';
      } else if (maxRotation == _gyroY.abs()) {
        _rotationDirection = _gyroY > 0
            ? 'Inclinando para direita'
            : 'Inclinando para esquerda';
      } else {
        _rotationDirection = _gyroZ > 0
            ? 'Girando horário'
            : 'Girando anti-horário';
      }

      // Contar apenas rotações significativas (2x o threshold)
      if (rotationMagnitude > _rotationThreshold * 2) {
        _rotationCount++;
        _totalRotation += rotationMagnitude;
      }
    } else {
      _rotationDirection = 'Parado';
    }
  }

  /// Atualiza a orientação do dispositivo por integração
  /// 
  /// Integra as velocidades angulares ao longo do tempo para
  /// estimar a orientação atual do dispositivo em graus.
  void _updateOrientation() {
    // Aproximação do intervalo de tempo entre leituras
    double dt = 0.1; // 100ms (aproximado)

    // Integrar velocidades angulares para obter ângulos
    _pitch += _gyroX * dt * 180 / pi; // Converter rad/s para graus
    _roll += _gyroY * dt * 180 / pi;
    _yaw += _gyroZ * dt * 180 / pi;

    // Normalizar ângulos para mantê-los no range -180 a 180
    _pitch = _normalizeAngle(_pitch);
    _roll = _normalizeAngle(_roll);
    _yaw = _normalizeAngle(_yaw);
  }

  /// Atualiza os valores do estabilizador visual
  /// 
  /// Calcula compensações baseadas na orientação para
  /// estabilizar elementos visuais na interface.
  void _updateStabilizer() {
    if (_stabilizerEnabled) {
      // Calcular compensações inversas à rotação
      _stabilizedX = -_roll * 2;  // Compensar inclinação lateral
      _stabilizedY = -_pitch * 2; // Compensar inclinação frontal
      
      // Em uma aplicação real, estes valores seriam usados
      // para estabilizar câmera, UI ou outros elementos visuais
    }
  }

  // ===== SEÇÃO: UTILITÁRIOS MATEMÁTICOS =====
  /// Normaliza um ângulo para o range -180 a 180 graus
  /// 
  /// Garante que os ângulos permaneçam dentro de um range
  /// padrão para facilitar cálculos e exibição.
  double _normalizeAngle(double angle) {
    // Reduzir ângulos maiores que 180
    while (angle > 180) {
      angle -= 360;
    }
    // Aumentar ângulos menores que -180
    while (angle < -180) {
      angle += 360;
    }
    return angle;
  }

  /// Reseta a orientação para valores padrão
  /// 
  /// Zera todos os ângulos de orientação e valores de estabilização,
  /// útil para recalibrar o sistema.
  void resetOrientation() {
    _pitch = 0.0;
    _roll = 0.0;
    _yaw = 0.0;
    _stabilizedX = 0.0;
    _stabilizedY = 0.0;
    notifyListeners();
  }

  /// Para o monitoramento de rotação
  /// 
  /// Cancela o listener do giroscópio e reseta estados
  /// de detecção para valores padrão.
  void stopMonitoring() {
    _isMonitoring = false;
    _isRotating = false;
    _rotationDirection = 'Parado';
    notifyListeners();
    _gyroscopeSubscription?.cancel();
  }

  // ===== SEÇÃO: LIMPEZA DE RECURSOS =====
  /// Método chamado quando o controller é destruído
  /// 
  /// Garante que a subscription seja cancelada para evitar
  /// vazamentos de memória.
  @override
  void dispose() {
    _gyroscopeSubscription?.cancel();
    super.dispose();
  }
}
