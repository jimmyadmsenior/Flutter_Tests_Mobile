import 'package:flutter/foundation.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

/// Controller responsável por gerenciar funcionalidades da câmera
/// 
/// Este controller permite capturar fotos, alternar entre câmeras,
/// selecionar imagens da galeria e gerenciar permissões de câmera.
class CameraControllerService extends ChangeNotifier {
  // ===== SEÇÃO: COMPONENTES DA CÂMERA =====
  // Controller principal da câmera para preview e captura
  CameraController? _cameraController;
  
  // Lista de câmeras disponíveis no dispositivo
  List<CameraDescription>? _cameras;
  
  // ===== SEÇÃO: ESTADOS DE CONTROLE =====
  // Flag indicando se a câmera foi inicializada com sucesso
  bool _isCameraInitialized = false;
  
  // Última imagem capturada ou selecionada
  File? _capturedImage;
  
  // Instância do seletor de imagens para galeria
  final ImagePicker _imagePicker = ImagePicker();
  
  // Mensagem de erro durante inicialização, se houver
  String? _initializationError;
  
  // Flag indicando se está em processo de inicialização
  bool _isInitializing = false;

  // ===== SEÇÃO: GETTERS PÚBLICOS =====
  // Permitem acesso seguro aos estados internos do controller
  CameraController? get cameraController => _cameraController;
  List<CameraDescription>? get cameras => _cameras;
  bool get isCameraInitialized => _isCameraInitialized;
  File? get capturedImage => _capturedImage;
  String? get initializationError => _initializationError;
  bool get isInitializing => _isInitializing;

  // ===== SEÇÃO: INICIALIZAÇÃO =====
  /// Inicializa o sistema de câmera
  /// 
  /// Verifica permissões, obtém câmeras disponíveis e configura
  /// o controller da câmera principal para uso.
  Future<void> initialize() async {
    // Evitar inicialização múltipla simultânea
    if (_isInitializing) return;
    
    _isInitializing = true;
    _initializationError = null;
    notifyListeners();

    try {
      // Verificar e solicitar permissões de câmera
      final cameraPermission = await Permission.camera.status;
      if (cameraPermission.isDenied) {
        final result = await Permission.camera.request();
        if (result.isDenied) {
          _initializationError = 'Permissão da câmera negada';
          _isInitializing = false;
          notifyListeners();
          return;
        }
      }

      // Obter lista de câmeras disponíveis no dispositivo
      _cameras = await availableCameras();
      
      if (_cameras == null || _cameras!.isEmpty) {
        _initializationError = 'Nenhuma câmera encontrada';
        _isInitializing = false;
        notifyListeners();
        return;
      }

      // Inicializar controller com a primeira câmera (geralmente traseira)
      _cameraController = CameraController(
        _cameras![0],
        ResolutionPreset.medium,  // Balanço entre qualidade e performance
        enableAudio: false,       // Evita problemas de permissão de áudio
      );

      // Aguardar inicialização completa
      await _cameraController!.initialize();
      
      // Verificar se inicializou corretamente
      if (_cameraController!.value.isInitialized) {
        _isCameraInitialized = true;
        _initializationError = null;
      } else {
        _initializationError = 'Falha ao inicializar câmera';
      }
    } catch (e) {
      _initializationError = 'Erro ao inicializar câmera: ${e.toString()}';
      if (kDebugMode) {
        print('Erro detalhado: $e');
      }
      // Limpar recursos em caso de erro
      await _cameraController?.dispose();
      _cameraController = null;
    } finally {
      _isInitializing = false;
      notifyListeners();
    }
  }

  // ===== SEÇÃO: CAPTURA DE IMAGENS =====
  /// Captura uma foto usando a câmera
  /// 
  /// Verifica se a câmera está inicializada e não está ocupada,
  /// então captura uma imagem e salva no armazenamento local.
  Future<void> takePicture() async {
    // Verificar se a câmera está pronta para uso
    if (!_isCameraInitialized || _cameraController == null) {
      if (kDebugMode) {
        print('Câmera não inicializada');
      }
      return;
    }

    try {
      // Evitar captura múltipla simultânea
      if (_cameraController!.value.isTakingPicture) {
        return; // Já está tirando foto
      }

      // Capturar imagem e salvar referência
      final XFile image = await _cameraController!.takePicture();
      _capturedImage = File(image.path);
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao capturar imagem: $e');
      }
    }
  }

  /// Seleciona uma imagem da galeria do dispositivo
  /// 
  /// Abre o seletor de imagens do sistema para que o usuário
  /// escolha uma foto existente da galeria.
  Future<void> pickImageFromGallery() async {
    try {
      // Abrir seletor de imagens da galeria
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
      );
      
      // Se uma imagem foi selecionada, salvar referência
      if (image != null) {
        _capturedImage = File(image.path);
        notifyListeners();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao selecionar imagem: $e');
      }
    }
  }

  // ===== SEÇÃO: CONTROLE DE CÂMERAS =====
  /// Alterna entre as câmeras disponíveis (frontal/traseira)
  /// 
  /// Troca entre as câmeras do dispositivo, geralmente alternando
  /// entre câmera traseira e frontal.
  Future<void> switchCamera() async {
    // Verificar se há múltiplas câmeras disponíveis
    if (!_isCameraInitialized || _cameras == null || _cameras!.length <= 1) {
      return;
    }

    try {
      // Encontrar índice da câmera atual
      final currentCameraIndex = _cameras!.indexOf(
        _cameraController!.description,
      );
      
      // Calcular próxima câmera (circular)
      final newCameraIndex = (currentCameraIndex + 1) % _cameras!.length;

      // Descartar controller atual
      await _cameraController!.dispose();
      
      // Criar novo controller com a próxima câmera
      _cameraController = CameraController(
        _cameras![newCameraIndex],
        ResolutionPreset.medium,
        enableAudio: false,
      );

      // Inicializar nova câmera
      await _cameraController!.initialize();
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao trocar câmera: $e');
      }
    }
  }

  // ===== SEÇÃO: GERENCIAMENTO DE IMAGENS =====
  /// Remove a referência da imagem capturada
  /// 
  /// Limpa a última imagem capturada ou selecionada,
  /// permitindo capturar uma nova imagem.
  void clearCapturedImage() {
    _capturedImage = null;
    notifyListeners();
  }

  // ===== SEÇÃO: LIMPEZA DE RECURSOS =====
  /// Método chamado quando o controller é destruído
  /// 
  /// Libera recursos da câmera, descarta o controller e
  /// reseta estados para evitar vazamentos de memória.
  @override
  void dispose() {
    _cameraController?.dispose();
    _cameraController = null;
    _isCameraInitialized = false;
    super.dispose();
  }
}
