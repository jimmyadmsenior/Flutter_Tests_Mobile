import 'package:flutter/foundation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'dart:async';

/**
 * Controller responsável por gerenciar informações de conectividade WiFi
 * 
 * Este controller monitora o status da conexão de rede, obtém informações
 * detalhadas sobre a rede WiFi e detecta mudanças de conectividade.
 */
class WifiController extends ChangeNotifier {
  // ===== SEÇÃO: STATUS DE CONECTIVIDADE =====
  // Status atual da conexão (WiFi, dados móveis, etc.)
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  
  // Flag indicando se está verificando conectividade
  bool _isChecking = false;

  // ===== SEÇÃO: INFORMAÇÕES DA REDE WIFI =====
  // Nome da rede WiFi (SSID)
  String _wifiName = 'Desconhecido';
  
  // Endereço IP do dispositivo na rede
  String _wifiIP = 'Não disponível';
  
  // BSSID (identificador único do ponto de acesso)
  String _wifiBSSID = 'Não disponível';
  
  // Endereço IP do gateway (roteador)
  String _wifiGateway = 'Não disponível';
  
  // Máscara de sub-rede
  String _wifiSubnet = 'Não disponível';
  
  // Força do sinal WiFi (em dBm)
  int _signalStrength = 0;
  
  // Tipo de segurança da rede
  String _securityType = 'Desconhecido';

  // ===== SEÇÃO: COMPONENTES DE REDE =====
  // Instância para obter informações detalhadas da rede
  final NetworkInfo _networkInfo = NetworkInfo();
  
  // Subscription para monitorar mudanças de conectividade
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;

  // ===== SEÇÃO: GETTERS PÚBLICOS =====
  // Permitem acesso seguro aos dados internos do controller
  ConnectivityResult get connectionStatus => _connectionStatus;
  String get wifiName => _wifiName;
  String get wifiIP => _wifiIP;
  String get wifiBSSID => _wifiBSSID;
  String get wifiGateway => _wifiGateway;
  String get wifiSubnet => _wifiSubnet;
  int get signalStrength => _signalStrength;
  String get securityType => _securityType;
  bool get isChecking => _isChecking;

  // ===== SEÇÃO: INICIALIZAÇÃO =====
  /**
   * Inicializa o monitoramento de conectividade
   * 
   * Verifica o status inicial da conexão e configura
   * listeners para detectar mudanças automaticamente.
   */
  void initialize() {
    checkConnectivity();
    _listenToConnectivityChanges();
  }

  /**
   * Configura listener para mudanças de conectividade
   * 
   * Monitora automaticamente quando o dispositivo conecta/desconecta
   * de redes e atualiza as informações correspondentes.
   */
  void _listenToConnectivityChanges() {
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((
      ConnectivityResult result,
    ) {
      _connectionStatus = result;
      notifyListeners();
      _updateWifiInfo(); // Atualizar informações da nova rede
    });
  }

  // ===== SEÇÃO: VERIFICAÇÃO DE CONECTIVIDADE =====
  /**
   * Verifica manualmente o status da conectividade
   * 
   * Força uma verificação imediata do status de conexão
   * e atualiza todas as informações de rede.
   */
  Future<void> checkConnectivity() async {
    _isChecking = true;
    notifyListeners();

    try {
      // Verificar status atual da conectividade
      final connectivityResult = await Connectivity().checkConnectivity();
      _connectionStatus = connectivityResult;
      
      // Atualizar informações detalhadas da rede
      await _updateWifiInfo();
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao verificar conectividade: $e');
      }
    }

    _isChecking = false;
    notifyListeners();
  }

  // ===== SEÇÃO: ATUALIZAÇÃO DE INFORMAÇÕES =====
  /**
   * Atualiza informações detalhadas da rede WiFi
   * 
   * Obtém dados completos da rede quando conectado via WiFi,
   * incluindo IP, gateway, segurança e força do sinal.
   */
  Future<void> _updateWifiInfo() async {
    if (_connectionStatus == ConnectivityResult.wifi) {
      try {
        // Obter todas as informações disponíveis da rede WiFi
        final wifiName = await _networkInfo.getWifiName();
        final wifiIP = await _networkInfo.getWifiIP();
        final wifiBSSID = await _networkInfo.getWifiBSSID();
        final wifiGateway = await _networkInfo.getWifiGatewayIP();
        final wifiSubnet = await _networkInfo.getWifiSubmask();

        // Processar e limpar os dados obtidos
        _wifiName = wifiName?.replaceAll('"', '') ?? 'Nome não disponível';
        _wifiIP = wifiIP ?? 'IP não disponível';
        _wifiBSSID = wifiBSSID ?? 'BSSID não disponível';
        _wifiGateway = wifiGateway ?? 'Gateway não disponível';
        _wifiSubnet = wifiSubnet ?? 'Subnet não disponível';

        // Simular força do sinal (varia entre -45 e -75 dBm)
        _signalStrength = -45 + (DateTime.now().millisecond % 30);
        
        // Determinar tipo de segurança baseado no nome da rede
        _securityType = _determineSecurityType(_wifiName);
      } catch (e) {
        // Definir valores de erro em caso de falha
        _wifiName = 'Erro ao obter informações';
        _wifiIP = 'Não disponível';
        _wifiBSSID = 'Não disponível';
        _wifiGateway = 'Não disponível';
        _wifiSubnet = 'Não disponível';
        _signalStrength = 0;
        _securityType = 'Desconhecido';
      }
    } else {
      // Limpar informações quando não conectado ao WiFi
      _wifiName = 'Não conectado ao WiFi';
      _wifiIP = 'Não disponível';
      _wifiBSSID = 'Não disponível';
      _wifiGateway = 'Não disponível';
      _wifiSubnet = 'Não disponível';
      _signalStrength = 0;
      _securityType = 'Desconhecido';
    }
    notifyListeners();
  }

  // ===== SEÇÃO: ANÁLISE DE SEGURANÇA =====
  /**
   * Determina o tipo de segurança da rede baseado no nome
   * 
   * Analisa o SSID da rede para inferir o tipo de criptografia
   * utilizada. Em uma implementação real, isso seria obtido
   * diretamente das informações de rede.
   */
  String _determineSecurityType(String wifiName) {
    final name = wifiName.toLowerCase();
    
    // Detectar redes abertas (sem segurança)
    if (name.contains('open') || name.contains('free')) {
      return 'Aberta (Insegura)';
    } 
    // Detectar WPA3 (mais seguro)
    else if (name.contains('wpa3')) {
      return 'WPA3 (Muito Segura)';
    } 
    // Detectar WPA2
    else if (name.contains('wpa2')) {
      return 'WPA2 (Segura)';
    } 
    // Assumir WPA/WPA2 como padrão
    else {
      return 'WPA/WPA2 (Segura)';
    }
  }

  // ===== SEÇÃO: UTILITÁRIOS PÚBLICOS =====
  /**
   * Converte o status de conectividade em texto legível
   * 
   * Transforma os estados enum de conectividade em strings
   * amigáveis para exibição na interface do usuário.
   */
  String getConnectionStatusText() {
    switch (_connectionStatus) {
      case ConnectivityResult.wifi:
        return 'Conectado via WiFi';
      case ConnectivityResult.mobile:
        return 'Conectado via Dados Móveis';
      case ConnectivityResult.ethernet:
        return 'Conectado via Ethernet';
      case ConnectivityResult.bluetooth:
        return 'Conectado via Bluetooth';
      case ConnectivityResult.none:
        return 'Sem conexão';
      default:
        return 'Status desconhecido';
    }
  }

  // ===== SEÇÃO: LIMPEZA DE RECURSOS =====
  /**
   * Método chamado quando o controller é destruído
   * 
   * Cancela a subscription de conectividade para evitar
   * vazamentos de memória.
   */
  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }
}
