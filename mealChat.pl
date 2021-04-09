:- use_module(library('http/http_client')).
:- use_module(library('http/http_open')).
:- use_module(library('http/http_json')).
:- use_module(library('http/json')).

%-----------API UNDER CONSTRUCTION---------------
apiFunction1(Filter,DishName).





% A noun phrase is a determiner followed by adjectives followed
% by a noun followed by an optional modifying phrase:
noun_phrase(L0,L4,Entity) :-
    det(L0,L1,Entity),
    adjectives(L1,L2,Entity),
    noun(L2,L3,Entity),
    mp(L3,L4,Entity).
noun_phrase(L,L,_).
% noun_phrase(L0,L4,Entity) :-
%     proper_noun(L0,L4,Entity).


verb_phrase(L0,L5,Entity) :-
    adjectives(L0,L2,Entity), 
    verb(L2,L3,Entity),
    noun_phrase(L3,L4,Entity),
    mp(L4,L5,Entity).
verb_phrase(L,L,_).

% Determiners (articles) are ignored in this oversimplified example.
% They do not provide any extra constraints.
det([the | L],L,_).
det([a | L],L,_).
det(L,L,_).


% adjectives(L0,L2,Entity,C0,C2) is true if 
% L0-L2 is a sequence of adjectives imposes constraints C0-C2 on Entity
adjectives(L0,L2,Entity) :-
    adj(L0,L1,Entity),
    adjectives(L1,L2,Entity).
adjectives(L,L,_).

% An optional modifying phrase / relative clause is either
% a relation (verb or preposition) followed by a noun_phrase or
% 'that' followed by a relation then a noun_phrase or
% nothing 
mp(L0,L2,Object) :-
    noun_phrase(L0,L1,Object),
    verb_phrase(L1,L2,Object).
mp([that|L0],L2,Object) :-
    noun_phrase(L0,L1,Object),
    verb_phrase(L1,L2,Object).
mp([for|L0],L1,Object) :-
    noun_phrase(L0,L1,Object).
mp([to|L0],L1,Object) :-
    noun_phrase(L0,L1,Object).
mp([with|L0],L1,Object) :-
    noun_phrase(L0,L1,Object).
mp(L,L,_).

% DICTIONARY
% adj(L0,L1,Entity,C0,C1) is true if L0-L1 
% is an adjective that imposes constraints C0-C1 Entity
adj([X | L],L,X) :- area(X).
% adj([Lang,speaking | L],L,Entity) :- speaks(Entity,Lang).
% adj([Lang,-,speaking | L],L,Entity) :- speaks(Entity,Lang).

noun([X | L],L,X) :- category(X).
noun([people | L],L,_).
noun([food | L],L,_).
noun(["I" | L],L,_).
noun([recipe | L],L,_).
noun([dish | L],L,_).
noun([meal | L],L,_).

%noun([X | L],L,X) :- city(Entity).

verb([eat | L], L,_).
verb([drink | L], L,_).
verb([cook | L], L,_).
verb([make | L], L,_).
verb([do | L], L,_).
verb([can | L], L,_).


% Countries and languages are proper nouns.
% We could either have it check a language dictionary or add the constraints. We chose to check the dictionary.
proper_noun([X | L],L,X) :- country(X).
proper_noun([X | L],L,X) :- language(X).

reln([borders | L],L,O1,O2) :- borders(O1,O2).
reln([the,capital,of | L],L,O1,O2) :- capital(O2,O1).
reln([next,to | L],L,O1,O2) :- borders(O1,O2).

% question(Question,QR,Entity) is true if Query provides an answer about Entity to Question
question(['Is' | L0],L2,Entity) :-
    noun_phrase(L0,L1,Entity),
    mp(L1,L2,Entity).
question(['What',is | L0], L1, Entity) :-
    mp(L0,L1,Entity).
question(['What',is | L0],L1,Entity) :-
    noun_phrase(L0,L1,Entity).
question(['What',can,'I'| L0],L2,Entity) :-
    verb_phrase(L0,L2,Entity).
question(['What',do,'I' | L0],L2,Entity) :-
    verb_phrase(L0,L2,Entity).
question(['What',can | L0],L2,Entity) :-
    noun_phrase(L0,L2,Entity).
question(['What',do | L0],L2,Entity) :-
    noun_phrase(L0,L2,Entity).
question(['What' | L0],L2,Entity) :-
    mp(L0,L2,Entity).
question(['Give',me | L0], L2, Entity) :-
    noun_phrase(L0,L2,Entity). 

%-----------------------------------------------------------------------------------
question(['How',to | L0], L2, Entity) :-
    verb_phrase(L0,L2,Entity). 


% ask(Q,A) gives answer A to question Q
ask(Q,A) :-
    question(Q,End,A),
    member(End,[[],['?'],['.']]).

% get_constraints_from_question(Q,A,C) is true if C is the constraints on A to infer question Q
% get_constraints_from_question(Q,A,) :-
%     question(Q,End,A),
%     member(End,[[],['?'],['.']]).


% prove_all(L) is true if all elements of L can be proved from the knowledge base
prove_all([]).
prove_all([H|T]) :-
    call(H),      % built-in Prolog predicate calls an atom
    prove_all(T).


%  The Database of Facts to be Queried

% country(C) is true if C is a country
country(argentina).
country(brazil).
country(chile).
country(paraguay).
country(peru).

% large(C) is true if the area of C is greater than 2m km^2
large(brazil).
large(argentina).

% language(L) is true if L is a language
language(spanish).
language(portugese).

% speaks(Country,Lang) is true of Lang is an official language of Country
speaks(argentina,spanish).
speaks(brazil,portugese).
speaks(chile,spanish).
speaks(paraguay,spanish).
speaks(peru,spanish).

capital(argentina,'Buenos Aires').
capital(chile,'Santiago').
capital(peru,'Lima').
capital(brazil,'Brasilia').
capital(paraguay,'Asunción').

% borders(C1,C2) is true if country C1 borders country C2
borders(peru,chile).
borders(chile,peru).
borders(argentina,chile).
borders(chile,argentina).
borders(brazil,peru).
borders(peru,brazil).
borders(argentina,brazil).
borders(brazil,argentina).
borders(brazil,paraguay).
borders(paraguay,brazil).
borders(argentina,paraguay).
borders(paraguay,argentina).

/* Try the following queries:
?- ask(['What',is,a,country],A).
?- ask(['What',is,a,spanish,speaking,country],A).
?- ask(['What',is,the,capital,of, chile],A).
?- ask(['What',is,the,capital,of, a, country],A).
?- ask(['What',is, a, country, that, borders,chile],A).
?- ask(['What',is, a, country, that, borders,a, country,that,borders,chile],A).
?- ask(['What',is,the,capital,of, a, country, that, borders,chile],A).
?- ask(['What',country,borders,chile],A).
?- ask(['What',country,that,borders,chile,borders,paraguay],A).
*/


% To get the input from a line:

q(Ans) :-
    write("\n----Welcome to the Meal Planner!----\n"),
     
    write("I can help you with: "),
    write("     Finding the recipe with the main ingredient; (under construction)\n"),
    write("     Suggest a meal with given category; (under construction)\n"),
    write("     Suggest a meal with given area; (under construction)\n"),
    write("     Select a meal for you randomly if you have no idea about what to cook; \n"),
    write("  "),
    write("Ask me: "), flush_output(current_output),
    readln(Ln),
    ask(Ln,Ans).
   

/*
?- q(Ans).
Ask me: What is a country that borders chile?
Ans = argentina ;
Ans = peru ;
false.

?- q(Ans).
Ask me: What is the capital of a spanish speaking country that borders argentina?
Ans = 'Santiago' ;
Ans = 'Asunción' ;
false.

Some more questions:
What can I cook for dessert?
What do chinese people eat?
What do I eat for dinner?
What can I make with lamb?

*/

category(beef).
category(breakfast).
category(chicken).
category(dessert).
category(goat).
category(lamb).
category(miscellaneous).
category(pasta).
category(pork).
category(seafood).
category(sode).
category(starter).
category(vegan).
category(vegetarian).

area(american).
area(british).
area(canadian).
area(chinese).
area(dutch).
area(egyptian).
area(french).
area(greek).
area(indian).
area(irish).
area(italian).
area(jamaican).
area(japanese).
area(kenyan).
area(malaysian).
area(mexican).
area(moroccan).
area(polish).
area(portuguese).
area(russian).
area(spanish).
area(thai).
area(tunisian).
area(turkish).
area(vietnamese).
