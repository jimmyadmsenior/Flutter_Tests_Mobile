import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:async';
import 'dart:math';

/// Controller responsável por detectar diferentes tipos de movimento
/// 
/// Este controller analisa dados do acelerômetro para detectar movimento,
/// vibração e inclinção, funcionando como um detector de movimento avançado.
class MotionDetectorController extends ChangeNotifier {
  // ===== SEÇÃO: DADOS BÁSICOS DO ACELERÔMETRO =====
  // Coordenadas atuais de aceleração nos três eixos
  double _x = 0.0, _y = 0.0, _z = 0.0;
  
  // Magnitude atual e anterior para detectar mudanças
  double _magnitude = 0.0;
  double _previousMagnitude = 0.0;
  
  // Subscription para escutar eventos do acelerômetro
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  
  // Flag indicando se o monitoramento está ativo
  bool _isMonitoring = false;

  // ===== SEÇÃO: DETECTOR DE MOVIMENTO =====
  // Flag indicando se há movimento detectado
  bool _isMoving = false;
  
  // Limite de mudança na magnitude para considerar movimento
  double _movementThreshold = 2.0;
  
  // Contador de movimentos detectados
  int _movementCount = 0;

  // ===== SEÇÃO: DETECTOR DE VIBRAÇÃO =====
  // Flag indicando se há vibração detectada
  bool _isVibrating = false;
  
  // Limite de variação para considerar vibração
  double _vibrationThreshold = 15.0;
  
  // Histórico das últimas leituras para análise de variação
  final List<double> _recentMagnitudes = [];

  // ===== SEÇÃO: NÍVEL DIGITAL (BOLHA DE NÍVEL) =====
  // Inclinação nos eixos X e Y em graus
  double _tiltX = 0.0;
  double _tiltY = 0.0;
  
  // Flag indicando se o dispositivo está nivelado
  bool _isLevel = false;
  
  // Limite de inclinação para considerar nivelado
  final double _levelThreshold = 1.0;

  // ===== SEÇÃO: GETTERS PÚBLICOS =====
  // Permitem acesso seguro aos dados internos do controller
  double get x => _x;
  double get y => _y;
  double get z => _z;
  double get magnitude => _magnitude;
  bool get isMonitoring => _isMonitoring;
  bool get isMoving => _isMoving;
  bool get isVibrating => _isVibrating;
  int get movementCount => _movementCount;
  double get tiltX => _tiltX;
  double get tiltY => _tiltY;
  bool get isLevel => _isLevel;
  double get movementThreshold => _movementThreshold;
  double get vibrationThreshold => _vibrationThreshold;

  // ===== SEÇÃO: CONFIGURAÇÃO DE PARÂMETROS =====
  /// Define o limite de sensibilidade para detecção de movimento
  /// 
  /// Valores menores detectam movimentos mais sutis,
  /// valores maiores requerem movimentos mais intensos.
  void setMovementThreshold(double threshold) {
    _movementThreshold = threshold;
    notifyListeners();
  }

  /// Define o limite de sensibilidade para detecção de vibração
  /// 
  /// Valores menores detectam vibrações mais sutis,
  /// valores maiores requerem vibrações mais intensas.
  void setVibrationThreshold(double threshold) {
    _vibrationThreshold = threshold;
    notifyListeners();
  }

  /// Reseta o contador de movimentos detectados
  /// 
  /// Útil para reiniciar a contagem de movimentos
  /// após um período de monitoramento.
  void resetMovementCount() {
    _movementCount = 0;
    notifyListeners();
  }

  // ===== SEÇÃO: CONTROLE DE MONITORAMENTO =====
  /// Inicia o monitoramento de movimento e vibração
  /// 
  /// Configura o listener do acelerômetro e inicia a análise
  /// em tempo real dos dados para detectar diferentes tipos de movimento.
  void startMonitoring() {
    _isMonitoring = true;
    notifyListeners();

    // Configurar listener do acelerômetro
    _accelerometerSubscription = accelerometerEventStream().listen((
      AccelerometerEvent event,
    ) {
      // Capturar dados dos três eixos
      _x = event.x;
      _y = -event.y; // Invertido para corresponder à orientação da tela
      _z = event.z;
      
      // Calcular magnitude total da aceleração
      _magnitude = sqrt(_x * _x + _y * _y + _z * _z);

      // Executar análises de detecção
      _detectMovement();
      _detectVibration();
      _calculateTilt();

      // Salvar magnitude anterior para próxima comparação
      _previousMagnitude = _magnitude;
      notifyListeners();
    });
  }

  // ===== SEÇÃO: ALGORITMOS DE DETECÇÃO =====
  /// Detecta movimento baseado na variação da magnitude
  /// 
  /// Compara a magnitude atual com a anterior e determina
  /// se houve movimento significativo baseado no threshold.
  void _detectMovement() {
    // Calcular a diferença absoluta entre magnitudes
    double magnitudeChange = (_magnitude - _previousMagnitude).abs();

    // Verificar se a mudança excede o limite configurado
    if (magnitudeChange > _movementThreshold) {
      if (!_isMoving) {
        _isMoving = true;
        _movementCount++; // Incrementar contador apenas na transição
      }
    } else {
      _isMoving = false;
    }
  }

  /// Detecta vibração baseada na variância das leituras recentes
  /// 
  /// Mantém um histórico das últimas leituras e calcula a variância
  /// para identificar padrões de vibração rápida e repetitiva.
  void _detectVibration() {
    // Adicionar nova leitura ao histórico
    _recentMagnitudes.add(_magnitude);
    
    // Manter apenas as últimas 10 leituras para análise
    if (_recentMagnitudes.length > 10) {
      _recentMagnitudes.removeAt(0);
    }

    // Analisar variação apenas com dados suficientes
    if (_recentMagnitudes.length >= 5) {
      double variance = _calculateVariance(_recentMagnitudes);
      _isVibrating = variance > _vibrationThreshold;
    }
  }

  /// Calcula a inclinação do dispositivo em graus
  /// 
  /// Utiliza trigonometria para converter aceleração em ângulos
  /// de inclinação, funcionando como um nível digital.
  void _calculateTilt() {
    // Calcular inclinação em X (pitch) - inclinar para frente/trás
    _tiltX = (atan2(_x, sqrt(_y * _y + _z * _z)) * 180 / pi);
    
    // Calcular inclinação em Y (roll) - inclinar para esquerda/direita
    _tiltY = (atan2(_y, sqrt(_x * _x + _z * _z)) * 180 / pi);

    // Determinar se o dispositivo está nivelado
    _isLevel = _tiltX.abs() < _levelThreshold && _tiltY.abs() < _levelThreshold;
  }

  // ===== SEÇÃO: UTILITÁRIOS MATEMÁTICOS =====
  /// Calcula a variância estatística de uma lista de valores
  /// 
  /// A variância indica o quão dispersos estão os valores.
  /// Valores altos indicam muita variação (possível vibração).
  double _calculateVariance(List<double> values) {
    if (values.isEmpty) return 0.0;

    // Calcular média dos valores
    double mean = values.reduce((a, b) => a + b) / values.length;
    
    // Calcular soma dos quadrados das diferenças
    double sumSquaredDiff = values
        .map((x) => pow(x - mean, 2).toDouble())
        .reduce((a, b) => a + b);
        
    // Retornar variância (média dos quadrados das diferenças)
    return sumSquaredDiff / values.length;
  }

  /// Para o monitoramento de movimento
  /// 
  /// Cancela o listener do acelerômetro e reseta todos os
  /// estados de detecção para valores padrão.
  void stopMonitoring() {
    _isMonitoring = false;
    _isMoving = false;
    _isVibrating = false;
    notifyListeners();
    _accelerometerSubscription?.cancel();
  }

  // ===== SEÇÃO: LIMPEZA DE RECURSOS =====
  /// Método chamado quando o controller é destruído
  /// 
  /// Garante que a subscription seja cancelada para evitar
  /// vazamentos de memória.
  @override
  void dispose() {
    _accelerometerSubscription?.cancel();
    super.dispose();
  }
}
