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

% 3) Saber si un elemento estaVivo. Se sabe que el agua, el fuego y todo lo que fue construido a partir de alguno de ellos, 
% están vivos. Debe funcionar para cualquier nivel.
% Por ejemplo, la play station y los huesos están vivos, pero el silicio no.

estaVivo(agua).
estaVivo(fuego).
%estaVivo(Elemento) :- paraConstruir(Elemento, agua).
%estaVivo(Elemento) :- paraConstruir(Elemento, fuego).

estaVivo(Elemento) :-                   % Recursividad
    necesita(Elemento, Ingrediente),
    estaVivo(Ingrediente).

estaVivoSinListas(agua).
estaVivoSinListas(fuego).

estaVivoSinListas(Elemento) :-
    paraConstruir(Elemento, Ingrediente),
    estaVivoSinListas(Ingrediente).

% 4) Conocer las personas que puedeConstruir un elemento, para lo que se necesita tener los ingredientes ahora en el inventario y 
% además contar con una o más herramientas que sirvan para construirlo. Para los elementos vivos sirve el libro de la vida 
% (y para los elementos no vivos el libro inerte). Además, las cucharas y círculos sirven cuando soportan la cantidad de 
% ingredientes del elemento (las cucharas soportan tantos ingredientes como centímetros de longitud/10, y los círculos 
% alquímicos soportan tantos ingredientes como metros de diámetro * cantidad de niveles).
% Por ejemplo, beto puede construir el silicio (porque tiene tierra y tiene el libro inerte, que le sirve para el silicio), 
% pero no puede construir la presión (porque a pesar de tener hierro y vapor, no cuenta con herramientas que le sirvan para la 
% presión). Ana, por otro lado, sí puede construir silicio y presión.

puedeConstruir(Jugador, Elemento) :-
    tieneIngredientesPara(Jugador, Elemento),
    tieneHerramientaPara(Jugador, Elemento).

tieneHerramientaPara(Jugador, Elemento) :-
    herramienta(Jugador, Herramienta),
    sirveHerramientaPara(Herramienta, Elemento).

sirveHerramientaPara(libro(vida), Elemento) :- estaVivoSinListas(Elemento).
sirveHerramientaPara(libro(inerte), Elemento) :- not(estaVivoSinListas(Elemento)).

sirveHerramientaPara(cuchara(Longitud), Elemento) :-
    cantidadDeIngredientes(Elemento, Cantidad),
    Centimetros is Longitud / 10,
    Centimetros >= Cantidad.

sirveHerramientaPara(circulo(DiametroCms, Nivel), Elemento) :-
    cantidadDeIngredientes(Elemento, Cantidad),
    Soporte is DiametroCms/100 * Nivel,
    Soporte >= Cantidad.

% --- Con esta forma separo ambos casos por separado (cuchara y circulo) ---

sirveHerramientaParaV2(Herramienta, Elemento) :-
    cantidadDeIngredientes(Elemento, CantidadNecesaria),
    cantidadQueSoporta(Herramienta, CantidadSoportada),
    CantidadSoportada >= CantidadNecesaria.

%cantidadQueSoporta(Herramienta, Cantidad)
cantidadQueSoporta(cuchara(LongitudCms), Cantidad) :-
    Cantidad is LongitudCms / 10.

cantidadQueSoporta(circulo(DiametroCms, Nivel), Cantidad) :-
    Cantidad is DiametroCms/100 * Nivel.

cantidadDeIngredientes(Elemento, Cantidad) :-
    paraConstruir(Elemento, _),
    findall(Ingrediente, paraConstruir(Elemento, Ingrediente), Ingredientes),
    length(Ingredientes, Cantidad).

% 5) Saber si alguien es todopoderoso, que es cuando tiene todos los elementos primitivos (los que no pueden construirse
% a partir de nada) y además cuenta con herramientas que sirven para construir cada elemento que no tenga.
% Por ejemplo, cata es todopoderosa, pero beto no.

todoPoderosa(Jugador) :-
    jugador(Jugador),       % para que sea inversible
    tieneTodosLosPrimitivos(Jugador),
    estaArmadoHastaLosDientes(Jugador).

tieneTodosLosPrimitivos(Jugador) :-
    forall(tiene(Jugador, Elemento), esPrimitivo(Elemento)).

esPrimitivo(Elemento) :-
    tiene(_, Elemento),
    not(paraConstruir(Elemento, _)).

estaArmadoHastaLosDientes(Jugador) :-
    forall(elementoFaltante(Jugador, Elemento), tieneHerramientaPara(Jugador, Elemento)).
    % para todo Elemento Faltante que no tenga el Jugador, tiene las herramientas para contruir ese elemento

elementoFaltante(Jugador, Elemento) :-
    elemento(Elemento),                 % es un elemento que se puede Construir
    not(tiene(Jugador, Elemento)).      % pero NO lo tiene el jugador!!
    

% 6) Conocer quienGana, que es quien puede construir más cosas.
% Por ejemplo, cata gana, pero beto no.

quienGana(Jugador) :-
    jugador(Jugador),
    cantidadQuePuedeConstruir(Jugador, CantidadMayor),
    forall(cantidadQuePuedeConstruir(_, CantidadMenor), CantidadMayor >= CantidadMenor).

cantidadQuePuedeConstruir(Jugador, Cantidad) :-
    jugador(Jugador),
    findall(Construccion, distinct(Construccion, puedeConstruir(Jugador, Construccion)), Construcciones),
    length(Construcciones, Cantidad).

% distinct: El predicado DISTINCT compara dos expresiones y la evaluación da un resultado verdadero (TRUE) si los valores no son idénticos.

% 7) Mencionar un lugar de la solución donde se haya hecho uso del concepto de universo cerrado.

% Ana tiene agua, vapor, tierra y hierro. Beto tiene lo mismo que Ana. 
% Cata tiene fuego, tierra, agua y aire, pero no tiene vapor. 

% Por ejemplo, en esta parte del texto del parcial se nombraba que cata NO tenia el elemento vapor, por lo tanto, haciendo
% uso del concepto de universo cerrado, NO es necesario declarar que NO Tiene el elemento en la base de conocimientos, ya que
% todo lo que se detalle/explcite en el codigo se toma como verderaro mientras lo que no se exprese Prolog lo tomara como
% falso!!