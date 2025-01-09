using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace BookLog.DataAccess.Classes
{
    /// <summary>
    /// Klasa za rad sa tablicom USER_LOGIN_PROFILES
    /// </summary>
    [Table("USER_LOGIN_PROFILES")]
    public class UserLoginProfile
    {
        /// <summary>
        /// Primarni ključ s automatskom sekvencom (ULP.ID)
        /// </summary>
        [Key]
        public int ID { get; set; }

        /// <summary>
        /// Naziv korisničkog profila (maksimalno 10 znakova)
        /// </summary>
        [Required]
        [StringLength(100)]
        public string ProfileName { get; set; }

        /// <summary>
        /// Jedinstveni broj profila, obavezno polje
        /// </summary>
        [Required]
        [Length(5,5)]
        public int ProfileNumber { get; set; }

        /// <summary>
        /// Jedinstveni inicijali korisnika
        /// </summary>
        [StringLength(3)]
        public string ProfileInitials { get; set; }

        /// <summary>
        /// Korisnik (inicijali) koji je kreirao profil
        /// </summary>
        [StringLength(3)]
        public string CreatedBy { get; set; }

        /// <summary>
        /// Datum kreiranja
        /// </summary>
        public DateTime CreationDate { get; set; }
    }
}