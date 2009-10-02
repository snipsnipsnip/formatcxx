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

class HogeProgram : public Opencxx::Program
{
public:
    HogeProgram()
        :
        Program("hoge")
    {
        index = 0;
        buf = "int hoge() { }";
        size = std::strlen(buf) + 1;
    }
};

int main()
{
    HogeProgram program;
    CerrErrorLog log;
    Lex lex(&program, log);
    Parser parser(lex);
}
