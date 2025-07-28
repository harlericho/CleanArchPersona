#!/bin/bash

# ===============================================
# Script de Respaldo PostgreSQL
# Proyecto: CleanArchPersona
# Fecha: 27 de Julio, 2025
# ===============================================

# Configuración de la base de datos
DB_HOST="localhost"
DB_PORT="5432"
DB_NAME="db_ejemplo"
DB_USER="postgres"

# Configuración de respaldo
BACKUP_DIR="./backups"
DATE=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="backup_${DB_NAME}_${DATE}.sql"
BACKUP_PATH="${BACKUP_DIR}/${BACKUP_FILE}"

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🗄️  Script de Respaldo PostgreSQL${NC}"
echo -e "${BLUE}===================================${NC}"
echo ""

# Crear directorio de respaldos si no existe
if [ ! -d "$BACKUP_DIR" ]; then
    echo -e "${YELLOW}📁 Creando directorio de respaldos...${NC}"
    mkdir -p "$BACKUP_DIR"
fi

# Verificar conexión a la base de datos
echo -e "${YELLOW}🔍 Verificando conexión a la base de datos...${NC}"
if ! pg_isready -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME > /dev/null 2>&1; then
    echo -e "${RED}❌ Error: No se puede conectar a la base de datos${NC}"
    echo -e "${RED}   Verifica que PostgreSQL esté corriendo y la configuración sea correcta${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Conexión exitosa${NC}"

# Crear respaldo completo
echo -e "${YELLOW}💾 Creando respaldo completo...${NC}"
echo -e "${BLUE}   Archivo: ${BACKUP_PATH}${NC}"

pg_dump -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME \
    --verbose \
    --clean \
    --if-exists \
    --create \
    --format=plain \
    --file="$BACKUP_PATH"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Respaldo creado exitosamente${NC}"
    
    # Mostrar información del archivo
    FILE_SIZE=$(ls -lh "$BACKUP_PATH" | awk '{print $5}')
    echo -e "${GREEN}📊 Tamaño del archivo: ${FILE_SIZE}${NC}"
    echo -e "${GREEN}📂 Ubicación: ${BACKUP_PATH}${NC}"
    
    # Crear respaldo solo de datos (INSERT statements)
    DATA_BACKUP_FILE="data_${DB_NAME}_${DATE}.sql"
    DATA_BACKUP_PATH="${BACKUP_DIR}/${DATA_BACKUP_FILE}"
    
    echo -e "${YELLOW}💾 Creando respaldo solo de datos...${NC}"
    pg_dump -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME \
        --data-only \
        --inserts \
        --file="$DATA_BACKUP_PATH"
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Respaldo de datos creado: ${DATA_BACKUP_PATH}${NC}"
    fi
    
else
    echo -e "${RED}❌ Error al crear el respaldo${NC}"
    exit 1
fi

# Limpiar respaldos antiguos (mantener solo los últimos 5)
echo -e "${YELLOW}🧹 Limpiando respaldos antiguos...${NC}"
cd "$BACKUP_DIR"
ls -t backup_${DB_NAME}_*.sql | tail -n +6 | xargs -r rm
ls -t data_${DB_NAME}_*.sql | tail -n +6 | xargs -r rm
cd - > /dev/null

# Mostrar lista de respaldos disponibles
echo ""
echo -e "${BLUE}📋 Respaldos disponibles:${NC}"
ls -lht "$BACKUP_DIR"/backup_${DB_NAME}_*.sql 2>/dev/null | head -5

echo ""
echo -e "${GREEN}🎉 Proceso de respaldo completado exitosamente${NC}"

# Mostrar comandos para restaurar
echo ""
echo -e "${BLUE}📖 Para restaurar este respaldo:${NC}"
echo -e "${YELLOW}   Respaldo completo:${NC}"
echo -e "   psql -h $DB_HOST -p $DB_PORT -U $DB_USER -f \"$BACKUP_PATH\""
echo ""
echo -e "${YELLOW}   Solo datos:${NC}"
echo -e "   psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -f \"$DATA_BACKUP_PATH\""
