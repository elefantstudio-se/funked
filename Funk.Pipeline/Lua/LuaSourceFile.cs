using System;
using System.Collections.Generic;
using System.Text;

namespace Ika.Script
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
