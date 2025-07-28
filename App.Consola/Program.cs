// See https://aka.ms/new-console-template for more information
using Aplicacion.Interfaces;
using Aplicacion.Services;
using Dominio.Interfaces;
using Infraestructura.Data;
using Infraestructura.Repositories;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using System.Security.Authentication.ExtendedProtection;

Console.WriteLine("Hello, World!");
// Configurar servicios e inyección de dependencias
var services = new ServiceCollection();
// Cambia la cadena de conexión según tu base (SQL Server o PostgreSQL)
string connectionString = "Host=localhost;Port=5432;Username=postgres;Password=postgres;Database=db_ejemplo";
services.AddDbContext<AppDbContext>(options =>
    options.UseNpgsql(connectionString, npgsqlOptions =>
    {
        npgsqlOptions.EnableRetryOnFailure();
        npgsqlOptions.CommandTimeout(60);
    })
);
// Registrar repositorios y servicios con sus interfaces
services.AddScoped<IPersonaRepository, PersonaRepositoryImpl>();
services.AddScoped<IPersonaService, PersonaService>();
var provider = services.BuildServiceProvider();
var personaService = provider.GetRequiredService<IPersonaService>();

// Crear un registro
await personaService.AddAsyncService(new Dominio.Entities.Persona
{
    Nombre = "juan",
    Edad = 30,
    Pais = "colombia"
});
// Obtener todos los registros
var personas = await personaService.GetAllAsyncService();
foreach (var persona in personas)
{
    Console.WriteLine($"ID: {persona.Id}, Nombre: {persona.Nombre}, Edad: {persona.Edad}, País: {persona.Pais}");
}
// Actualizar un registro
var personaToUpdate = personas.FirstOrDefault();
if (personaToUpdate != null)
{
    personaToUpdate.Nombre = "Juan Actualizado";
    await personaService.UpdateAsyncService(personaToUpdate);
    Console.WriteLine($"Registro actualizado: ID: {personaToUpdate.Id}, Nombre: {personaToUpdate.Nombre}");
}

// Consultar por edad y país
var personasFiltradas = await personaService.GetAgeAndCountryService(30, "colombia");
foreach (var persona in personasFiltradas)
{
    Console.WriteLine($"ID: {persona.Id}, Nombre: {persona.Nombre}, Edad: {persona.Edad}, País: {persona.Pais}");
}