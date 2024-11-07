##############################
# DUCHADEAU Romain (2311547)
# LOPEZ Ines (2404168)
##############################

from schedule import Schedule
import math
import random

def solve(schedule: Schedule, temp_ = 500, alpha = 0.95):
    """
    Your solution of the problem
    :param schedule: object describing the input
    :return: a list of tuples of the form (c,t) where c is a course and t a time slot. 
    """
    # Fonction naive qui génère la solution initiale où chaque cours a un créneau unique
    # DISCLAMER :  Fonction laissée pour montrer notre démarche mais non utilisée ici !!!
    def solution_naive(schedule):
        solution = dict()

        time_slot_idx = 1
        for c in schedule.course_list:

            assignation = time_slot_idx
            solution[c] = assignation
            time_slot_idx += 1

        return solution
    
    # Fonction initiale avancée où on affecte les cours avec le plus de contraintes en premier
    # Notre solution initiale
    def advanced_initial_solution(schedule):
        solution = {}
        # Récupérer les cours et les trier par le nombre de conflits
        courses_sorted = sorted(schedule.course_list, key=lambda c: len(schedule.get_node_conflicts(c)), reverse=True)
        
        # Affecter les cours en fonction des conflits
        for course in courses_sorted:
            assigned = False
            for slot in range(len(schedule.course_list)):
                # Vérifier si l'affectation est valide
                conflict = False
                for conflict_course in schedule.get_node_conflicts(course):
                    if conflict_course in solution and solution[conflict_course] == slot:
                        conflict = True
                        break

                if not conflict:
                    solution[course] = slot
                    assigned = True
                    break
        
        return solution
    
    # Fonction pour chercher un meilleur voisin dans le voisinage actuel - Hill Climbing
    # DISCLAMER :  Fonction laissée pour montrer notre démarche mais non utilisée ici !!!
    def get_best_neighbor(schedule, solution):
        best_neighbor = solution.copy()
        best_cost = schedule.get_n_creneaux(solution)

        for course in solution:
            original_slot = solution[course]
            for new_slot in range(len(schedule.course_list)):  # Tester chaque créneau possible
                if new_slot != original_slot:
                    neighbor = solution.copy()
                    neighbor[course] = new_slot
                    try:
                        # Vérifier si la solution voisine est valide (pas de conflits)
                        if schedule.verify_solution(neighbor):
                            cost = schedule.get_n_creneaux(neighbor)
                            if cost < best_cost:
                                best_neighbor = neighbor
                                best_cost = cost
                    except AssertionError:
                        continue  # Si la solution est invalide, on l'ignore
        return best_neighbor
    
    #Fonction de tirage aléatoire de voisins pour le récuit simulé
    def get_random_neighbor(schedule, solution): 
        neighbor = solution.copy()
        course = random.choice(list(neighbor.keys()))
        
        # Obtenir les créneaux déjà pris par les voisins en conflit
        conflicting_slots = {solution[conflict_course] for conflict_course in schedule.get_node_conflicts(course)}
        
        # Choisir un nouveau créneau aléatoire qui ne cause pas de conflit
        available_slots = [slot for slot in range(len(schedule.course_list)) if slot not in conflicting_slots]
        
        #On choisit un nouveau créneau aléatoirement parmis ceux disponibles
        if available_slots:
            new_slot = random.choice(available_slots)
            neighbor[course] = new_slot
        return neighbor 

############ Implémentation du solveur ############

    # Initialiser la solution    
    # current_solution = solution_naive(schedule)
    current_solution = advanced_initial_solution(schedule)
    current_cost = schedule.get_n_creneaux(current_solution)
    best_solution = current_solution.copy()
    best_cost = current_cost

    temperature = temp_
    max_iterations = 100000

    #Boucle de recuit simulé 
    for _ in range(max_iterations):
        new_solution = get_random_neighbor(schedule, current_solution)
        new_cost = schedule.get_n_creneaux(new_solution)

        if new_cost<current_cost:
            acceptance_proba = 1
        else :
            acceptance_proba = math.exp((current_cost-new_cost)/temperature)

        #Tirage aléatoire pour choisir si on dégrade la solution, sachant que le résultat de random.random()<1 donc un voisin non-dégradant sera toujours pris
        if random.random() < acceptance_proba:
            current_solution = new_solution
            current_cost = new_cost

            if current_cost< best_cost:
                best_solution=current_solution.copy()
                best_cost = current_cost
                #print(f"Nouvelle meilleure solution trouvée avec un coût de {best_cost}")

       #Refroidir la température T(k+1)= alpha T(k)
        temperature *= alpha
        
    return best_solution

    ############ OLD VERSION : Boucle de recherche locale ############
    # improved = True
    # while improved:
    #     improved = False
    #     new_solution = get_best_neighbor(schedule, current_solution)
    #     new_cost = schedule.get_n_creneaux(new_solution)

    #     if new_cost < current_cost:
    #         current_solution = new_solution
    #         current_cost = new_cost
    #         improved = True  # Continuer à chercher les améliorations
    #         print(f"Nouvelle solution trouvée avec coût {current_cost}")

    # Retourner la meilleure solution sous forme de liste de tuples (cours, créneau)
    #return current_solution