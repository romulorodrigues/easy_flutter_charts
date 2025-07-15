## 1.0.8

### Alterado

- Cor padrão dos rótulos dos eixos X e Y definida como preta quando nenhum estilo é informado.

### Adicionado

- Margem superior de 8px adicionada aos labels do eixo X para melhor espaçamento visual.

## 1.0.7

### Alterado

- O tooltip do `LineChart` agora se adapta automaticamente ao conteúdo, incluindo:
  - Rótulos com múltiplas linhas;
  - Textos longos com quebra automática de linha;
  - Expansão vertical automática sem overflow;
  - Largura máxima limitada para melhor responsividade.
- Melhoria na legibilidade e estilo do conteúdo exibido no tooltip.

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
  ```

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
