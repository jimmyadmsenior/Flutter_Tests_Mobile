# BluetoothController - Documentação

## 📱 O que é o Bluetooth?

O **Bluetooth** é uma tecnologia de comunicação sem fio de curto alcance que permite conectar dispositivos próximos (até ~10 metros). É amplamente usado para:
- Fones de ouvido sem fio
- Teclados e mouses
- Transferência de arquivos
- Conexão com carros
- Dispositivos IoT (Internet das Coisas)

## 🎯 Para que serve o BluetoothController?

O `BluetoothController` gerencia todas as operações relacionadas ao Bluetooth no app:

### **Principais Funcionalidades:**
- ✅ **Verificar estado** do adaptador Bluetooth
- ✅ **Ativar/Desativar** Bluetooth programaticamente
- ✅ **Escanear dispositivos** próximos
- ✅ **Conectar** a dispositivos encontrados
- ✅ **Monitorar conexões** em tempo real

## 🔧 Como Funciona?

### **1. Inicialização**
```dart
await controller.initBluetooth();
```
- Solicita permissões necessárias
- Monitora estado do adaptador
- Configura listeners para scan

### **2. Verificação de Estado**
```dart
BluetoothAdapterState state = controller.adapterState;
```
Estados possíveis:
- `on` - Bluetooth ativo
- `off` - Bluetooth desativado
- `unknown` - Estado desconhecido

### **3. Busca de Dispositivos**
```dart
await controller.startScan();
```
- Escaneia por 15 segundos
- Atualiza lista automaticamente
- Mostra força do sinal (RSSI)

### **4. Conexão**
```dart
await controller.connectToDevice(device);
```
- Tenta conectar ao dispositivo
- Retorna erro se falhar
- Monitora status da conexão

## 📊 Propriedades Importantes

| Propriedade | Tipo | Descrição |
|-------------|------|-----------|
| `adapterState` | `BluetoothAdapterState` | Estado atual do Bluetooth |
| `scanResults` | `List<ScanResult>` | Dispositivos encontrados |
| `isScanning` | `bool` | Se está escaneando |

## 🔒 Permissões Necessárias

- **BLUETOOTH_SCAN** - Para buscar dispositivos
- **BLUETOOTH_CONNECT** - Para conectar
- **BLUETOOTH_ADVERTISE** - Para anunciar
- **LOCATION** - Necessária no Android

## 💡 Dicas para Aula

1. **Demonstre** como o Bluetooth funciona na prática
2. **Explique** a diferença entre scan e conexão
3. **Mostre** como dispositivos se identificam
4. **Discuta** questões de segurança e privacidade
5. **Compare** com outras tecnologias (WiFi, NFC)

## ⚠️ Limitações Conhecidas

- **Windows PCs** podem não anunciar nomes
- **iOS** tem restrições de scan em background
- **Android** requer localização ativa
- **Alcance limitado** (~10 metros)
