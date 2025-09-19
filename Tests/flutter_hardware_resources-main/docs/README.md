# 📚 Documentação - Flutter Hardware Resources

Esta pasta contém documentação completa para o projeto educacional de recursos de hardware em dispositivos móveis.

## 📁 Estrutura da Documentação

### **Controllers Individuais:**
- [`bluetooth_controller.md`](./bluetooth_controller.md) - Comunicação Bluetooth
- [`accelerometer_controller.md`](./accelerometer_controller.md) - Sensores de Movimento  
- [`audio_controller.md`](./audio_controller.md) - Sistema de Áudio
- [`gps_controller.md`](./gps_controller.md) - GPS e Localização
- [`wifi_controller.md`](./wifi_controller.md) - Conectividade WiFi
- [`camera_controller.md`](./camera_controller.md) - Câmera e Imagens

### **Material Didático:**
- [`roteiro_apresentacao.md`](./roteiro_apresentacao.md) - Roteiro completo para aula de 90 minutos

## 🎯 Como Usar Esta Documentação

### **Para Professores:**
1. **Leia o roteiro** antes da aula
2. **Estude cada controller** individualmente
3. **Teste todas as funcionalidades** no dispositivo
4. **Prepare troubleshooting** para problemas comuns

### **Para Alunos:**
1. **Consulte a documentação** durante desenvolvimento
2. **Entenda os conceitos** antes de implementar
3. **Use como referência** para projetos futuros
4. **Pratique** com os exemplos fornecidos

## 🏗️ Arquitetura do Projeto

```
lib/
├── controllers/          # Lógica de negócio
│   ├── bluetooth_controller.dart
│   ├── accelerometer_controller.dart
│   ├── audio_controller.dart
│   ├── gps_controller.dart
│   ├── wifi_controller.dart
│   └── camera_controller.dart
├── pages/               # Interface de usuário
│   ├── bluetooth_page.dart
│   ├── accelerometer_page.dart
│   ├── audio_page.dart
│   ├── gps_page.dart
│   ├── wifi_page.dart
│   └── camera_page.dart
└── main.dart           # Ponto de entrada
```

## 🔧 Dependências Principais

```yaml
dependencies:
  flutter_blue_plus: ^1.32.12    # Bluetooth
  sensors_plus: ^4.0.2           # Acelerômetro/Giroscópio
  record: ^5.0.4                 # Gravação de áudio
  audioplayers: ^5.2.1           # Reprodução de áudio
  geolocator: ^10.1.0            # GPS
  geocoding: ^2.1.1              # Endereços
  flutter_map: ^6.1.0            # Mapas
  connectivity_plus: ^5.0.2      # WiFi
  network_info_plus: ^4.1.0      # Informações de rede
  camera: ^0.10.5+5              # Câmera
  image_picker: ^1.0.4           # Galeria
  permission_handler: ^11.2.0    # Permissões
```

## 📱 Recursos de Hardware Cobertos

| Recurso | Descrição | Aplicações |
|---------|-----------|------------|
| **Bluetooth** | Comunicação sem fio curto alcance | Fones, IoT, transferências |
| **Acelerômetro** | Sensor de aceleração linear | Jogos, fitness, detecção |
| **Giroscópio** | Sensor de rotação angular | AR/VR, navegação, estabilização |
| **Microfone** | Captura de áudio | Gravação, reconhecimento de voz |
| **Alto-falantes** | Reprodução de áudio | Música, notificações, feedback |
| **GPS** | Sistema de posicionamento global | Navegação, localização, mapas |
| **WiFi** | Rede sem fio de longo alcance | Internet, transferências rápidas |
| **Câmera** | Sensor de imagem | Fotos, vídeos, AR, QR codes |

## 🎓 Objetivos de Aprendizagem

Após esta aula, os alunos devem ser capazes de:

1. **Compreender** como acessar recursos de hardware nativos
2. **Implementar** separação adequada entre lógica e UI
3. **Gerenciar** permissões de sistema corretamente
4. **Aplicar** padrões arquiteturais em projetos Flutter
5. **Resolver** problemas comuns de desenvolvimento mobile

## 🚀 Próximos Passos

- Implementar novos sensores (luz, proximidade, magnetômetro)
- Criar persistência de dados
- Adicionar testes unitários
- Implementar notificações push
- Integrar com APIs externas
