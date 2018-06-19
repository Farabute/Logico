/*             primer punto           */


mira(himym,juan).
mira(futurama,juan).
mira(got,juan).
mira(got,nico).
mira(got,maiu).
mira(starWars,nico).
mira(starWars,maiu).
mira(onePiece,maiu).
mira(hoc,gaston).

/*
Como nadie mira Mad Men no lo modelaremos por principio de universo cerrado.
Como Alf no mira ninguna serie no tiene sentido modelarlo por principio de universo cerrado.
*/

seriePopular(got).
seriePopular(hoc).
seriePopular(starWars).

quiereVer(hoc, juan).
quiereVer(got, aye).
quiereVer(himym, gaston).



serie(got,[temporada(3,12),temporada(2,10)]).
serie(himym,[temporada(1,23)]).
serie(drHouse,[temporada(8,16)]).

/*No definimos madMen ya que no conocemos sus temporadas, principio de universo cerrado(solo es verdadero lo que conocemos)*/

/* segundo punto */

paso(futurama, 2, 3, muerte(seymourDiera)).
paso(starWars, 10, 9, muerte(emperor)).
paso(starWars, 1, 2, relacion(parentesco, anakin, rey)).
paso(starWars, 3, 2, relacion(parentesco, vader, luke)).
paso(himym, 1, 1, relacion(amorosa, ted, robin)).
paso(himym, 4, 3, relacion(amorosa, swarley, robin)).
paso(got, 4, 5, relacion(amistad, tyrion, dragon)).


leDijo(gaston, maiu, got, relacion(amistad, tyrion, dragon)).
leDijo(nico, maiu, starWars, relacion(parentesco, vader, luke)).
leDijo(nico, juan, got, muerte(tyrion)).
leDijo(aye, juan, got, relacion(amistad, tyrion, john)).
leDijo(aye, maiu, got, relacion(amistad, tyrion, john)).
leDijo(aye, gaston, got, relacion(amistad, tyrion, dragon)).


/* tercer punto */

esSpoiler(Serie,LoQuePaso):-
    paso(Serie,_,_,LoQuePaso).

/* Permite consultas individuales y existenciales en ambos parámetros. */

/* cuarto punto */

miraOPlaneaVer (Serie, Persona):- mira(Serie, Persona).
miraOPlaneaVer (Serie, Persona):- quiereVer(Serie, Persona).

leSpoileo(UnaPersona,OtraPersona,Serie):-
    miraOPlaneaVer(Serie, OtraPersona),
    leDijo(UnaPersona,OtraPersona,Serie,Suceso),
    esSpoiler(Serie,Suceso).

/* quinto punto*/

televidenteResponsable(Persona):-
	leDijo(Persona,_,_,_),
	forall(leDijo(Persona,OtraPersona,Serie,_),not(leSpoileo(Persona,OtraPersona,Serie))).

televidenteResponsable(Persona):-
	mira(_,Persona),
	forall(leDijo(Persona,OtraPersona,Serie,_),not(leSpoileo(Persona,OtraPersona,Serie))).

/* sexto Punto*/

vieneZafando(Serie,Persona):-
  miraOPlaneaVer(Serie,Persona),
  not(leSpoileo(_,Persona,Serie)),
  esPopularOPasaronCosasFuertes(Serie).

esPopularOPasaronCosasFuertes(Serie):-
  seriePopular(Serie).

esPopularOPasaronCosasFuertes(Serie):-
  serie(Serie,[temporada(Temporada,_)]),
  paso(Serie,Temporada,_,_).

/* septimo Punto*/

:- begin_tests( spoiler_alert).

    % Test tercer punto

    test( esSpoilerMuerteEmperorEnStarWars , nondet ) :-
      esSpoiler( starWars , muerte(emperor)).

    test( esSpoilerMuertePedroEnStarWars , nondet ) :-
      not(esSpoiler( starWars , muerte( pedro ))).

    test( esSpoilerParentescoAnakinReyEnStarWars , nondet ) :-
      esSpoiler( starWars , relacion( parentesco , anakin , rey )).

    test( esSpoilerParentescoAnakinLavezziEnStarWars , nondet ) :-
      not( esSpoiler( starWars , relacion( parentesco , anakin , lavezzi ))).

    % Test cuarto punto

    test( leSpoileoGastonAMaiuGoT , nondet ) :-
      leSpoileo( gaston , maiu , got ).

    test( leSpoileoNicoAMaiuStarWars , nondet ) :-
      leSpoileo( nico , maiu , starWars ).

    % Test quinto Punto

    test( juanEsTelevidenteResponsable , nondet ):-
      televidenteResponsable( juan ).

    test( ayeEsTelevidenteResponsable , nondet ):-
      televidenteResponsable( aye ).

    test( mauiEsTelevidenteResponsable , nondet ):-
      televidenteResponsable( maui ).

    test( nicoNoEsTelevidenteResponsable , nondet ):-
      not( televidenteResponsable( nico )).

    test( gastonNoEsTelevidenteResponsable , nondet ):-
      not( televidenteResponsable( gaston )).

    % Test sexto Punto

    test( maiuNoVieneZafando , nondet ):-
      not( vieneZafando(_,maiu)).

    test( juanVieneZafando , set( Serie == [ himym , got , hoc ])):-
      vieneZafando( Serie , juan ).

    test( soloNicoVieneZafandoConStarWars , nondet):-
      vieneZafando( starWars , nico ).

:-end_tests(spoiler_alert).
