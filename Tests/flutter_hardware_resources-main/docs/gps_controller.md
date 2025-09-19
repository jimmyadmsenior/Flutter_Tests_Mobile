# GpsController - Documentação

## 📱 O que é GPS?

O **GPS (Global Positioning System)** é um sistema de navegação por satélite que permite determinar a localização exata do dispositivo na Terra:
- **Precisão**: 3-5 metros em condições ideais
- **Cobertura**: Global (exceto áreas muito remotas)
- **Funcionamento**: Triangulação com múltiplos satélites
- **Tempo**: Pode levar 30s-2min para primeira localização

## 🎯 Para que serve o GpsController?

O `GpsController` gerencia todas as operações de localização:

### **Principais Funcionalidades:**
- ✅ **Obter localização atual** com coordenadas precisas
- ✅ **Geocodificação reversa** (coordenadas → endereço)
- ✅ **Exibir mapa interativo** com marcador
- ✅ **Monitorar precisão** da localização
- ✅ **Calcular velocidade e direção**

## 🔧 Como Funciona?

### **1. Obtenção de Localização**
```dart
await controller.getCurrentLocation();
```
- Solicita permissão de localização
- Ativa GPS se necessário
- Retorna coordenadas precisas

### **2. Dados de Posição**
```dart
Position position = controller.currentPosition;
double lat = position.latitude;   // Latitude
double lng = position.longitude;  // Longitude
double alt = position.altitude;   // Altitude
double acc = position.accuracy;   // Precisão em metros
```

### **3. Geocodificação**
```dart
String address = controller.address;
String postalCode = controller.postalCode;
```
- Converte coordenadas em endereço legível
- Obtém CEP da localização

### **4. Mapa Interativo**
- Usa **OpenStreetMap** (gratuito)
- Marcador na posição atual
- Zoom configurável (3x a 18x)

## 📊 Propriedades Importantes

| Propriedade | Tipo | Descrição |
|-------------|------|-----------|
| `currentPosition` | `Position?` | Coordenadas atuais |
| `address` | `String?` | Endereço formatado |
| `postalCode` | `String?` | CEP da localização |
| `statusMessage` | `String` | Status da operação |
| `isLoading` | `bool` | Se está buscando localização |
| `markers` | `List<Marker>` | Marcadores do mapa |

## 🌍 Sistema de Coordenadas

- **Latitude**: -90° a +90° (Sul a Norte)
- **Longitude**: -180° a +180° (Oeste a Leste)
- **Altitude**: Metros acima do nível do mar
- **Precisão**: Raio de erro em metros

## 🗺️ Tecnologias Utilizadas

- **GPS**: Satélites americanos
- **GLONASS**: Satélites russos
- **Galileo**: Satélites europeus
- **BeiDou**: Satélites chineses

## 💡 Dicas para Aula

1. **Explique** como funciona a triangulação
2. **Demonstre** diferença entre indoor/outdoor
3. **Mostre** impacto da precisão
4. **Discuta** questões de privacidade
5. **Compare** com outras tecnologias de localização

## 🔒 Permissões Necessárias

- **ACCESS_FINE_LOCATION** - Localização precisa
- **ACCESS_COARSE_LOCATION** - Localização aproximada
- **INTERNET** - Para geocodificação e mapas

## ⚠️ Considerações Importantes

- **Consumo de bateria** - GPS é intensivo
- **Tempo de inicialização** - Primeira localização demora
- **Precisão variável** - Depende do ambiente
- **Indoor limitado** - Funciona mal em interiores
- **Privacidade** - Dados sensíveis do usuário
