using Microsoft.AspNetCore.Mvc;

namespace BookLOG.Controllers
{
    /// <summary>
    /// Osnovna klasa koja omogućuje pristup funkcijama potrebnim za MVC obrazac
    /// </summary>
    public class KorisnickiRacunController : Controller
    {
        /// <summary>
        /// Akcija koja se poziva kada korisnik zatraži stranicu za Login
        /// </summary>
        public IActionResult Login()
        {
            return View();
        }
    }
}
