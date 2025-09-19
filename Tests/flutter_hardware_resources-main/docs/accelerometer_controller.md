# AccelerometerController - Documentação

## 📱 O que são Sensores de Movimento?

Os **sensores de movimento** são componentes físicos que detectam mudanças na posição e orientação do dispositivo:

### **Acelerômetro**
- Mede **aceleração** em 3 eixos (X, Y, Z)
- Detecta **movimento linear** e **gravidade**
- Usado em jogos, fitness apps, detecção de quedas

### **Giroscópio**
- Mede **velocidade angular** (rotação)
- Detecta **orientação** e **giros**
- Usado em realidade aumentada, estabilização

## 🎯 Para que serve o AccelerometerController?

O `AccelerometerController` gerencia todos os sensores de movimento do dispositivo:

### **Principais Funcionalidades:**
- ✅ **Monitorar acelerômetro** em tempo real
- ✅ **Capturar dados do giroscópio**
- ✅ **Calcular magnitude** da aceleração
- ✅ **Detectar movimentos** significativos
- ✅ **Controlar frequência** de atualização

## 🔧 Como Funciona?

### **1. Inicialização**
```dart
controller.startListening();
```
- Inicia stream do acelerômetro
- Configura listener do giroscópio
- Define frequência de atualização

### **2. Dados do Acelerômetro**
```dart
AccelerometerEvent event = controller.accelerometerData;
double x = event.x; // Eixo X
double y = event.y; // Eixo Y  
double z = event.z; // Eixo Z
```

### **3. Dados do Giroscópio**
```dart
GyroscopeEvent event = controller.gyroscopeData;
double rotX = event.x; // Rotação X
double rotY = event.y; // Rotação Y
double rotZ = event.z; // Rotação Z
```

### **4. Magnitude da Aceleração**
```dart
double magnitude = controller.accelerationMagnitude;
```
- Calcula √(x² + y² + z²)
- Útil para detectar movimento total

## 📊 Propriedades Importantes

| Propriedade | Tipo | Descrição |
|-------------|------|-----------|
| `accelerometerData` | `AccelerometerEvent?` | Dados atuais do acelerômetro |
| `gyroscopeData` | `GyroscopeEvent?` | Dados atuais do giroscópio |
| `accelerationMagnitude` | `double` | Magnitude total da aceleração |
| `isListening` | `bool` | Se está coletando dados |

## 📐 Entendendo os Eixos

```
     Y (topo do dispositivo)
     ↑
     |
     |
     |————————→ X (lado direito)
    /
   /
  ↙
 Z (saindo da tela)
```

## 🎮 Aplicações Práticas

1. **Jogos** - Controle por inclinação
2. **Fitness** - Contador de passos
3. **Navegação** - Detecção de orientação
4. **Segurança** - Detecção de quedas
5. **Fotografia** - Estabilização de imagem

## 💡 Dicas para Aula

1. **Demonstre** movimentando o dispositivo
2. **Explique** a diferença entre acelerômetro e giroscópio
3. **Mostre** como os valores mudam com movimento
4. **Discuta** aplicações no mundo real
5. **Compare** com sensores de outros dispositivos

## ⚠️ Considerações Importantes

- **Consumo de bateria** - Sensores consomem energia
- **Frequência** - Mais dados = mais processamento
- **Ruído** - Dados podem ter pequenas variações
- **Calibração** - Dispositivos podem ter offsets
