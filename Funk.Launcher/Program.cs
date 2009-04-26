using System;
using Microsoft.Xna.Framework;
using DeferredShading.ProtoFalls;

namespace Launcher
{
    static class Program
    {
        /// <summary>
        /// The main entry point for the application.
        /// </summary>
        static void Main(string[] args)
        {
            using (Game game = new GameTemplate())
            {
                game.Run();
            }
        }
    }
}

