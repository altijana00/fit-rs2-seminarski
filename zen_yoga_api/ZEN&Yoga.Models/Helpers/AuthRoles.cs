namespace ZEN_Yoga.Models.Helpers
{
    public static class AuthRoles
    {
        public const string Admin = "1";
        public const string Owner = "2";
        public const string Instructor = "3";
        public const string Participant = "4";
        public const string AdminOrOwner = Admin + "," + Owner;
        public const string AdminOrInstructor = Admin + "," + Instructor;
        public const string AdminOrOwnerOrInstructor = Admin + "," + Owner + "," + Instructor;
        public const string AdminOrParticipant = Admin + "," + Participant;
        public const string AdminOrOwnerOrParticipant = Admin + "," + Owner + "," + Participant;
        public const string AllRoles = Admin + "," + Owner + "," + Instructor + "," + Participant;
    }
}
