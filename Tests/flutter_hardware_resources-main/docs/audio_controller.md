# AudioController - Documentação

## 📱 O que é Áudio em Dispositivos Móveis?

O **sistema de áudio** em dispositivos móveis gerencia:
- **Microfone** - Captura de som ambiente
- **Alto-falantes** - Reprodução de áudio
- **Processamento** - Codificação/decodificação
- **Controle de volume** - Níveis de saída

## 🎯 Para que serve o AudioController?

O `AudioController` gerencia todas as operações de áudio do app:

### **Principais Funcionalidades:**
- ✅ **Gravar áudio** do microfone
- ✅ **Reproduzir gravações**
- ✅ **Controlar playback** (play/pause/stop)
- ✅ **Monitorar duração** das gravações
- ✅ **Gerenciar permissões** de microfone

## 🔧 Como Funciona?

### **1. Inicialização**
```dart
await controller.initialize();
```
- Solicita permissão de microfone
- Configura codec de áudio
- Prepara diretório de gravação

### **2. Gravação**
```dart
await controller.startRecording();
await controller.stopRecording();
```
- Inicia captura do microfone
- Salva em arquivo temporário
- Atualiza duração em tempo real

### **3. Reprodução**
```dart
await controller.playRecording();
await controller.pausePlayback();
await controller.stopPlayback();
```
- Reproduz última gravação
- Controla estado do player
- Monitora progresso

## 📊 Propriedades Importantes

| Propriedade | Tipo | Descrição |
|-------------|------|-----------|
| `isRecording` | `bool` | Se está gravando |
| `isPlaying` | `bool` | Se está reproduzindo |
| `isPaused` | `bool` | Se playback está pausado |
| `recordingDuration` | `Duration` | Duração da gravação atual |
| `playbackPosition` | `Duration` | Posição atual do playback |

## 🎵 Formatos de Áudio

- **Android**: AAC, MP3, WAV
- **iOS**: AAC, ALAC, MP3
- **Codec padrão**: AAC (boa qualidade/tamanho)

## 🎤 Qualidade de Gravação

```dart
// Configurações típicas
sampleRate: 44100 Hz  // CD quality
bitRate: 128000       // 128 kbps
channels: 1           // Mono
```

## 💡 Dicas para Aula

1. **Demonstre** gravação em tempo real
2. **Explique** conceitos de sample rate e bit rate
3. **Mostre** diferença entre mono e estéreo
4. **Discuta** compressão de áudio
5. **Teste** qualidade em diferentes ambientes

## 🔒 Permissões Necessárias

- **RECORD_AUDIO** - Para gravar do microfone
- **WRITE_EXTERNAL_STORAGE** - Para salvar arquivos (Android)

## ⚠️ Considerações Importantes

- **Privacidade** - Sempre informar sobre gravação
- **Armazenamento** - Arquivos podem ser grandes
- **Bateria** - Gravação consome energia
- **Ruído** - Ambiente afeta qualidade
- **Latência** - Delay entre captura e reprodução
