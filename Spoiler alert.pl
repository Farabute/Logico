/*             primer punto           */


mira(juan, himym).
mira(juan, futurama).
mira(juan, got).
mira(nico, got).
mira(maiu, got).
mira(nico, starWars).
mira(maiu, starWars).
mira(maiu, onePiece).
mira(gaston, hoc).

mira(pedro,got).


/*        Justificación

Como nadie mira Mad Men no lo modelaremos por Principio de Universo Cerrado, según el cual toda información que no se agregue
a la base de conocimientos se asume falsa. Esto funciona ya que consultar "mira(alguien, madMen)." debería dar falso,
sea quien sea ese alguien.
Análogamente no tiene sentido modelar el hecho de que Alf no mira ninguna serie por el mismo principio, puesto que Alf no se
relaciona con ninguna serie. De modo que consultar "mira(alf, serie)." resultaría correctamente falso para cualquier serie.
*/

seriePopular(got).
seriePopular(hoc).
seriePopular(starWars).

quiereVer(juan, hoc).
quiereVer(aye, got).
quiereVer(gaston, himym).

temporardaYSusEpisodios(got, 3, 12).
temporardaYSusEpisodios(got, 2, 10).
temporardaYSusEpisodios(himym, 1, 23).
temporardaYSusEpisodios(drHouse, 8, 16).

/*        Justificación

No definimos la 2° temporada de madMen por Principio de Universo Cerrado. No saber cuántos episodios tiene no aporta nada
relevante a nuestra base de conocimientos (de hecho nos pone en la misma situación que cualquier otra temporada cuya cantidad
de episodios desconocemos, y al igual que con esos casos, optamos por no definirla).
*/


/* segundo punto */

paso(futurama, 2, 3, muerte(seymourDiera)).
paso(starWars, 10, 9, muerte(emperor)).
paso(starWars, 1, 2, relacion(parentesco, anakin, rey)).
paso(starWars, 3, 2, relacion(parentesco, vader, luke)).
paso(himym, 1, 1, relacion(amorosa, ted, robin)).
paso(himym, 4, 3, relacion(amorosa, swarley, robin)).
paso(got, 4, 5, relacion(amistad, tyrion, dragon)).

paso(got, 3 , 2 , plotTwist([ suenio , sinPiernas ])).
paso(got , 3 , 12 , plotTwist([ fuego , boda ])).
paso(superCampeones , 9 , 9 , plotTwist([ suenio , coma , sinPiernas])).
paso(drHouse , 8 , 7 , plotTwist([ coma , pastillas])).


leDijo(gaston, maiu, got, relacion(amistad, tyrion, dragon)).
leDijo(nico, maiu, starWars, relacion(parentesco, vader, luke)).
leDijo(nico, juan, got, muerte(tyrion)).
leDijo(aye, juan, got, relacion(amistad, tyrion, john)).
leDijo(aye, maiu, got, relacion(amistad, tyrion, john)).
leDijo(aye, gaston, got, relacion(amistad, tyrion, dragon)).

leDijo(nico,juan,futurama,muerte(seymourDiera)).
leDijo(pedro,aye,got,relacion(amistad,tyrion,dragon)).
leDijo(pedro,nico,got,relacion(parentesco,tyrion,dragon)).

/* tercer punto */

esSpoiler(Serie,LoQuePaso):-
    paso(Serie,_,_,LoQuePaso).

:- begin_tests( es_spoiler).

    test( esSpoilerMuerteEmperorEnStarWars , nondet ) :-
      esSpoiler( starWars , muerte(emperor)).

    test( esSpoilerMuertePedroEnStarWars , nondet ) :-
      not(esSpoiler( starWars , muerte( pedro ))).

    test( esSpoilerParentescoAnakinReyEnStarWars , nondet ) :-
      esSpoiler( starWars , relacion( parentesco , anakin , rey )).

    test( esSpoilerParentescoAnakinLavezziEnStarWars , nondet ) :-
      not( esSpoiler( starWars , relacion( parentesco , anakin , lavezzi ))).

:-end_tests(es_spoiler).

/*        Justificación

Permite consultas individuales y existenciales en ambos parámetros, de modo que se trata de un predicado inversible.

Se denomina consulta individual a aquella en la que los individuos vienen definidos en la consulta, y para la cual se busca
una solución en la base de conocimientos que la verifique.
Asimismo, se entiende por consulta existencial a aquella en la que intervienen variables (anónimas o no) para consultar si
existe una solución individual que, al reemplazarla por la variable, coincida con algo definido en la base de conocimientos.
Si es así, se unificará el valor hallado a la variable y se informará por consola. Opcionalmente puede preguntarse por otra
solución que haga verdadera la consulta (con ";"), y la consola las irá informando de a una por vez.

INDIVIDUALES:
1. Puede consultarse si una serie particular se corresponde con un spoiler particular.
	Ej. 1: "esSpoiler(starWars, muerte(emperor)).", para ver si la muerte de emperor ocurrió en Star Wars y es un spoiler.
EXISTENCIALES:
2. Si hay algún spoiler para alguna serie en particular, mediante el uso de variable anónima en el segundo parámetro
  (recordando que la misma muestra True si encuentra algo en ese lugar que verifique el predicado, y False en caso contrario).
	Ej. 2: "esSpoiler(futurama,_).", para consultar si existe algún spoiler de Futurama en la base de conocimientos.
3. Algún spoiler (si hay) para una serie en particular, utilizando una variable normal en el segundo parámetro.
   Esto muestra el argumento que hace verdadera esa consulta (si es que hay alguno), y mediante ";" se puede buscar otro, hasta
   que no se hallen más (en cuyo caso se muestra False).
	Ej. 3: "esSpoiler(himym, Spoiler)." sirve para consultar por algún spoiler para himym; luego de encontrarlo se puede
            	presionar ";" para buscar otro, y así pasando por todos hasta llegar a que no haya más (False).
4. Alguna serie (si hay) con un tipo determinado de spoiler (muerte/relacion). Acá se combinan variable normal en el
   primer parámetro (por querer saber específicamente qué series cumplen el requisito), con variable anónima en el/los "argumentos"
   del functor (siendo que no nos interesa quién murió, o entre quiénes es la relación).
	Ej. 4: "esSpoiler(Serie, relacion(parentesco,_,_))." se ocupa de mostrar alguna serie en la que haya una relación de
           	parentesco, no importa entre quiénes.
5. Un par posible de una serie con su respectivo spoiler (si hay). Para esto se usan dos variables normales, ya que queremos que
   nos muestre un par de elementos que verifique el predicado. Esto podría servir si se quiere ver todos los spoilers que existen
   en la base de conocimientos, de a uno por vez.
	Ej. 5: "esSpoiler(Serie, Spoiler)." muestra Serie y Spoiler igualados a un caso existente en la base de conocimientos.
*/


/* cuarto punto */

miraOPlaneaVer(Persona, Serie):- mira(Persona, Serie).
miraOPlaneaVer(Persona, Serie):- quiereVer(Persona ,Serie).

leSpoileo(PersonaSpoiler, PersonaQueQuiereVer, Serie):-
    miraOPlaneaVer(PersonaQueQuiereVer, Serie),
    leDijo(PersonaSpoiler, PersonaQueQuiereVer, Serie, Suceso),
    esSpoiler(Serie, Suceso).

:- begin_tests( le_spoileo).

    test( leSpoileoGastonAMaiuGoT , nondet ) :-
      leSpoileo( gaston , maiu , got ).

    test( leSpoileoNicoAMaiuStarWars , nondet ) :-
      leSpoileo( nico , maiu , starWars ).

:-end_tests(le_spoileo).

/*        Justificación

Permite consultas individuales y existenciales en los tres parámetros, de modo que se trata de un predicado inversible.

Un predicado se llama inversible para un parámetro cuando es posible poner en ese lugar una variable sin unificar, y que
el motor la unifique a información útil en términos de lo que se está consultando (léase definición de consulta individual,
existencial y variable anónima en la justificación del punto 3).

INDIVIDUALES:
6. Puede consultarse si dos personas se relacionan con un spoiler particular.
	Ej. 6A: "leSpoileo(gaston, maiu, got).", si queremos saber si Gastón le spoileó GoT a Maiu.
EXISTENCIALES:
7. Si hay alguien que haya/fue spoileado; o bien si hubo una serie spoileada. Esto se consulta poniendo ese parámetro y
   llenando con variable anónima los otros dos (dado que nos interesa si existió algún caso o no, sin más detalle).
	Ej. 7: "leSpoileo(_,_, drHouse).", para saber si alguien spoileó algo de Dr. House.
8. Alguna instancia (si hay) en la que alguien haya/haya sido spoileado, o bien en la que una serie haya sido spoileada.
   Se consulta poniendo ese parámetro y llenando con variable normal los otros dos (puesto que queremos saber qué valores de
   éstos últimos satisfacen el predicado).
	Ej. 8: "leSpoileo(UnaPersona, maiu, Serie)." para consultar un caso en el que spoilearon a Maiu, y qué serie.
9. Una terna posible de dos personas y un spoiler (si hay). Acá se consulta usando tres variables normales, pues queremos
   conocer tres valores que hagan verdadero al predicado. Esto podría servir para ver, una por una, todas las combinaciones
   que hayan.
	Ej. 9: "leSpoileo(UnaPersona, OtraPersona, Serie)." muestra alguna terna de dos personas y una serie existente en la
		base de conocimientos.
*/


/* quinto punto */

persona(Persona) :- miraOPlaneaVer(Persona, _).

televidenteResponsable(Persona):-
  persona(Persona),
	not(leSpoileo(Persona, _, _)).

:- begin_tests( televidente_responsable).

    test( televidentesresponsables, set( Persona == [ juan, aye, maiu ]), nondet):-
      televidenteResponsable(Persona).

    test( televidentesnoresponsables, set( Persona == [ nico, gaston ]), fail):-
        not(televidenteResponsable(Persona)).

:-end_tests(televidente_responsable).

/* sexto Punto */

pasaronCosasFuertes(Serie):-
    temporardaYSusEpisodios(Serie,_,_),
    forall(temporardaYSusEpisodios(Serie,Temporada,_), pasoAlgoFuerteEnTemporada(Serie, Temporada)).
    
pasoAlgoFuerteEnTemporada(Serie, Temporada):-
  paso(Serie, Temporada, _, Suceso),
  cosaFuerte(Serie, Suceso).

vieneZafando(Persona, Serie):-
  miraOPlaneaVer(Persona, Serie),
  not(leSpoileo(_,Persona,Serie)),
  esPopularOPasaronCosasFuertes(Serie).

esPopularOPasaronCosasFuertes(Serie):- seriePopular(Serie).

esPopularOPasaronCosasFuertes(Serie):-
  pasaronCosasFuertes(Serie).

:- begin_tests( viene_zafando).

    test( maiuNoVieneZafando , fail ):-
      vieneZafando(maiu, _).

    test( juanVieneZafando , set( Serie == [ himym , got , hoc ]), nondet):-
      vieneZafando(juan, Serie).

    test( soloNicoVieneZafandoConStarWars , nondet):-
      vieneZafando( nico, starWars).

:-end_tests(viene_zafando).



/* Entrega 2 */

/*             primer punto           */

malaGente(Persona):-
  spoileoATodos(Persona).
malaGente(Persona):-
  spoileoYNoMira(Persona,_,_).

spoileoATodos(Spoilero):-
  persona(Spoilero),
  forall(leDijo(Spoilero, Persona,Serie,_),
  leSpoileo(Spoilero, Persona, Serie)).

spoileoYNoMira(Spoilero,Persona,Serie):-
  leSpoileo(Spoilero,Persona,Serie),
  not(mira(Spoilero,Serie)).

:- begin_tests( malaGente ).

  test( gastonEsMalaGente, nondet) :-
    malaGente(gaston).

  test( nicoEsMalaGente, nondet):-
    malaGente(nico).

  test( pedroEsMalaGente, fail):-
  	malaGente(pedro).

:- end_tests( malaGente ).

/*             segundo punto           */

pasoAlFinalDeTemporada(Serie, Suceso):-
  paso(Serie, Temporada, Episodio, Suceso),
  temporardaYSusEpisodios(Serie, Temporada, Episodio).

esCliche(plotTwist([PalabrasClave])):-
    paso(Serie,_,_, plotTwist([PalabrasClave])),
    forall(member(Palabra, PalabrasClave), (paso(Serie2,_,_,plotTwist([PalabrasClave2])), member(Palabra, PalabrasClave2), Serie \= Serie2)).


cosaFuerte(Serie, muerte(Personaje)) :- paso(Serie,_,_, muerte(Personaje)).
cosaFuerte(Serie, relacion(amorosa, Personaje1, Personaje2)) :- paso(Serie,_,_, relacion(amorosa, Personaje1, Personaje2)).
cosaFuerte(Serie, relacion(parentesco, Personaje1, Personaje2)) :- paso(Serie,_,_,relacion(parentesco, Personaje1, Personaje2)).
cosaFuerte(Serie, plotTwist([PalabrasClave])) :-
    pasoAlFinalDeTemporada(Serie, plotTwist([PalabrasClave])),
    not(esCliche(plotTwist([PalabrasClave]))).


:- begin_tests( cosasFuertes).

    test(muerteSeymourDieraEnFuturamaEsFuerte, nondet):-
      cosaFuerte(futurama,muerte(seymourDiera)).

    test( muerteEmperorEnStarWarsEsFuerte, nondet):-
      cosaFuerte(starWars, muerte(emperor)).

    test( parentescoAnakinYReyEnStarWarsEsFuerte, nondet):-
      cosaFuerte(starWars, relacion(parentesco, anakin, rey)).

    test(parentescoDarthVaderYLukeEnStarWarsEsFuerte, nondet):-
      cosaFuerte(starWars,relacion(parentesco, vader, luke)).

    test(amorEntreTedYRobinEnHowIMetYourMotherEsFuerte, nondet):-
      cosaFuerte(himym,relacion(amorosa, ted, robin)).

    test(amorEntreSwarleyYRobinEnHowIMetYourMotherEsFuerte, nondet):-
      cosaFuerte(himym,relacion(amorosa, swarley, robin)).

    test(plotTwistQueContieneFuegoYBodaEnGotEsFuerte, nondet):-
      cosaFuerte(got, plotTwist([ fuego , boda ])).

    test(plotTwistQueContieneSuenioEnGotNoEsFuerte, fail):-
      cosaFuerte(got, plotTwist([ suenio ])).

    test(plotTwistQueContieneComaYPastillasEnDoctorHouseNoEsFuerte, fail):-
      cosaFuerte(drHouse, plotTwist([coma,pastillas])).

:- end_tests(cosasFuertes).

/*             tercer punto           */

miranOConversan(Serie,Personas,Cantidad):-
    findall(Serie,Personas,Series),
    length(Series,Cantidad).

popularidad(Serie,Popularidad):-
    miranOConversan(Serie,mira(_,Serie),Cantidad1),
    miranOConversan(Serie,leDijo(_,_,Serie,_),Cantidad2),
    Popularidad is Cantidad1 * Cantidad2.

popular(Serie):-
    miraOPlaneaVer(_,Serie),
    popularidad(Serie, PopularidadSerie),
    popularidad(starWars,PopularidadStarWars),
    PopularidadSerie >= PopularidadStarWars.

popular(hoc).

:- begin_tests( popularidad).

    test( sonPopularesEstasSeries, set( Serie == [ got , starWars , hoc ]), nondet):-
      popular(Serie).

:- end_tests( popularidad).


/*             Cuarto punto           */

amigo(nico, maiu).
amigo(maiu, gaston).
amigo(maiu, juan).
amigo(juan, aye).

fullSpoil(Persona1, Persona2):-
    amigo(Persona1, Persona2),
    leSpoileo(Persona1, Persona2, _),
    Persona1 \= Persona2.

fullSpoil(Persona1, Persona2):-
    amigo(Persona3, Persona2),
    fullSpoil(Persona1, Persona3),
    Persona1 \= Persona2.

:- begin_tests(fullSpoil).

    test( nicoFullSpoileoAAyeJuanMaiuGaston , set(Personas == [aye, juan, maiu, gaston]), nondet):-
        fullSpoil(nico, Personas).

    test( gastonFullSpoileoAMaiuJuanAye , set(Personas == [maiu, juan, aye]), nondet):-
        fullSpoil(gaston, Personas).

    test( maiuNoHizoFullSpoil, fail) :-
        fullSpoil(maiu, _).

:- end_tests(fullSpoil).
