% DUCHADEAU Romain (2311547)
% LOPEZ Ines (2404168)

include "globals.mzn";

%-----------------------------------------------------------------------------%
% Données
%-----------------------------------------------------------------------------%

% Nombre d'acteurs et de rôles
int: n;
% Couleurs des costumes
enum costumes; 
% Costume démandé pour un rôle i (première dimension) par un acteur j (seconde dimension)
array[1..n,1..n] of costumes: choix_costume;

%-----------------------------------------------------------------------------%
% Variables de décisions
%-----------------------------------------------------------------------------%

% Variables de décision pour assigner un acteur à un rôle
array [1..n] of var 1..n: assignation_role;

%-----------------------------------------------------------------------------%
% Partie étudiant
%-----------------------------------------------------------------------------%
% Etablir le lien entre nos variables et assignation_role %

% Contrainte 1 : chaque acteur doit avoir un rôle différent %
constraint all_different(assignation_role);

% Contrainte 2 : chaque acteur doit avoir un costume différent %
constraint
  forall(i in 1..n, j in 1..n where i != j) (
    choix_costume[assignation_role[i], i] != choix_costume[assignation_role[j], j]
  );

% Contrainte 3 : deux acteurs voisins ne jouent pas un rôle adjacent %
%Atttentionn lilmite%
constraint
  forall(i in 1..n-1) (
    abs(assignation_role[i] - assignation_role[i+1]) > 1
  );


%-----------------------------------------------------------------------------%

output	
  ["L'acteur " ++ format(i) ++ 
   " prendra le rôle " ++ format(fix(assignation_role[i])) ++ 
   " (costume " ++ format(choix_costume[fix(assignation_role[i]), i]) ++ ")" ++"\n" 
  | i in 1..n];