using Dominio.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Aplicacion.Interfaces
{
    public interface IPersonaService
    {
        Task<IEnumerable<Persona>> GetAllAsyncService();
        Task<Persona?> GetByIdAsyncService(int id);
        Task AddAsyncService(Persona persona);
        Task UpdateAsyncService(Persona persona);
        Task DeleteAsyncService(int id);
        Task<IEnumerable<Persona>> GetAgeAndCountryService(int edad, string pais);
    }
}
