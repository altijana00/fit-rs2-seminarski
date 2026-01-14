using System.Security.Cryptography;
using System.Text;


namespace ZEN_Yoga.Models.Helpers
{
    public static class PasswordHelpers
    {

        private const int KeySize = 32;
        private const int Iterations = 100_000;

        public static (string Hash, string Salt) HashPassword(string password)
        {

            byte[] saltBytes = Encoding.UTF8.GetBytes("rs2rs2123");
            string salt = Convert.ToBase64String(saltBytes);


            using var pbkdf2 = new Rfc2898DeriveBytes(password, saltBytes, Iterations, HashAlgorithmName.SHA256);
            byte[] hashBytes = pbkdf2.GetBytes(KeySize);
            string hash = Convert.ToBase64String(hashBytes);

            return (hash, salt);
        }





    }
}
