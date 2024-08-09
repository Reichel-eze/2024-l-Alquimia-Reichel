% Parcial Alquimia

herramienta(ana, circulo(50,3)).
herramienta(ana, cuchara(40)).
herramienta(beto, circulo(20,1)).
herramienta(beto, libro(inerte)).
herramienta(cata, libro(vida)).
herramienta(cata, circulo(100,5)).

% Los círculos alquímicos tienen diámetro en cms y cantidad de niveles.
% Las cucharas tienen una longitud en cms.
% Hay distintos tipos de libro.

% 1) Modelar los jugadores y elementos y agregarlos a la base de 
% conocimiento, utilizando los ejemplos provistos.

tiene(ana, agua).
tiene(ana, vapor).
tiene(ana, tierra).
tiene(ana, hierro).

tiene(beto, Elemento) :- tiene(ana, Elemento).

tiene(cata, fuego).
tiene(cata, tierra).
tiene(cata, agua).
tiene(cata, aire).

paraConstruir(pasto, agua).
paraConstruir(pasto, tierra).

paraConstruir(hierro, fuego).
paraConstruir(hierro, agua).
paraConstruir(hierro, tierra).

paraConstruir(huesos, pasto).
paraConstruir(huesos, agua).

paraConstruir(presion, hierro).
paraConstruir(presion, vapor).

paraConstruir(vapor, agua).
paraConstruir(vapor, fuego).

paraConstruir(playstation, silicio).
paraConstruir(playstation, hierro).
paraConstruir(playstation, plastico).

paraConstruir(silicio, tierra).

paraConstruir(plastico, huesos).
paraConstruir(plastico, presion).

% Otra forma con el uso de lista
compuesto(pasto, [agua, tierra]).
compuesto(hierro, [fuego, agua, tierra]).
compuesto(huesos, [pasto, agua]).
compuesto(presion, [hierro, vapor]).
compuesto(vapor, [agua, fuego]).
compuesto(playstation, [silicio, hierro, plastico]).
compuesto(silicio, [tierra]).
compuesto(plastico, [huesos, presion]).

elemento(Elemento) :- tiene(_, Elemento).
elemento(Elemento) :- paraConstruir(Elemento, _).

jugador(Jugador) :- tiene(Jugador, _).

% 2) Saber si un jugador tieneIngredientesPara construir un elemento, 
% que es cuando tiene ahora en su inventario todo lo que hace falta.
% Por ejemplo, ana tiene los ingredientes para el pasto, pero no 
% para el vapor. 

tieneIngredientesPara(Jugador, ElementoAConstruir) :-
    jugador(Jugador),
    paraConstruir(ElementoAConstruir, _),
    forall(paraConstruir(ElementoAConstruir, Elemento), tiene(Jugador, Elemento)).
    % para todo elemento necesario para contruir el elementoAConstruir, este elemento necesario lo tiene el jugador

tieneIngredientesParaLISTAS(Jugador, ElementoAConstruir) :-
    jugador(Jugador),
    compuesto(ElementoAConstruir, _),
    forall((compuesto(ElementoAConstruir, Elementos), member(Elemento, Elementos)), tiene(Jugador, Elemento)).  
    % para cada uno de los elementos que necesita el elementoAConstruir, estos elementos los tiene el jugador

tieneIngredientesParaLISTASV2(Jugador, ElementoAConstruir) :-
    jugador(Jugador),
    compuesto(ElementoAConstruir, Elementos),
    forall(member(Elemento, Elementos), tiene(Jugador, Elemento)).

necesita(Elemento, Ingrediente) :-
    compuesto(Elemento, Ingredientes),
    member(Ingrediente, Ingredientes).