using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;

namespace BookLog.DataAccess.Classes
{
    /// <summary>
    /// Klasa koja se koristi u aplikacijama koje koriste Entity Framework Core
    /// Svrha klase je upravljanje komunikacijom s bazom podataka
    /// Omogućava rad s bazom podataka koristeći C# objekte umjesto SQL upita
    /// </summary>
    public class AppDbContext : DbContext
    {
        /// <summary>
        /// Konstruktor
        /// </summary>
        public AppDbContext(DbContextOptions<AppDbContext> options) : base(options) { }

        /// <summary>
        /// Mapira klasu (entitet) u aplikaciji na tablicu USER_LOGIN_PROFILES u bazi podataka
        /// </summary>
        public DbSet<UserLoginProfile> UserLoginProfiles { get; set; }
    }
}
