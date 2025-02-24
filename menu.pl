% -*- mode: Prolog -*-
% Sistema di selezione dei pasti per un ristorante italiano

% Avvio del sistema
go :- hypothesize(Pasto), 
      write('Il pasto suggerito è: '), 
      write(Pasto), nl, undo.

% Ipotesi di pasti
hypothesize(pizza_margherita) :- pizza_margherita, !.
hypothesize(carbonara) :- carbonara, !.
hypothesize(risotto_ai_funghi) :- risotto_ai_funghi, !.
hypothesize(bistecca_alla_fiorentina) :- bistecca_alla_fiorentina, !.
hypothesize(minestrone) :- minestrone, !.
hypothesize(insalata_caprese) :- insalata_caprese, !.
hypothesize(not_in_my_memory). % Nessun pasto corrispondente

% Regole per identificare i pasti
pizza_margherita :- italiano, vegetariano, verify(has_pomodoro), verify(has_mozzarella),not_lactose_intolerant.
carbonara :- italiano, carnivoro, verify(has_uova), verify(has_pancetta), verify(has_pasta).
risotto_ai_funghi :- italiano, vegetariano, verify(has_riso), verify(has_funghi).
bistecca_alla_fiorentina :- italiano, carnivoro, verify(has_manzo), verify(grigliato).
minestrone :- italiano, vegano, verify(has_verdure), verify(has_brodo).
insalata_caprese :- italian, has_dairy, 
                     verify(has_tomato), verify(has_cheese), 
                     not_lactose_intolerant.

% Classificazione dei pasti
italiano :- verify(cucina_italiana).
vegetariano :- \+ verify(has_carne), \+ verify(has_pesce).
vegano :- vegetariano, \+ verify(has_formaggio), \+ verify(has_uova).
carnivoro :- verify(has_carne).
senza_glutine :- \+ verify(has_pasta), \+ verify(has_pane).
ipo_calorico :- verify(calorie_basse).
alta_caloria :- verify(calorie_alte).
not_lactose_intolerant :- (verify(intolleranza_lattosio) -> fail ; true).

% Metodo per fare domande
ask(Question) :- 
        write('Il pasto ha il seguente attributo: '), 
        write(Question), write('? '), 
        read(Response), nl, 
        ( (Response == yes ; Response == y) 
        -> assert(yes(Question)) ; 
        assert(no(Question)), fail). 

% Verifica delle risposte
:- dynamic yes/1,no/1.
verify(S) :- (yes(S) -> true ; (no(S) -> fail ; ask(S))). 

% Resetta le risposte
undo :- retract(yes(_)),fail. 
undo :- retract(no(_)),fail. 
undo.  

