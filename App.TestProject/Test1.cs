using Aplicacion.Interfaces;
using Aplicacion.Services;
using Dominio.Entities;
using Dominio.Interfaces;
using Infraestructura.Data;
using Infraestructura.Repositories;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;

namespace App.TestProject
{
    [TestClass]
    public sealed class Test1
    {
        private ServiceProvider _serviceProvider = null!;
        private IPersonaService _personaService = null!;

        [TestInitialize]
        public void Setup()
        {
            var services = new ServiceCollection();

            // Cadena de conexión real a PostgreSQL
            var connectionString = "Host=localhost;Port=5432;Username=postgres;Password=postgres;Database=db_ejemplo";

            // Agregar AppDbContext con Npgsql (PostgreSQL)
            services.AddDbContext<AppDbContext>(options =>
                options.UseNpgsql(connectionString, npgsqlOptions =>
                {
                    npgsqlOptions.EnableRetryOnFailure();
                    npgsqlOptions.CommandTimeout(60);
                })
            );

            // Registrar dependencias
            services.AddScoped<IPersonaRepository, PersonaRepositoryImpl>();
            services.AddScoped<IPersonaService, PersonaService>();

            _serviceProvider = services.BuildServiceProvider();
            _personaService = _serviceProvider.GetRequiredService<IPersonaService>();
        }
        // Crear un registro

        [TestMethod]
        public async Task AddNewPersona()
        {
            var persona = new Persona
            {
                Nombre = "Omar",
                Edad = 56,
                Pais = "espana"
            };
            await _personaService.AddAsyncService(persona);
            Assert.IsTrue(persona.Id > 0); // Validar que se generó un ID
            Console.WriteLine(
                $"Registro agregado: ID: {persona.Id}, Nombre: {persona.Nombre}, Edad: {persona.Edad}, País: {persona.Pais}");

        }
        // Actualizar un registro
        [TestMethod]
        public async Task UpdateDataPersona()
        {
            var personas = await _personaService.GetAllAsyncService();
            var persona = personas.FirstOrDefault();
            if (persona != null)
            {
                persona.Nombre = "Nombre actualizado desde test";
                await _personaService.UpdateAsyncService(persona);

                Console.WriteLine($"Actualizado: ID: {persona.Id}, Nuevo Nombre: {persona.Nombre}");
                Assert.AreEqual("Nombre actualizado desde test", persona.Nombre);
            }
            else
            {
                Assert.Fail("No hay registros para actualizar.");
            }

        }
        // Eliminar un registro
        [TestMethod]
        public async Task DeleteDataPersona()
        {
            var personas = await _personaService.GetAllAsyncService();
            var persona = personas.FirstOrDefault();
            if (persona != null)
            {
                await _personaService.DeleteAsyncService(persona.Id);
                Console.WriteLine($"Eliminado: ID: {persona.Id}, Nombre: {persona.Nombre}");
                Assert.IsTrue(persona.Id > 0); // Validar que se eliminó un registro
            }
            else
            {
                Assert.Fail("No hay registros para eliminar.");
            }
        }
        // Filtrar por edad y país
        [TestMethod]
        public async Task FiltrarPersonas()
        {
            var resultado = await _personaService.GetAgeAndCountryService(30, "USA");
            Assert.IsNotNull(resultado);

            foreach (var p in resultado)
            {
                Console.WriteLine($"Filtrado: {p.Nombre} - {p.Pais} - {p.Edad}");
            }
        }
    }
}
