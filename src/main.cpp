#include <cstring>
#include "opencxx/parser/Parser.h"
#include "opencxx/parser/Lex.h"
#include "opencxx/parser/Ptree.h"
#include "opencxx/parser/Program.h"
#include "opencxx/parser/CerrErrorLog.h"
#include "opencxx/parser/Token.h"

using Opencxx::Parser;
using Opencxx::ILex;
using Opencxx::Ptree;
using Opencxx::CerrErrorLog;
using Opencxx::Token;

class FooProgram : public Opencxx::Program
{
public:
    FooProgram()
        :
        Program("foo")
    {
        index = 0;
        buf = "int foo() /* hoge */ { ";
        size = std::strlen(buf) + 1;
    }
};

class HogeLex : public Opencxx::ILex
{
    Ptree *comments;
    
public:
    virtual int GetToken(Token &token_out)
    {
    }

    virtual int LookAhead(int offset)
    {
    }

    virtual int LookAhead(int offset, Token &token_out)
    {
    }

    virtual char* Save()
    {
    }

    virtual void Restore(char *pos)
    {
    }

    virtual void GetOnlyClosingBracket(Token &token_out)
    {
    }

    virtual Ptree* GetComments()
    {
        Ptree *c = comments;
        comments = 0;
        return c;
    }

    virtual Ptree* GetComments2()
    {
        return comments;
    }

    virtual unsigned LineNumber(char*, char*&, int&)
    {
    }
};

int main()
{
    FooProgram program;
    HogeLex lex(&program);
    CerrErrorLog log;
    Parser parser(&lex, log);
    
    Ptree *ptree = 0;
    
    parser.rProgram(ptree);
    
    if (ptree)
    {
        ptree->Display();
    }
}
