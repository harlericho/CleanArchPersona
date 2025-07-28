# 🗄️ Configuración de Base de Datos PostgreSQL

## 📋 Requisitos Previos

1. **PostgreSQL instalado** (versión 12 o superior recomendada)
2. **Cliente psql** o herramienta gráfica como pgAdmin
3. **Usuario postgres** con permisos de administración

## 🚀 Configuración Inicial

### 1. Instalar PostgreSQL

**Windows:**

```bash
# Descargar desde: https://www.postgresql.org/download/windows/
# O usar Chocolatey:
choco install postgresql
```

**macOS:**

```bash
# Usar Homebrew:
brew install postgresql
brew services start postgresql
```

**Linux (Ubuntu/Debian):**

```bash
sudo apt update
sudo apt install postgresql postgresql-contrib
sudo systemctl start postgresql
sudo systemctl enable postgresql
```

### 2. Configurar Usuario y Base de Datos

```sql
-- Conectar como superusuario
sudo -u postgres psql

-- Crear base de datos
CREATE DATABASE db_ejemplo;

-- Crear usuario (opcional, si no usas postgres)
CREATE USER app_user WITH ENCRYPTED PASSWORD 'tu_password';
GRANT ALL PRIVILEGES ON DATABASE db_ejemplo TO app_user;

-- Salir
\q
```

### 3. Ejecutar Script de Tabla

```bash
# Opción 1: Desde línea de comandos
psql -h localhost -p 5432 -U postgres -d db_ejemplo -f Database/script_tabla_persona.sql

# Opción 2: Desde psql interactivo
psql -h localhost -p 5432 -U postgres -d db_ejemplo
\i Database/script_tabla_persona.sql
```

## 🔧 Cadena de Conexión

La aplicación usa esta configuración en `Program.cs`:

```csharp
string connectionString = "Host=localhost;Port=5432;Username=postgres;Password=postgres;Database=db_ejemplo";
```

### Personalizar la Conexión

Si necesitas cambiar la configuración, modifica estos valores:

| Parámetro  | Valor por Defecto | Descripción                |
| ---------- | ----------------- | -------------------------- |
| `Host`     | `localhost`       | Servidor PostgreSQL        |
| `Port`     | `5432`            | Puerto PostgreSQL          |
| `Username` | `postgres`        | Usuario de conexión        |
| `Password` | `postgres`        | Contraseña del usuario     |
| `Database` | `db_ejemplo`      | Nombre de la base de datos |

## 🧪 Verificar Configuración

### Probar Conexión

```bash
# Conectar a la base de datos
psql -h localhost -p 5432 -U postgres -d db_ejemplo

# Verificar tabla creada
\dt

# Ver estructura de la tabla
\d persona

# Consultar datos
SELECT * FROM persona;
```

### Comandos Útiles de PostgreSQL

```sql
-- Ver todas las bases de datos
\l

-- Ver todas las tablas
\dt

-- Ver estructura de una tabla
\d nombre_tabla

-- Ver usuarios
\du

-- Cambiar a otra base de datos
\c nombre_base

-- Salir
\q
```

## 🔧 Solución de Problemas Comunes

### Error: "Connection refused"

```bash
# Verificar que PostgreSQL esté corriendo
sudo systemctl status postgresql  # Linux
brew services list | grep postgresql  # macOS

# Iniciar servicio si está detenido
sudo systemctl start postgresql  # Linux
brew services start postgresql  # macOS
```

### Error: "Authentication failed"

```bash
# Verificar configuración en pg_hba.conf
sudo nano /etc/postgresql/[version]/main/pg_hba.conf

# Cambiar método de autenticación si es necesario
# local   all             postgres                                md5
```

### Error: "Database does not exist"

```sql
-- Crear la base de datos manualmente
CREATE DATABASE db_ejemplo;
```

## 📊 Herramientas Recomendadas

### Línea de Comandos

- **psql**: Cliente oficial de PostgreSQL
- **pg_dump**: Para respaldos
- **pg_restore**: Para restaurar respaldos

### Herramientas Gráficas

- **pgAdmin 4**: Interfaz web oficial
- **DBeaver**: Cliente universal gratuito
- **DataGrip**: IDE comercial de JetBrains
- **Azure Data Studio**: Con extensión PostgreSQL

## 🔄 Migrations con Entity Framework

Si prefieres usar migraciones de EF Core en lugar del script SQL:

```bash
# Instalar herramientas EF (si no están instaladas)
dotnet tool install --global dotnet-ef

# Crear migración inicial
dotnet ef migrations add InitialCreate --project Infraestructura --startup-project App.Consola

# Aplicar migración a la base de datos
dotnet ef database update --project Infraestructura --startup-project App.Consola
```

## 📝 Notas Importantes

1. **Seguridad**: Cambia las contraseñas por defecto en producción
2. **Respaldos**: Programa respaldos regulares de tu base de datos
3. **Índices**: Los índices en el script mejoran el rendimiento
4. **Datos**: Los datos de prueba son opcionales
5. **Permisos**: Asegúrate de que el usuario tenga los permisos necesarios

## 🎯 Próximos Pasos

1. Ejecutar el script SQL
2. Verificar que la tabla esté creada correctamente
3. Probar la conexión desde la aplicación
4. Ejecutar los tests para validar la funcionalidad
