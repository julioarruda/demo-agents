#!/bin/bash

# Script para listar os primeiros 150 Pokemon usando a PokeAPI
# Lista os primeiros 150 Pokemon buscando dados na API publica de Pokemon

set -e  # Exit on any error

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Base URL da PokeAPI
API_BASE_URL="https://pokeapi.co/api/v2/pokemon"

# Função para mostrar o header
show_header() {
    echo -e "${BLUE}================================${NC}"
    echo -e "${BLUE}   Lista dos Primeiros 150 Pokemon${NC}"
    echo -e "${BLUE}================================${NC}"
    echo ""
}

# Função para verificar dependências
check_dependencies() {
    if ! command -v curl &> /dev/null; then
        echo -e "${RED}Erro: curl não está instalado.${NC}"
        exit 1
    fi
    
    if ! command -v jq &> /dev/null; then
        echo -e "${RED}Erro: jq não está instalado.${NC}"
        echo -e "${YELLOW}Para instalar jq:${NC}"
        echo "  Ubuntu/Debian: sudo apt-get install jq"
        echo "  CentOS/RHEL: sudo yum install jq"
        echo "  macOS: brew install jq"
        exit 1
    fi
}

# Função para buscar dados de um Pokemon
get_pokemon_data() {
    local pokemon_id=$1
    local max_retries=3
    local retry=0
    
    while [ $retry -lt $max_retries ]; do
        response=$(curl -s --connect-timeout 10 --max-time 30 "${API_BASE_URL}/${pokemon_id}" 2>/dev/null)
        
        if [ $? -eq 0 ] && [ -n "$response" ]; then
            # Verifica se a resposta é um JSON válido
            if echo "$response" | jq . >/dev/null 2>&1; then
                echo "$response"
                return 0
            fi
        fi
        
        retry=$((retry + 1))
        if [ $retry -lt $max_retries ]; then
            echo -e "${YELLOW}Tentativa ${retry} falhou para Pokemon ID ${pokemon_id}, tentando novamente...${NC}" >&2
            sleep 1
        fi
    done
    
    echo -e "${RED}Erro ao buscar dados do Pokemon ID ${pokemon_id} após ${max_retries} tentativas${NC}" >&2
    return 1
}

# Função para extrair informações do Pokemon
extract_pokemon_info() {
    local json_data=$1
    local name height weight
    
    name=$(echo "$json_data" | jq -r '.name // "N/A"')
    height=$(echo "$json_data" | jq -r '.height // 0')
    weight=$(echo "$json_data" | jq -r '.weight // 0')
    
    # Converter altura de decímetros para metros
    height_m=$(echo "scale=1; $height / 10" | bc 2>/dev/null || echo "N/A")
    
    # Converter peso de hectogramas para quilogramas  
    weight_kg=$(echo "scale=1; $weight / 10" | bc 2>/dev/null || echo "N/A")
    
    echo "$name|$height_m|$weight_kg"
}

# Função principal para listar Pokemon
list_pokemon() {
    local start_id=${1:-1}
    local end_id=${2:-150}
    local count=0
    local success_count=0
    local error_count=0
    
    echo -e "${GREEN}Buscando Pokemon ${start_id} a ${end_id}...${NC}"
    echo ""
    
    # Header da tabela
    printf "%-4s %-20s %-10s %-10s\n" "ID" "Nome" "Altura(m)" "Peso(kg)"
    printf "%-4s %-20s %-10s %-10s\n" "----" "--------------------" "----------" "----------"
    
    for pokemon_id in $(seq $start_id $end_id); do
        count=$((count + 1))
        
        # Mostrar progresso a cada 10 Pokemon
        if [ $((count % 10)) -eq 0 ]; then
            echo -e "${YELLOW}Processando... ${count}/${end_id}${NC}" >&2
        fi
        
        pokemon_data=$(get_pokemon_data $pokemon_id)
        if [ $? -eq 0 ]; then
            info=$(extract_pokemon_info "$pokemon_data")
            IFS='|' read -r name height weight <<< "$info"
            
            printf "%-4s %-20s %-10s %-10s\n" "$pokemon_id" "$name" "$height" "$weight"
            success_count=$((success_count + 1))
        else
            printf "%-4s %-20s %-10s %-10s\n" "$pokemon_id" "Erro ao carregar" "N/A" "N/A"
            error_count=$((error_count + 1))
        fi
    done
    
    echo ""
    echo -e "${GREEN}Resumo:${NC}"
    echo -e "  Total processado: $count"
    echo -e "  Sucesso: ${GREEN}$success_count${NC}"
    echo -e "  Erros: ${RED}$error_count${NC}"
}

# Função para testar conectividade
test_api_connection() {
    echo -e "${YELLOW}Testando conectividade com a PokeAPI...${NC}"
    
    test_data=$(get_pokemon_data 1)
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ Conectividade OK${NC}"
        return 0
    else
        echo -e "${RED}✗ Falha na conectividade${NC}"
        echo -e "${YELLOW}Verifique sua conexão com a internet.${NC}"
        return 1
    fi
}

# Função para mostrar ajuda
show_help() {
    echo "Uso: $0 [opções]"
    echo ""
    echo "Opções:"
    echo "  -h, --help     Mostra esta ajuda"
    echo "  -t, --test     Testa conectividade com a API"
    echo "  -r, --range    Especifica intervalo (ex: -r 1 50)"
    echo "  -v, --version  Mostra versão do script"
    echo ""
    echo "Exemplos:"
    echo "  $0                    # Lista Pokemon 1-150"
    echo "  $0 -r 1 50           # Lista Pokemon 1-50"
    echo "  $0 --test            # Testa conectividade"
}

# Função para mostrar versão
show_version() {
    echo "Pokemon Lister v1.0"
    echo "Usando PokeAPI (https://pokeapi.co/)"
}

# Verificar se bc está disponível para cálculos
if ! command -v bc &> /dev/null; then
    echo -e "${YELLOW}Aviso: bc não está instalado. Altura e peso podem não ser calculados corretamente.${NC}"
fi

# Parsing de argumentos
START_ID=1
END_ID=150

while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            exit 0
            ;;
        -t|--test)
            check_dependencies
            test_api_connection
            exit $?
            ;;
        -r|--range)
            if [[ $# -lt 3 ]]; then
                echo -e "${RED}Erro: --range requer dois argumentos (início fim)${NC}"
                exit 1
            fi
            START_ID=$2
            END_ID=$3
            shift 2
            ;;
        -v|--version)
            show_version
            exit 0
            ;;
        *)
            echo -e "${RED}Opção desconhecida: $1${NC}"
            show_help
            exit 1
            ;;
    esac
    shift
done

# Validar argumentos
if ! [[ "$START_ID" =~ ^[0-9]+$ ]] || ! [[ "$END_ID" =~ ^[0-9]+$ ]]; then
    echo -e "${RED}Erro: IDs devem ser números inteiros${NC}"
    exit 1
fi

if [ "$START_ID" -gt "$END_ID" ]; then
    echo -e "${RED}Erro: ID inicial deve ser menor ou igual ao ID final${NC}"
    exit 1
fi

if [ "$END_ID" -gt 1010 ]; then
    echo -e "${YELLOW}Aviso: Existem apenas cerca de 1010 Pokemon. Alguns IDs podem não existir.${NC}"
fi

# Executar script principal
main() {
    show_header
    check_dependencies
    
    if ! test_api_connection; then
        exit 1
    fi
    
    echo ""
    list_pokemon $START_ID $END_ID
    
    echo ""
    echo -e "${GREEN}Script concluído!${NC}"
}

# Executar apenas se o script for chamado diretamente
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi