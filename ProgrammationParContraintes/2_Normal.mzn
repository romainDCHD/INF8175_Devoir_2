% DUCHADEAU Romain (2311547)
% LOPEZ Ines (2404168)

include "globals.mzn"; 

%-----------------------------------------------------------------------------%
% Données
%-----------------------------------------------------------------------------%

% Nombre de tâches
int: n;
% Durée maximal du projet
int: m;
% Limite de ressources pouvant être partagées entre les tâches en cours
int: limite;

% Durée des tâches
array[1..n] of 1..m: duree_tache;
% Ressources requises par les tâches
array[1..n] of 1..m: ressource_tache;

%-----------------------------------------------------------------------------%
% Variables de décisions
%-----------------------------------------------------------------------------%

array[1..n] of var 1..m: debut_tache; % Début des tâches
array[1..n] of var 1..m: fin_tache; % Fin des tâches

%-----------------------------------------------------------------------------%
% Objectif
%-----------------------------------------------------------------------------%

% Fin du projet (variable a minimiser)
var int: fin_projet;

%-----------------------------------------------------------------------------%
% Partie étudiant
%-----------------------------------------------------------------------------%
% Pour ce faire on utilise la contrainte cumulative : https://docs.minizinc.dev/en/stable/lib-globals-scheduling.html %

% On doit d'abord calculer la fin des tâches (début + duréee) %
constraint forall(i in 1..n) (
  fin_tache[i] = debut_tache[i] + duree_tache[i]
);

% Contrainte 1 : On ne dépasse pas la limite d'énergie à un instant donné %
constraint cumulative(debut_tache, duree_tache, ressource_tache, limite);

% Contrainte 2 : Pas plus de 2 tâches ne doivent démarrer en même temps %
% ie : pour chaque temps, on s'assure que maximum 2 tâches démarrent à ce moment là %
constraint forall(t in 0..m) (
  sum([bool2int(debut_tache[i] == t) | i in 1..n]) <= 2
);

% La fin du projet correspond à la fin de la dernière tâche %
constraint fin_projet = max([fin_tache[i] | i in 1..n]);

solve minimize fin_projet;
%-----------------------------------------------------------------------------%

output [
  "Envergure du projet  : ", show(fin_projet), "\n",
  "Début des tâches     : ", show(debut_tache), "\n",
  "Fin des tâches       : ", show(fin_tache), "\n",
];