namespace BookLog.Objects.Constants
{
    /// <summary>
    /// Klasa za naslove Viewova aplikacije
    /// Definirana je kao STATIC kako bi se omogućio pristup njezinim članovima bez potrebe za instanciranjem objekta klase
    /// </summary>
    public static class ViewNaslovi
    {
        public const string Login          = "Login";                // Naslov za KorisnickiRacun/Login
        public const string Registracija   = "Registracija";         // Naslov za KorisnickiRacun/Registracija
        public const string PregledProfila = "Profil";               // Naslov za KorisnickiRacun/PregledProfila
        public const string HomeIndex      = "Naslovnica";           // Naslov za Home/Index
        public const string Privacy        = "Politika privatnosti"; // Naslov za Home/Privacy
    }
}