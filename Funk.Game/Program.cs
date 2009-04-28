using System;

namespace Funk.Game
{
    static class Program
    {
        /// <summary>
        /// The main entry point for the application.
        /// </summary>
        static void Main(string[] args)
        {
            using (GameTemplate game = new GameTemplate())
            {
                game.Run();
            }
        }
    }
}

