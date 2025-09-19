# WifiController - Documentação

## 📱 O que é WiFi?

O **WiFi** é uma tecnologia de rede sem fio baseada no padrão IEEE 802.11 que permite conectar dispositivos à internet:
- **Alcance**: 30-100 metros (dependendo do roteador)
- **Velocidade**: 11 Mbps a 9.6 Gbps (WiFi 6E)
- **Frequências**: 2.4 GHz, 5 GHz, 6 GHz
- **Padrões**: 802.11a/b/g/n/ac/ax

## 🎯 Para que serve o WifiController?

O `WifiController` monitora e gerencia informações de conectividade:

### **Principais Funcionalidades:**
- ✅ **Detectar tipo de conexão** (WiFi, dados móveis, ethernet)
- ✅ **Obter informações da rede** WiFi
- ✅ **Monitorar mudanças** de conectividade
- ✅ **Exibir detalhes técnicos** da rede
- ✅ **Verificar força do sinal**

## 🔧 Como Funciona?

### **1. Monitoramento de Conectividade**
```dart
ConnectivityResult status = controller.connectionStatus;
```
Tipos possíveis:
- `wifi` - Conectado via WiFi
- `mobile` - Dados móveis
- `ethernet` - Cabo de rede
- `none` - Sem conexão

### **2. Informações da Rede WiFi**
```dart
String name = controller.wifiName;        // Nome da rede
String ip = controller.wifiIP;            // IP local
String bssid = controller.wifiBSSID;      // MAC do roteador
String gateway = controller.wifiGateway;  // IP do roteador
```

### **3. Força do Sinal**
```dart
int strength = controller.signalStrength; // dBm
```
- **-30 dBm**: Excelente
- **-50 dBm**: Bom
- **-70 dBm**: Fraco

## 📊 Propriedades Importantes

| Propriedade | Tipo | Descrição |
|-------------|------|-----------|
| `connectionStatus` | `ConnectivityResult` | Tipo de conexão ativa |
| `wifiName` | `String` | Nome da rede WiFi |
| `wifiIP` | `String` | Endereço IP local |
| `wifiBSSID` | `String` | MAC do ponto de acesso |
| `signalStrength` | `int` | Força do sinal em dBm |
| `securityType` | `String` | Tipo de segurança |

## 🔒 Tipos de Segurança WiFi

- **Aberta**: Sem senha (insegura)
- **WEP**: Obsoleto (inseguro)
- **WPA**: Básico (pouco seguro)
- **WPA2**: Padrão atual (seguro)
- **WPA3**: Mais recente (muito seguro)

## 🌐 Conceitos de Rede

- **SSID**: Nome da rede WiFi
- **BSSID**: MAC address do roteador
- **Gateway**: Porta de entrada para internet
- **Subnet**: Máscara de sub-rede
- **DHCP**: Atribuição automática de IP

## 💡 Dicas para Aula

1. **Demonstre** mudança de rede
2. **Explique** diferença entre 2.4GHz e 5GHz
3. **Mostre** como interpretar força do sinal
4. **Discuta** segurança de redes
5. **Compare** WiFi vs dados móveis

## ⚠️ Limitações

- **Permissões** - Android requer localização para WiFi
- **iOS** - Informações limitadas por segurança
- **Simulação** - Força do sinal é aproximada
- **Privacidade** - Dados sensíveis de rede
