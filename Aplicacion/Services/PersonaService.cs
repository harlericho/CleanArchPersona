using Aplicacion.Interfaces;
using Dominio.Entities;
using Dominio.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Aplicacion.Services
{
    public class PersonaService : IPersonaService
    {
        private readonly IPersonaRepository _personaRepository;
        public PersonaService(IPersonaRepository personaRepository)
        {
            _personaRepository = personaRepository ?? throw new ArgumentNullException(nameof(personaRepository));
        }

        public Task AddAsyncService(Persona persona) =>
            _personaRepository.AddAsync(persona);

        public Task DeleteAsyncService(int id) =>
            _personaRepository.DeleteAsync(id);

        public Task<IEnumerable<Persona>> GetAgeAndCountryService(int edad, string pais) =>
            _personaRepository.GetAgeAndCountry(edad, pais);

        public Task<IEnumerable<Persona>> GetAllAsyncService() =>
            _personaRepository.GetAllAsync();

        public Task<Persona?> GetByIdAsyncService(int id) =>
            _personaRepository.GetByIdAsync(id);

        public Task UpdateAsyncService(Persona persona) => _personaRepository.UpdateAsync(persona);
    }
}
