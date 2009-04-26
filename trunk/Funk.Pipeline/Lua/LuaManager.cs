using System;
using System.Collections.Generic;
using System.Text;
using LuaInterface;

namespace Ika.Script
{
    public class LuaManager
    {
        protected Lua m_luaState;
        public Lua LuaState
        {
            get { return m_luaState; } 
        }

        public Object this[String s]
        {
            get { return m_luaState[s]; }
            set { m_luaState[s] = value; }
        }
        
        public LuaManager()
        {
            m_luaState = new Lua();
        }

        public LuaManager(Lua luaState)
        {
            m_luaState = luaState;
        }

        public void FlushIO()
        {
            m_luaState.DoString("io.flush()");
        }

        public void CallLuaFunction(LuaFunction func, Object[] args)
        {
            try
            {
                if (args != null)
                {
                    func.Call(args);
                }
                else
                {
                    func.Call();
                }
                m_luaState.DoString("io.flush()");
            }
            catch (LuaException e)
            {
                PrintError(e);
            }
            catch (Exception e)
            {
                PrintError(e);
            }
        }

        public void Print(String s)
        {
            try
            {
                String luaCode = "print(\"" + s + "\")";
                DoString(luaCode);
            }
            catch (LuaException e)
            {
                PrintError(e);
            }
        }

        public void DoFile(String s)
        {
            try
            {
                Console.WriteLine("Lua: Loading file: " + s);
                m_luaState.DoFile(s);
                FlushIO();
            }
            catch (Exception e)
            {
                PrintError(e);
            }
        }

        public void DoString(String s)
        {
            try
            {
                m_luaState.DoString(s);
                FlushIO();
            }
            catch (LuaException e)
            {
                PrintError(e);
            }
        }

        public void PrintError(Exception e)
        {
            System.Console.Error.WriteLine(">>A .Net Exception occured:");
            System.Console.Error.WriteLine(">>" + e.Message);
        }

        public void PrintError(LuaException e)
        {
            System.Console.Error.WriteLine(">>A Lua Exception occured:");
            System.Console.Error.WriteLine(">>" + e.Message);
        }
    }
}
