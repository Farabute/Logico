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



/*                   segundo punto                      */



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


/*tercer punto*/

esSpoiler(Serie,muerte(Alguien)):-
    paso(Serie,_,_,muerte(Alguien)).

	
	
esSpoiler(Serie,relacion(Vinculo,UnPersonaje,OtroPersonaje)):-
    paso(Serie,_,_,relacion(Vinculo,UnPersonaje,OtroPersonaje)).

/*cuarto punto*/

leSpoileo(UnaPersona,OtraPersona,Serie):-
    mira(Serie,OtraPersona),
    leDijo(UnaPersona,OtraPersona,Serie,Suceso),
	esSpoiler(Serie,Suceso).
	
leSpoileo(UnaPersona,OtraPersona,Serie):-
    quiereVer(Serie,OtraPersona),
    leDijo(UnaPersona,OtraPersona,Serie,Suceso),
	esSpoiler(Serie,Suceso).
	
/*quinto punto*/

televidenteResponsable(Persona):-
	leDijo(Persona,_,_,_),
	forall(leDijo(Persona,OtraPersona,Serie,_),not(leSpoileo(Persona,OtraPersona,Serie))).
	
	televidenteResponsable(Persona):-
	mira(_,Persona),
	forall(leDijo(Persona,OtraPersona,Serie,_),not(leSpoileo(Persona,OtraPersona,Serie))).
	

/* Sexto Punto*/
	
