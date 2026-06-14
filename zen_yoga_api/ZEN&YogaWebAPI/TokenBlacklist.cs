namespace ZEN_YogaWebAPI
{
    public static class TokenBlacklist
    {
        private static readonly HashSet<string> _tokens = new();

        public static void Add(string token)
        {
            _tokens.Add(token);
        }

        public static bool IsBlacklisted(string token)
        {
            return _tokens.Contains(token);
        }
    }
}
