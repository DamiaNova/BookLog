using System.Diagnostics;
using BookLOG.Models;
using Microsoft.AspNetCore.Mvc;

namespace BookLOG.Controllers
{
    /// <summary>
    /// Osnovna klasa koja omogućuje pristup funkcijama potrebnim za MVC obrazac
    /// </summary>
    public class HomeController : Controller
    {
        /// <summary>
        /// Privatna varijabla koja se koristi u svrhu zapisivanja logova u aplikaciji
        /// </summary>
        private readonly ILogger<HomeController> _logger;

        /// <summary>
        /// Konstruktor klase sa ulaznim parametrom za injektiranje zavisnosti
        /// </summary>
        public HomeController(ILogger<HomeController> logger)
        {
            _logger = logger;
        }

        /// <summary>
        /// Akcija koja se poziva kada korisnik zatraži početnu stranicu (naslovnicu)
        /// </summary>
        public IActionResult Index()
        {
            return View();
        }

        /// <summary>
        /// Akcija koja se poziva kada korisnik zatraži stranicu Politike privatnosti
        /// </summary>
        public IActionResult Privacy()
        {
            return View();
        }

        /// <summary>
        /// Akcija koja prikazuje stranicu sa greškom i bilježi specifične informacije o grešci
        /// Atribut 'ResponseCache' određuje da se odgovor na zahtjev ne sprema u cache kako bi se spriječilo pohranjivanje osjetljivih informacija
        /// </summary>
        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }
    }
}
