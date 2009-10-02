#include <cstring>
#include "opencxx/parser/Parser.h"
#include "opencxx/parser/Lex.h"
#include "opencxx/parser/Ptree.h"
#include "opencxx/parser/Program.h"
#include "opencxx/parser/CerrErrorLog.h"

using Opencxx::Parser;
using Opencxx::Lex;
using Opencxx::Ptree;
using Opencxx::CerrErrorLog;

class FooProgram : public Opencxx::Program
{
public:
    FooProgram()
        :
        Program("foo")
    {
        index = 0;
        buf = "int foo() { ";
        size = std::strlen(buf) + 1;
    }
};

int main()
{
    FooProgram program;
    Lex lex(&program);
    CerrErrorLog log;
    Parser parser(&lex, log);
    
    Ptree *ptree = 0;
    
    parser.rProgram(ptree);
    
    if (ptree)
    {
        ptree->Display();
    }
}
