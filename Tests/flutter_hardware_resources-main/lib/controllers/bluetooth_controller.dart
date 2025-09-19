import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';

/// Controller responsável por gerenciar funcionalidades Bluetooth
///
/// Este controller permite descobrir, conectar e gerenciar dispositivos
/// Bluetooth próximos, controlando o estado do adaptador e escaneamento.
///
class BluetoothController extends ChangeNotifier {
  // ===== SEÇÃO: ESTADO DO BLUETOOTH =====
  // Estado atual do adaptador Bluetooth (ligado, desligado, etc.)
  BluetoothAdapterState _adapterState = BluetoothAdapterState.unknown;

  // Lista de dispositivos encontrados durante o escaneamento
  List<ScanResult> _scanResults = [];

  // Flag indicando se está realizando escaneamento
  bool _isScanning = false;

  // ===== SEÇÃO: GERENCIAMENTO DE STREAMS =====
  // Subscription para monitorar mudanças no estado do adaptador
  StreamSubscription<BluetoothAdapterState>? _adapterStateSubscription;

  // Subscription para receber resultados do escaneamento
  StreamSubscription<List<ScanResult>>? _scanResultsSubscription;

  // ===== SEÇÃO: GETTERS PÚBLICOS =====
  // Permitem acesso seguro aos estados internos do controller
  BluetoothAdapterState get adapterState => _adapterState;
  List<ScanResult> get scanResults => _scanResults;
  bool get isScanning => _isScanning;

  // ===== SEÇÃO: INICIALIZAÇÃO =====
  ///
  /// Inicializa o sistema Bluetooth e configura listeners
  ///
  /// Solicita permissões necessárias, obtém o estado inicial do adaptador
  /// e configura streams para monitorar mudanças e resultados de scan.
  ///
  Future<void> initBluetooth() async {
    // Solicitar todas as permissões necessárias
    await _requestPermissions();

    // Obter estado inicial do adaptador Bluetooth
    _adapterState = await FlutterBluePlus.adapterState.first;
    notifyListeners();

    // Configurar listener para mudanças no estado do adaptador
    _adapterStateSubscription = FlutterBluePlus.adapterState.listen((state) {
      _adapterState = state;
      notifyListeners();
    });

    // Configurar listener para resultados de escaneamento
    _scanResultsSubscription = FlutterBluePlus.scanResults.listen((results) {
      _scanResults = results;
      notifyListeners();
    });
  }

  // ===== SEÇÃO: GERENCIAMENTO DE PERMISSÕES =====

  ///Solicita todas as permissões necessárias para Bluetooth
  ///
  ///No Android 12+, são necessárias permissões específicas para
  ///scan, conexão, anúncio e localização para funcionalidades Bluetooth.
  ///
  Future<void> _requestPermissions() async {
    await [
      Permission.bluetoothScan, // Para escanear dispositivos
      Permission.bluetoothConnect, // Para conectar a dispositivos
      Permission.bluetoothAdvertise, // Para anunciar o dispositivo
      Permission.location, // Necessária para scan no Android
    ].request();
  }

  // ===== SEÇÃO: CONTROLE DE ESCANEAMENTO =====
  ///
  /// Inicia o escaneamento de dispositivos Bluetooth próximos
  ///
  /// Verifica se o Bluetooth está ativado, inicia o scan por 15 segundos
  /// e atualiza a lista de dispositivos encontrados automaticamente.
  ///
  /// Retorna null em caso de sucesso ou uma mensagem de erro.

  Future<String?> startScan() async {
    if (_adapterState != BluetoothAdapterState.on) {
      return 'Bluetooth deve estar ativado para buscar dispositivos';
    }

    _isScanning = true;
    notifyListeners();

    try {
      // Iniciar escaneamento com timeout de 15 segundos
      await FlutterBluePlus.startScan(
        timeout: const Duration(seconds: 15),
        androidUsesFineLocation: false, // Não usar localização precisa
      );

      // Aguardar o scan terminar automaticamente
      await Future.delayed(const Duration(seconds: 15));

      _isScanning = false;
      notifyListeners();
      return null; // Sucesso
    } catch (e) {
      _isScanning = false;
      notifyListeners();
      return 'Erro ao buscar dispositivos: $e';
    }
  }

  ///
  /// Tenta ativar o Bluetooth do dispositivo
  ///
  /// Verifica se o Bluetooth é suportado e tenta ativá-lo.
  /// Em alguns dispositivos, pode ser necessário ativar manualmente.
  ///
  /// Retorna null em caso de sucesso ou uma mensagem de erro.

  Future<String?> turnOnBluetooth() async {
    try {
      // Verificar se o dispositivo suporta Bluetooth
      if (await FlutterBluePlus.isSupported == false) {
        return 'Bluetooth não é suportado neste dispositivo';
      }

      // Tentar ativar o Bluetooth
      await FlutterBluePlus.turnOn();
      return null; // Sucesso
    } catch (e) {
      return 'Ative o Bluetooth manualmente nas configurações do sistema';
    }
  }

  // ===== SEÇÃO: GERENCIAMENTO DE CONEXÕES =====
  ///
  /// Conecta a um dispositivo Bluetooth específico
  ///
  /// Tenta estabelecer uma conexão com o dispositivo fornecido.
  /// A conexão pode falhar se o dispositivo estiver fora de alcance
  /// ou não aceitar conexões.
  ///
  /// Retorna null em caso de sucesso ou uma mensagem de erro.
  ////
  Future<String?> connectToDevice(BluetoothDevice device) async {
    try {
      await device.connect();
      return null; // Sucesso
    } catch (e) {
      return 'Erro ao conectar: $e';
    }
  }

  // ===== SEÇÃO: UTILITÁRIOS PÚBLICOS =====
  /// Converte o estado do adaptador em texto legível
  /// 
  /// Transforma os estados enum do Bluetooth em strings
  /// amigáveis para exibição na interface do usuário.
  String getAdapterStateText() {
    switch (_adapterState) {
      case BluetoothAdapterState.on:
        return 'Ativado';
      case BluetoothAdapterState.off:
        return 'Desativado';
      case BluetoothAdapterState.turningOn:
        return 'Ativando...';
      case BluetoothAdapterState.turningOff:
        return 'Desativando...';
      default:
        return 'Desconhecido';
    }
  }

  /// Determina o ícone apropriado para um dispositivo baseado no nome
  /// 
  /// Analisa o nome do dispositivo e retorna um ícone que melhor
  /// representa o tipo de dispositivo para melhor experiência visual.
  /// 
  /// Retorna um ícone específico ou genérico se não identificar o tipo.
  IconData getDeviceIcon(String deviceName) {
    final name = deviceName.toLowerCase();

    // Identificar smartphones
    if (name.contains('phone') ||
        name.contains('iphone') ||
        name.contains('android')) {
      return Icons.smartphone;
    }
    // Identificar dispositivos de áudio
    else if (name.contains('headphone') ||
        name.contains('earphone') ||
        name.contains('audio')) {
      return Icons.headphones;
    }
    // Identificar TVs
    else if (name.contains('tv') || name.contains('television')) {
      return Icons.tv;
    }
    // Identificar computadores
    else if (name.contains('computer') ||
        name.contains('laptop') ||
        name.contains('pc')) {
      return Icons.computer;
    }
    // Identificar smartwatches
    else if (name.contains('watch')) {
      return Icons.watch;
    }
    // Dispositivo não identificado
    else {
      return Icons.device_unknown;
    }
  }

  // ===== SEÇÃO: LIMPEZA DE RECURSOS =====
  /// Método chamado quando o controller é destruído
  /// 
  /// Cancela todas as subscriptions ativas para evitar vazamentos
  /// de memória e liberar recursos do sistema.
  @override
  void dispose() {
    _adapterStateSubscription?.cancel();
    _scanResultsSubscription?.cancel();
    super.dispose();
  }
}
