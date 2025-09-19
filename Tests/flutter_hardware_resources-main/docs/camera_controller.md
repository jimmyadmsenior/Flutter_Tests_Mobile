# CameraControllerService - Documentação

## 📱 O que é a Câmera em Dispositivos Móveis?

A **câmera** é um dos sensores mais complexos dos dispositivos móveis:
- **Sensor de imagem** - Captura luz e converte em dados digitais
- **Lente** - Foca a luz no sensor
- **Processamento** - ISP (Image Signal Processor) melhora a imagem
- **Múltiplas câmeras** - Frontal, traseira, ultra-wide, macro

## 🎯 Para que serve o CameraControllerService?

O `CameraControllerService` gerencia todas as operações da câmera:

### **Principais Funcionalidades:**
- ✅ **Inicializar câmera** com preview em tempo real
- ✅ **Capturar fotos** em alta qualidade
- ✅ **Alternar entre câmeras** (frontal/traseira)
- ✅ **Selecionar da galeria** de fotos
- ✅ **Gerenciar permissões** de câmera e armazenamento

## 🔧 Como Funciona?

### **1. Inicialização**
```dart
await controller.initialize();
```
- Solicita permissões necessárias
- Lista câmeras disponíveis
- Configura preview da câmera principal

### **2. Captura de Foto**
```dart
await controller.takePicture();
```
- Captura imagem em resolução média
- Salva temporariamente
- Atualiza interface automaticamente

### **3. Troca de Câmera**
```dart
await controller.switchCamera();
```
- Alterna entre câmeras disponíveis
- Reinicializa preview
- Mantém configurações

### **4. Galeria**
```dart
await controller.pickImageFromGallery();
```
- Abre seletor de imagens
- Permite escolher foto existente
- Integra com apps de galeria

## 📊 Propriedades Importantes

| Propriedade | Tipo | Descrição |
|-------------|------|-----------|
| `cameraController` | `CameraController?` | Controlador da câmera ativa |
| `isCameraInitialized` | `bool` | Se câmera está pronta |
| `capturedImage` | `File?` | Última imagem capturada |
| `cameras` | `List<CameraDescription>?` | Câmeras disponíveis |

## 📸 Resoluções Disponíveis

- **low**: 240p (rápido, baixa qualidade)
- **medium**: 480p (balanceado)
- **high**: 720p (boa qualidade)
- **veryHigh**: 1080p (alta qualidade)
- **ultraHigh**: 2160p (4K, muito pesado)

## 🎨 Funcionalidades da Interface

### **Preview em Tempo Real**
- Mostra imagem da câmera ao vivo
- Ajusta proporção automaticamente
- Botão de troca de câmera sobreposto

### **Controles**
- **Galeria** - Selecionar foto existente
- **Captura** - Tirar nova foto
- **Limpar** - Remover foto atual

### **Visualização**
- Preview pequeno clicável
- Modal expandido com zoom
- Navegação intuitiva

## 💡 Dicas para Aula

1. **Demonstre** diferentes resoluções
2. **Explique** como funciona o sensor de imagem
3. **Mostre** diferença entre câmeras
4. **Discuta** processamento de imagem
5. **Compare** qualidade vs performance

## 🔒 Permissões Necessárias

- **CAMERA** - Para acessar câmera
- **WRITE_EXTERNAL_STORAGE** - Para salvar fotos

## ⚠️ Considerações Importantes

- **Privacidade** - Câmera é sensor sensível
- **Performance** - Preview consome recursos
- **Armazenamento** - Fotos ocupam espaço
- **Orientação** - Rotação afeta preview
- **Iluminação** - Qualidade depende da luz
