#!/bin/bash

# Script de demonstração para listar Pokemon (versão offline para testes)
# Esta versão usa dados simulados para demonstrar a funcionalidade

set -e

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Base URL da PokeAPI
API_BASE_URL="https://pokeapi.co/api/v2/pokemon"

# Array com alguns Pokemon de exemplo para demonstração
declare -A DEMO_POKEMON=(
    [1]="bulbasaur|0.7|6.9"
    [2]="ivysaur|1.0|13.0"
    [3]="venusaur|2.0|100.0"
    [4]="charmander|0.6|8.5"
    [5]="charmeleon|1.1|19.0"
    [6]="charizard|1.7|90.5"
    [7]="squirtle|0.5|9.0"
    [8]="wartortle|1.0|22.5"
    [9]="blastoise|1.6|85.5"
    [10]="caterpie|0.3|2.9"
)

# Função para mostrar o header
show_header() {
    echo -e "${BLUE}================================${NC}"
    echo -e "${BLUE}   Demo: Primeiros Pokemon${NC}"
    echo -e "${BLUE}================================${NC}"
    echo ""
}

# Função para simular dados de Pokemon
get_demo_pokemon_data() {
    local pokemon_id=$1
    
    if [[ -n "${DEMO_POKEMON[$pokemon_id]}" ]]; then
        echo "${DEMO_POKEMON[$pokemon_id]}"
        return 0
    else
        # Simular dados para Pokemon não listados explicitamente
        local name="pokemon$pokemon_id"
        local height=$(echo "scale=1; ($pokemon_id % 10 + 5) / 10" | bc)
        local weight=$(echo "scale=1; $pokemon_id % 50 + 10" | bc)
        echo "$name|$height|$weight"
        return 0
    fi
}

# Função principal para listar Pokemon (versão demo)
demo_list_pokemon() {
    local start_id=${1:-1}
    local end_id=${2:-10}
    local count=0
    
    echo -e "${YELLOW}Modo demonstração - usando dados simulados${NC}"
    echo -e "${GREEN}Listando Pokemon ${start_id} a ${end_id}...${NC}"
    echo ""
    
    # Header da tabela
    printf "%-4s %-20s %-10s %-10s\n" "ID" "Nome" "Altura(m)" "Peso(kg)"
    printf "%-4s %-20s %-10s %-10s\n" "----" "--------------------" "----------" "----------"
    
    for pokemon_id in $(seq $start_id $end_id); do
        count=$((count + 1))
        
        pokemon_info=$(get_demo_pokemon_data $pokemon_id)
        IFS='|' read -r name height weight <<< "$pokemon_info"
        
        printf "%-4s %-20s %-10s %-10s\n" "$pokemon_id" "$name" "$height" "$weight"
    done
    
    echo ""
    echo -e "${GREEN}Demo concluída! Total: $count Pokemon${NC}"
}

# Função para mostrar informações sobre o script real
show_real_usage() {
    echo -e "${BLUE}================================${NC}"
    echo -e "${BLUE}   Como usar o script real${NC}"
    echo -e "${BLUE}================================${NC}"
    echo ""
    echo "Para usar o script real com a PokeAPI:"
    echo ""
    echo -e "${GREEN}1. Execute o script principal:${NC}"
    echo "   ./list_pokemon.sh"
    echo ""
    echo -e "${GREEN}2. Teste a conectividade:${NC}"
    echo "   ./list_pokemon.sh --test"
    echo ""
    echo -e "${GREEN}3. Liste um intervalo específico:${NC}"
    echo "   ./list_pokemon.sh -r 1 50"
    echo ""
    echo -e "${GREEN}4. Veja todas as opções:${NC}"
    echo "   ./list_pokemon.sh --help"
    echo ""
    echo -e "${YELLOW}Nota: É necessário conexão com a internet para acessar a PokeAPI${NC}"
}

# Executar demonstração
echo -e "${YELLOW}Este é o script de demonstração${NC}"
echo ""

show_header
demo_list_pokemon 1 10

echo ""
show_real_usage