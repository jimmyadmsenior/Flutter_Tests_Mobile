import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:async';
import 'dart:math';

/// Controller responsável por gerenciar dados do acelerômetro e giroscópio
/// 
/// Este controller fornece acesso aos sensores de movimento do dispositivo,
/// processando dados de aceleração e rotação em tempo real.
class AccelerometerController extends ChangeNotifier {
  // ===== SEÇÃO: VARIÁVEIS DE ESTADO DOS SENSORES =====
  // Dados do acelerômetro - medem a aceleração linear nos três eixos
  double _x = 0.0, _y = 0.0, _z = 0.0;

  // Dados do giroscópio - medem a velocidade angular (rotação) nos três eixos
  double _gyroX = 0.0, _gyroY = 0.0, _gyroZ = 0.0;

  // Magnitude total da aceleração (força resultante de todos os eixos)
  double _magnitude = 0.0;

  // ===== SEÇÃO: GERENCIAMENTO DE STREAMS =====
  // Subscriptions para escutar os eventos dos sensores
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  StreamSubscription<GyroscopeEvent>? _gyroscopeSubscription;

  // Flag que indica se o monitoramento está ativo
  bool _isMonitoring = false;

  // ===== SEÇÃO: GETTERS PÚBLICOS =====
  // Permitem acesso aos dados dos sensores de forma segura (somente leitura)
  double get x => _x;
  double get y => _y;
  double get z => _z;
  double get gyroX => _gyroX;
  double get gyroY => _gyroY;
  double get gyroZ => _gyroZ;
  double get magnitude => _magnitude;
  bool get isMonitoring => _isMonitoring;

  // ===== SEÇÃO: CONTROLE DE MONITORAMENTO =====

  /// Inicia o monitoramento dos sensores
  /// 
  /// Estabelece conexões com acelerômetro e giroscópio.
  /// Cria subscriptions para escutar os eventos dos sensores em tempo real
  /// e atualiza as variáveis de estado conforme novos dados chegam.
  void startMonitoring() {
    _isMonitoring = true;
    notifyListeners();

    // Subscription do acelerômetro - detecta aceleração linear
    _accelerometerSubscription = accelerometerEventStream().listen((
      AccelerometerEvent event,
    ) {
      // Corrigir orientação dos eixos conforme padrão Android/iOS
      _x = event.x; // Horizontal (esquerda/direita)
      _y = -event.y; // Vertical (cima/baixo) - invertido para consistência
      _z = event.z; // Profundidade (frente/trás)

      // Calcula a magnitude total usando o teorema de Pitágoras 3D
      _magnitude = sqrt(_x * _x + _y * _y + _z * _z);
      notifyListeners();
    });

    // Subscription do giroscópio - detecta velocidade angular (rotação)
    _gyroscopeSubscription = gyroscopeEventStream().listen((
      GyroscopeEvent event,
    ) {
      // Corrigir orientação dos eixos do giroscópio
      _gyroX = event.x; // Pitch (rotação em torno do eixo X)
      _gyroY = -event.y; // Roll (rotação em torno do eixo Y) - invertido
      _gyroZ = event.z; // Yaw (rotação em torno do eixo Z)
      notifyListeners();
    });
  }

  /// Para o monitoramento dos sensores
  /// 
  /// Cancela as subscriptions ativas e atualiza o estado para indicar
  /// que o monitoramento foi interrompido.
  void stopMonitoring() {
    _isMonitoring = false;
    notifyListeners();
    _accelerometerSubscription?.cancel();
    _gyroscopeSubscription?.cancel();
  }

  // ===== SEÇÃO: LIMPEZA DE RECURSOS =====
  /// Método chamado quando o controller é destruído
  /// 
  /// Garante que todas as subscriptions sejam canceladas para evitar
  /// vazamentos de memória.
  @override
  void dispose() {
    _accelerometerSubscription?.cancel();
    _gyroscopeSubscription?.cancel();
    super.dispose();
  }
}
