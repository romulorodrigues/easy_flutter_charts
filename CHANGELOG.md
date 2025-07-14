## 1.0.6 

### Adicionado
- Suporte a rótulos multilinha no eixo X do `LineChart`.
- Agora é possível passar uma lista de `String` como item no `xAxis`, e cada linha será exibida verticalmente empilhada (um texto abaixo do outro).
  ```dart
  xAxis: [
    'Jan',
    ['Fev', '2024'],
    'Mar',
    ['Abril', 'Completo']
  ]

## 1.0.5

### Atualizado

- Atualização de imagem do LineChart no README.
- Substituição de `Container` por `SizedBox` para adicionar espaçamento visual conforme recomendação do linter.
- Ajustes em interpolação de strings para seguir boas práticas (`'$var'` → `${var}` quando necessário).
- Uso de `super.key` em construtores para simplificar a passagem da chave.

## 1.0.4

### Adicionado

- Suporte completo ao uso de `xAxis` personalizado no `LineChart`.
- Propriedade `xAxis` agora é **obrigatória** no `LineChart` para garantir consistência nos dados exibidos.

## 1.0.3

- Reduzida a descrição do `pubspec.yaml`.
- Incluído campo `repository:` no `pubspec.yaml`.
- Substituído uso de `withOpacity(0.2)` por `Color.fromRGBO(128, 128, 128, 0.2)` para remover aviso de API obsoleta.

## 1.0.2

### Adicionado

- Exemplo com imagens no README.

## 1.0.1

- Atualização do README.

## 1.0.0

- Primeira release

## 0.0.1

- TODO: Describe initial release.
