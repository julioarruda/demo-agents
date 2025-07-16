# Demo Agents - Pokemon Script

Este repositório contém scripts para listar Pokemon usando a PokeAPI pública.

## Scripts Disponíveis

### 1. `list_pokemon.sh` - Script Principal

Script completo que busca dados da [PokeAPI](https://pokeapi.co/) para listar os primeiros 150 Pokemon.

#### Características:
- Lista Pokemon com ID, nome, altura e peso
- Suporte a intervalos customizados
- Tratamento de erros e retry automático
- Interface colorida e amigável
- Verificação de dependências

#### Uso:

```bash
# Listar os primeiros 150 Pokemon (padrão)
./list_pokemon.sh

# Listar Pokemon em um intervalo específico
./list_pokemon.sh -r 1 50

# Testar conectividade com a API
./list_pokemon.sh --test

# Ver ajuda
./list_pokemon.sh --help

# Ver versão
./list_pokemon.sh --version
```

#### Dependências:
- `curl` - para fazer requisições HTTP
- `jq` - para processar JSON
- `bc` - para cálculos (opcional)

### 2. `demo_pokemon.sh` - Script de Demonstração

Script que demonstra a funcionalidade usando dados simulados, útil para testes sem conexão com a internet.

#### Uso:

```bash
./demo_pokemon.sh
```

## Instalação de Dependências

### Ubuntu/Debian:
```bash
sudo apt-get update
sudo apt-get install curl jq bc
```

### CentOS/RHEL:
```bash
sudo yum install curl jq bc
```

### macOS:
```bash
brew install curl jq bc
```

## Exemplo de Saída

```
================================
   Lista dos Primeiros 150 Pokemon
================================

Buscando Pokemon 1 a 10...

ID   Nome                 Altura(m)  Peso(kg)  
---- -------------------- ---------- ----------
1    bulbasaur            0.7        6.9       
2    ivysaur              1.0        13.0      
3    venusaur             2.0        100.0     
4    charmander           0.6        8.5       
5    charmeleon           1.1        19.0      
6    charizard            1.7        90.5      
7    squirtle             0.5        9.0       
8    wartortle            1.0        22.5      
9    blastoise            1.6        85.5      
10   caterpie             0.3        2.9       
```

## API Utilizada

O script utiliza a [PokeAPI](https://pokeapi.co/), uma API RESTful gratuita para dados de Pokemon.

- **Endpoint**: `https://pokeapi.co/api/v2/pokemon/{id}`
- **Método**: GET
- **Formato**: JSON

## Tratamento de Erros

O script inclui:
- Verificação de dependências
- Teste de conectividade
- Retry automático em caso de falha
- Timeout para requisições
- Mensagens de erro descritivas

## Contribuição

Para contribuir com melhorias:
1. Fork o repositório
2. Crie uma branch para sua feature
3. Faça commit das mudanças
4. Abra um Pull Request