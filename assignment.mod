{string} Course = {"CSO1", "CSO2", "CSO3", "CSO4", "CSO5", "CSO6", "CSO7", "CSO8"};
{string} Faculty = {"Barbosa", "Castro", "Gerardo", "Lameiras", "Machado", "Pedro", "Queiros", "Soeiro", "contingent"};

float seniority[Faculty] = [2, 4, 3, 2, 10, 6, 6, 5, 1];
float preference[Faculty][Course] = [
[4, 3, 5, 0, 0, 1, 0, 0],
[3, 0, 3, 5, 0, 5, 0, 0],
[1, 3, 3, 0, 0, 5, 0, 5],
[5, 5, 3, 0, 0, 0, 0, 0],
[0, 0, 5, 0, 0, 0, 0, 0],
[3, 5, 5, 0, 0, 1, 0, 0],
[3, 5, 1, 0, 5, 1, 0, 0],
[1, 1, 3, 0, 0, 5, 5, 0],
 
[-1, -1, -1, -1, -1, // Added data for soft restriction 2 
-1, 				 // X: Weight that a represents how important it is for course 6 to not be lectured by non-faculty
-1, -1]];
float qualification[Faculty][Course] = [
[1, 1, 1, 1, 1, 0, 1, 0],
[1, 1, 1, 1, 1, 1, 1, 1],
[1, 1, 1, 1, 1, 1, 1, 1],
[1, 1, 1, 1, 1, 0, 1, 1],
[1, 1, 1, 1, 1, 0, 1, 0],
[1, 1, 1, 1, 1, 0, 1, 1],
[1, 1, 1, 1, 1, 0, 1, 1],
[1, 1, 1, 1, 1, 1, 1, 1],

[1, 1, 1, 1, 1, 1, 1, 1]]; // Added data for contigente faculty
float W_preference = 1;
float W_seniority = 1;

 dvar boolean assignment[Faculty][Course];
 dvar float+ s[Faculty];
 maximize sum(f in Faculty, c in Course) assignment[f,c]*(preference[f,c]*W_preference + seniority[f]*W_seniority) - sum(f in Faculty) s[f];
 
 subject to {
   forall(f in Faculty, c in Course) assignment[f,c] <= qualification[f,c];
   forall(f in Faculty : f != "contingent") sum(c in Course) assignment[f,c] <= 2 + s[f];
 }
 
 execute OUTPUT_RESULTS {
   var file = new IloOplOutputFile("solutionAssignment.txt", true);
   file.writeln("Objective Function = ", cplex.getObjValue());
   for (var i in Faculty){
   		file.write("[", i, "] \t-> [");
   		for (var j in Course)
   			if (assignment[i][j] == 1)
   				file.write(j, ", ");
   		file.writeln("]");
  }   	
 }
 