import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';

/// Controller responsável por gerenciar funcionalidades de áudio
/// 
/// Este controller oferece controle completo sobre gravação e reprodução
/// de áudio, incluindo gerenciamento de permissões e estados.
class AudioController extends ChangeNotifier {
  // ===== SEÇÃO: INSTÂNCIAS DOS COMPONENTES DE ÁUDIO =====
  // Recorder para capturar áudio do microfone
  FlutterSoundRecorder? _recorder;
  
  // Player para reproduzir arquivos de áudio
  FlutterSoundPlayer? _player;
  
  // ===== SEÇÃO: ESTADOS DE CONTROLE =====
  // Flags que indicam o estado atual das operações de áudio
  bool _isRecording = false;        // Se está gravando atualmente
  bool _isPlaying = false;          // Se está reproduzindo áudio
  bool _hasRecording = false;       // Se existe uma gravação disponível
  bool _isRecorderInitialized = false;  // Se o recorder foi inicializado
  bool _isPlayerInitialized = false;    // Se o player foi inicializado
  
  // ===== SEÇÃO: DADOS DA GRAVAÇÃO =====
  // Duração atual da gravação em tempo real
  Duration _recordingDuration = Duration.zero;
  
  // Timer para atualizar a duração durante a gravação
  Timer? _recordingTimer;
  
  // Caminho do arquivo de áudio gravado
  String? _recordingPath;

  // ===== SEÇÃO: GETTERS PÚBLICOS =====
  // Permitem acesso seguro aos estados internos do controller
  bool get isRecording => _isRecording;
  bool get isPlaying => _isPlaying;
  bool get hasRecording => _hasRecording;
  bool get isRecorderInitialized => _isRecorderInitialized;
  bool get isPlayerInitialized => _isPlayerInitialized;
  Duration get recordingDuration => _recordingDuration;

  // ===== SEÇÃO: INICIALIZAÇÃO =====
  /// Inicialização do sistema de áudio
  /// 
  /// Configura o recorder e player, solicita permissões necessárias
  /// e prepara o sistema para operações de áudio.
  /// Deve ser chamado antes de qualquer operação de áudio.
  Future<String?> initializeAudio() async {
    _recorder = FlutterSoundRecorder();
    _player = FlutterSoundPlayer();
    
    try {
      // Solicitar permissão de microfone
      final status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        return 'Permissão de microfone necessária!';
      }

      // Inicializar recorder e player para uso posterior
      await _recorder!.openRecorder();
      await _player!.openPlayer();
      
      // Marcar como inicializados e notificar listeners
      _isRecorderInitialized = true;
      _isPlayerInitialized = true;
      notifyListeners();
      return null; // Sucesso
    } catch (e) {
      return 'Erro ao inicializar áudio: $e';
    }
  }

  // ===== SEÇÃO: UTILITÁRIOS PRIVADOS =====
  /// Gera um caminho único para salvar a gravação
  /// 
  /// Utiliza o diretório de documentos do app e adiciona timestamp
  /// para garantir que cada gravação tenha um nome único.
  Future<String> _getRecordingPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/recording_${DateTime.now().millisecondsSinceEpoch}.aac';
  }

  // ===== SEÇÃO: CONTROLE DE GRAVAÇÃO =====
  /// Inicia a gravação de áudio
  /// 
  /// Começa a gravar áudio do microfone e salva em um arquivo temporário.
  /// Atualiza o estado para indicar que a gravação está ativa.
  /// Requer permissão de microfone previamente concedida.
  Future<String?> startRecording() async {
    if (!_isRecorderInitialized) return 'Recorder não inicializado';
    
    try {
      // Gerar caminho único para a gravação
      _recordingPath = await _getRecordingPath();
      
      // Iniciar gravação com codec AAC (boa qualidade e compatibilidade)
      await _recorder!.startRecorder(
        toFile: _recordingPath,
        codec: Codec.aacADTS,
      );
      
      // Atualizar estado e resetar duração
      _isRecording = true;
      _recordingDuration = Duration.zero;
      notifyListeners();

      // Timer para atualizar duração em tempo real (a cada segundo)
      _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        _recordingDuration = Duration(seconds: timer.tick);
        notifyListeners();
      });
      return null; // Sucesso
    } catch (e) {
      return 'Erro ao iniciar gravação: $e';
    }
  }

  /// Para a gravação de áudio
  /// 
  /// Finaliza a gravação atual e salva o arquivo de áudio.
  /// Atualiza o estado e disponibiliza o arquivo para reprodução.
  /// Calcula automaticamente a duração da gravação.
  Future<String?> stopRecording() async {
    if (!_isRecording) return 'Não está gravando';
    
    try {
      // Parar a gravação e cancelar o timer
      await _recorder!.stopRecorder();
      _recordingTimer?.cancel();
      
      // Atualizar estados
      _isRecording = false;
      _hasRecording = true;  // Marca que há uma gravação disponível
      notifyListeners();
      
      return null; // Sucesso
    } catch (e) {
      return 'Erro ao parar gravação: $e';
    }
  }

  // ===== SEÇÃO: CONTROLE DE REPRODUÇÃO =====
  /// Reproduz o áudio gravado
  /// 
  /// Inicia a reprodução do último arquivo de áudio gravado.
  /// Atualiza o estado para indicar que a reprodução está ativa.
  /// Requer que exista um arquivo de áudio previamente gravado.
  Future<String?> playRecording() async {
    if (!_hasRecording || !_isPlayerInitialized || _recordingPath == null) {
      return 'Nenhuma gravação disponível';
    }
    
    try {
      // Marcar como reproduzindo
      _isPlaying = true;
      notifyListeners();

      // Iniciar reprodução com callback para quando terminar
      await _player!.startPlayer(
        fromURI: _recordingPath,
        whenFinished: () {
          _isPlaying = false;
          notifyListeners();
        },
      );
      return null; // Sucesso
    } catch (e) {
      _isPlaying = false;
      notifyListeners();
      return 'Erro ao reproduzir áudio: $e';
    }
  }

  /// Para a reprodução de áudio
  /// 
  /// Interrompe a reprodução em andamento e atualiza o estado
  /// para indicar que não está mais reproduzindo.
  /// 
  /// Retorna null em caso de sucesso ou uma mensagem de erro.
  Future<String?> stopPlaying() async {
    if (!_isPlaying) return 'Não está reproduzindo';
    
    try {
      // Parar a reprodução e atualizar estado
      await _player!.stopPlayer();
      _isPlaying = false;
      notifyListeners();
      return null; // Sucesso
    } catch (e) {
      return 'Erro ao parar reprodução: $e';
    }
  }

  // ===== SEÇÃO: UTILITÁRIOS PÚBLICOS =====
  /// Formata duração em formato legível
  /// 
  /// Converte milissegundos em formato MM:SS para exibição.
  /// Útil para mostrar a duração da gravação na interface.
  /// Exemplo: Duration(seconds: 125) -> "02:05"
  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  // ===== SEÇÃO: LIMPEZA DE RECURSOS =====
  /// Método chamado quando o controller é destruído
  /// 
  /// Cancela timers ativos, fecha o recorder e player para liberar
  /// recursos do sistema e evitar vazamentos de memória.
  @override
  void dispose() {
    _recordingTimer?.cancel();
    _recorder?.closeRecorder();
    _player?.closePlayer();
    super.dispose();
  }
}
