using Dominio.Entities;
using Dominio.Interfaces;
using Infraestructura.Data;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Infraestructura.Repositories
{
    public class PersonaRepositoryImpl : RepositoryImpl<Persona>, IPersonaRepository
    {
        public PersonaRepositoryImpl(AppDbContext context) : base(context)
        {
        }
        public async Task<IEnumerable<Persona>> GetAgeAndCountry(int edad, string pais)
        {
            return await ((AppDbContext)_context).Persona
                .Where(p => p.Edad == edad && p.Pais == pais)
                .ToListAsync();
        }
    }
}
