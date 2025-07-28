# ===============================================
# Script de Respaldo PostgreSQL para Windows
# Proyecto: CleanArchPersona
# Fecha: 27 de Julio, 2025
# ===============================================

# Configuración de la base de datos
$DB_HOST = "localhost"
$DB_PORT = "5432"
$DB_NAME = "db_ejemplo"
$DB_USER = "postgres"

# Configuración de respaldo
$BACKUP_DIR = ".\backups"
$DATE = Get-Date -Format "yyyyMMdd_HHmmss"
$BACKUP_FILE = "backup_${DB_NAME}_${DATE}.sql"
$BACKUP_PATH = "$BACKUP_DIR\$BACKUP_FILE"

Write-Host "🗄️  Script de Respaldo PostgreSQL" -ForegroundColor Blue
Write-Host "===================================" -ForegroundColor Blue
Write-Host ""

# Crear directorio de respaldos si no existe
if (!(Test-Path $BACKUP_DIR)) {
    Write-Host "📁 Creando directorio de respaldos..." -ForegroundColor Yellow
    New-Item -ItemType Directory -Path $BACKUP_DIR -Force | Out-Null
}

# Verificar que pg_dump esté disponible
try {
    $null = Get-Command pg_dump -ErrorAction Stop
    Write-Host "✅ pg_dump encontrado" -ForegroundColor Green
} catch {
    Write-Host "❌ Error: pg_dump no encontrado en PATH" -ForegroundColor Red
    Write-Host "   Asegúrate de que PostgreSQL esté instalado y en PATH" -ForegroundColor Red
    Write-Host "   Usualmente en: C:\Program Files\PostgreSQL\[version]\bin" -ForegroundColor Yellow
    exit 1
}

# Crear respaldo completo
Write-Host "💾 Creando respaldo completo..." -ForegroundColor Yellow
Write-Host "   Archivo: $BACKUP_PATH" -ForegroundColor Blue

try {
    & pg_dump -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME --verbose --clean --if-exists --create --format=plain --file="$BACKUP_PATH"
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Respaldo creado exitosamente" -ForegroundColor Green
        
        # Mostrar información del archivo
        $FileInfo = Get-Item $BACKUP_PATH
        $FileSize = [math]::Round($FileInfo.Length / 1KB, 2)
        Write-Host "📊 Tamaño del archivo: $FileSize KB" -ForegroundColor Green
        Write-Host "📂 Ubicación: $BACKUP_PATH" -ForegroundColor Green
        
        # Crear respaldo solo de datos
        $DATA_BACKUP_FILE = "data_${DB_NAME}_${DATE}.sql"
        $DATA_BACKUP_PATH = "$BACKUP_DIR\$DATA_BACKUP_FILE"
        
        Write-Host "💾 Creando respaldo solo de datos..." -ForegroundColor Yellow
        & pg_dump -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME --data-only --inserts --file="$DATA_BACKUP_PATH"
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ Respaldo de datos creado: $DATA_BACKUP_PATH" -ForegroundColor Green
        }
        
    } else {
        Write-Host "❌ Error al crear el respaldo" -ForegroundColor Red
        exit 1
    }
} catch {
    Write-Host "❌ Error al ejecutar pg_dump: $_" -ForegroundColor Red
    exit 1
}

# Limpiar respaldos antiguos (mantener solo los últimos 5)
Write-Host "🧹 Limpiando respaldos antiguos..." -ForegroundColor Yellow
$BackupFiles = Get-ChildItem "$BACKUP_DIR\backup_${DB_NAME}_*.sql" | Sort-Object LastWriteTime -Descending
if ($BackupFiles.Count -gt 5) {
    $BackupFiles[5..($BackupFiles.Count-1)] | Remove-Item -Force
}

$DataFiles = Get-ChildItem "$BACKUP_DIR\data_${DB_NAME}_*.sql" | Sort-Object LastWriteTime -Descending
if ($DataFiles.Count -gt 5) {
    $DataFiles[5..($DataFiles.Count-1)] | Remove-Item -Force
}

# Mostrar lista de respaldos disponibles
Write-Host ""
Write-Host "📋 Respaldos disponibles:" -ForegroundColor Blue
Get-ChildItem "$BACKUP_DIR\backup_${DB_NAME}_*.sql" | Sort-Object LastWriteTime -Descending | Select-Object -First 5 | Format-Table Name, Length, LastWriteTime

Write-Host ""
Write-Host "🎉 Proceso de respaldo completado exitosamente" -ForegroundColor Green

# Mostrar comandos para restaurar
Write-Host ""
Write-Host "📖 Para restaurar este respaldo:" -ForegroundColor Blue
Write-Host "   Respaldo completo:" -ForegroundColor Yellow
Write-Host "   psql -h $DB_HOST -p $DB_PORT -U $DB_USER -f `"$BACKUP_PATH`"" -ForegroundColor White
Write-Host ""
Write-Host "   Solo datos:" -ForegroundColor Yellow
Write-Host "   psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -f `"$DATA_BACKUP_PATH`"" -ForegroundColor White

Write-Host ""
Write-Host "💡 Tip: Puedes programar este script para ejecutarse automáticamente" -ForegroundColor Cyan
