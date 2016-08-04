%{
import java.lang.Math;
import java.io.*;
import java.util.StringTokenizer;
import java.util.HashMap;
%}

/* YACC Declarations */
%token EQ  /* = */
%token NEQ /* <> != */
%token GT  /* >  */ 
%token GE  /* >= */
%token LT  /* <  */
%token LE  /* <= */

%token START_WITH
%token END_WITH
%token INCLUDE
%token IS
%token NOT

%token AND
%token OR

%token NULL
%token BOOLEAN
%token STRING
%token NUMBER
%token IDENTIFIER

%left OR
%left AND
%right NOT

/* Grammar follows */
%%
input: /* empty string */
 | exp { root = $1; }
 ;

exp: IDENTIFIER EQ BOOLEAN      { $$ = new ParserVal(new BooleanOpExp($1, $3, EQ)); }
 | IDENTIFIER NEQ BOOLEAN       { $$ = new ParserVal(new BooleanOpExp($1, $3, NEQ)); }
 | BOOLEAN EQ  IDENTIFIER       { $$ = new ParserVal(new BooleanOpExp($1, $3, EQ)); }
 | BOOLEAN NEQ IDENTIFIER       { $$ = new ParserVal(new BooleanOpExp($1, $3, NEQ)); }
 | IDENTIFIER EQ  NUMBER        { $$ = new ParserVal(new NumberOpExp($1, $3, EQ)); }
 | IDENTIFIER NEQ NUMBER        { $$ = new ParserVal(new NumberOpExp($1, $3, NEQ)); }
 | IDENTIFIER GT  NUMBER        { $$ = new ParserVal(new NumberOpExp($1, $3, GT)); }
 | IDENTIFIER GE  NUMBER        { $$ = new ParserVal(new NumberOpExp($1, $3, GE)); }
 | IDENTIFIER LT  NUMBER        { $$ = new ParserVal(new NumberOpExp($1, $3, LT)); }
 | IDENTIFIER LE  NUMBER        { $$ = new ParserVal(new NumberOpExp($1, $3, LE)); }
 | NUMBER EQ  IDENTIFIER        { $$ = new ParserVal(new NumberOpExp($1, $3, EQ)); }
 | NUMBER NEQ IDENTIFIER        { $$ = new ParserVal(new NumberOpExp($1, $3, NEQ)); }
 | NUMBER GT  IDENTIFIER        { $$ = new ParserVal(new NumberOpExp($1, $3, GT)); }
 | NUMBER GE  IDENTIFIER        { $$ = new ParserVal(new NumberOpExp($1, $3, GE)); }
 | NUMBER LT  IDENTIFIER        { $$ = new ParserVal(new NumberOpExp($1, $3, LT)); }
 | NUMBER LE  IDENTIFIER        { $$ = new ParserVal(new NumberOpExp($1, $3, LE)); }
 | IDENTIFIER EQ         STRING { $$ = new ParserVal(new StringOpExp($1, $3, EQ)); }
 | IDENTIFIER NEQ        STRING { $$ = new ParserVal(new StringOpExp($1, $3, NEQ)); }
 | IDENTIFIER START_WITH STRING { $$ = new ParserVal(new StringOpExp($1, $3, START_WITH)); }
 | IDENTIFIER END_WITH   STRING { $$ = new ParserVal(new StringOpExp($1, $3, END_WITH)); }
 | IDENTIFIER INCLUDE    STRING { $$ = new ParserVal(new StringOpExp($1, $3, INCLUDE)); }
 | STRING EQ         IDENTIFIER { $$ = new ParserVal(new StringOpExp($1, $3, EQ)); }
 | STRING NEQ        IDENTIFIER { $$ = new ParserVal(new StringOpExp($1, $3, NEQ)); }
 | STRING START_WITH IDENTIFIER { $$ = new ParserVal(new StringOpExp($1, $3, START_WITH)); }
 | STRING END_WITH   IDENTIFIER { $$ = new ParserVal(new StringOpExp($1, $3, END_WITH)); }
 | STRING INCLUDE    IDENTIFIER { $$ = new ParserVal(new StringOpExp($1, $3, INCLUDE)); }
 | IDENTIFIER IS NULL           { $$ = new ParserVal(new NullOpExp($1, EQ)); }
 | IDENTIFIER IS NOT NULL       { $$ = new ParserVal(new NullOpExp($1, NEQ)); }
 | exp OR exp                   { $$ = new ParserVal(new LogicalOpExp($1, $3, OR)); }
 | exp AND exp                  { $$ = new ParserVal(new LogicalOpExp($1, $3, AND)); }
 | NOT exp                      { $$ = new ParserVal(new NegateOpExp($2)); }
 | '(' exp ')'                  { $$ = $2; }
 ;
%%

private Yylex lexer;
ParserVal root;

private int yylex () {
    int token = -1;
    try {
        token = lexer.yylex(); // next token
    }
    catch (IOException e) {
        e.printStackTrace(); // should not happen
    }
    return token;
}

void yyerror(String s)
{
    throw new RuntimeException("yyerror: " + s);
}

public ParserExp parse(String str)
{
    lexer = new Yylex(str, this);
    yyparse();
    return ((ParserExp)(root.obj));
}

/*public static void main(String args[])
{
    Parser yyparser = new Parser();
    ParserExp exp = yyparser.parse("boolean = true");
    HashMap<String, Object> variables = new HashMap<>();
    variables.put("boolean", Boolean.TRUE);
    System.out.println("ans: " + exp.eval(variables));
}*/
