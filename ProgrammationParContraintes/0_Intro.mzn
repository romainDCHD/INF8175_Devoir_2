% DUCHADEAU Romain (2311547)
% LOPEZ Ines (2404168)

include "globals.mzn";

%-----------------------------------------------------------------------------%
% Variables de décisions
%-----------------------------------------------------------------------------%

% Nombre devant satisfaire les critères
var 1000..9999: nombre;

% Décomposition du nombre en un ensemble de chiffres
array[1..4] of var 1..9: chiffres;

%-----------------------------------------------------------------------------%
% Objectif
%-----------------------------------------------------------------------------%

% Variable à minimiser
var int: p;

%-----------------------------------------------------------------------------%
% Partie étudiant
%-----------------------------------------------------------------------------%
% Il faut d'abord relier les chiffres au nombre %
constraint nombre = 1000 * chiffres[1] + 100 * chiffres[2] + 10 * chiffres[3] + chiffres[4];

% Critère 1 : est paire %
constraint nombre mod 2 = 0 ;

% Critère 2 : 0 n’est pas présent dans le nombre %
constraint chiffres[1] != 0;
constraint chiffres[2] != 0;
constraint chiffres[3] != 0;
constraint chiffres[4] != 0;

% Critère 3 : Les 4 chiffres sont différents %
constraint chiffres[1] != chiffres[2];
constraint chiffres[1] != chiffres[3];
constraint chiffres[1] != chiffres[4];
constraint chiffres[2] != chiffres[3];
constraint chiffres[2] != chiffres[4];
constraint chiffres[3] != chiffres[4];

% Critère 4 : Le chiffre à la position des milliers est supérieur à celui à la position des centaines %
constraint chiffres[1] > chiffres[2];

% Critère 5 : Le chiffre à la position des dizaines est inférieur à celui à la position des unités %
constraint chiffres[3] < chiffres[4];

% Critère 6 : Le chiffre à la position des centaines est supérieur à celui à la position des unités %
constraint chiffres[2] > chiffres[4];

% Critère 7 : La somme des 4 chiffres est supérieure à 15 %
constraint chiffres[1] + chiffres[2] + chiffres[3] + chiffres[4] > 15;

% Critère 8 : Le produit des 3 derniers chiffres doit être minimisé %
p = chiffres[4]*chiffres[3]*chiffres[2];
solve minimize p;

%-----------------------------------------------------------------------------%

output [
  show(nombre)
];



