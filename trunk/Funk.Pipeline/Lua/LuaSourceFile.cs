using System;
using System.Collections.Generic;
using System.Text;

namespace Funk.Engine.Script
{
    public class LuaSourceFile
    {
        String m_source;
        public String Source
        {
            get { return m_source; }
            set { m_source = value; }
        }

        public LuaSourceFile(String source)
        {
            m_source = source;
        }
    }
}
