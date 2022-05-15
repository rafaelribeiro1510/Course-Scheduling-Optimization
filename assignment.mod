/*********************************************
 * OPL 20.1.0.0 Model
 * Author: Diogo Rodrigues (up201806429), Gonçalo Pascoal (up201806332), Rafael Ribeiro (up201806330)
 * Creation Date: May 15, 2022 at 7:30:23 PM
 *********************************************/

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
[1, 1, 3, 0, 0, 5, 5, 0]];
float qualification[Faculty][Course] = [
[1, 1, 1, 1, 1, 0, 1, 0],
[1, 1, 1, 1, 1, 1, 1, 1],
[1, 1, 1, 1, 1, 1, 1, 1],
[1, 1, 1, 1, 1, 0, 1, 1],
[1, 1, 1, 1, 1, 0, 1, 0],
[1, 1, 1, 1, 1, 0, 1, 1],
[1, 1, 1, 1, 1, 0, 1, 1],
[1, 1, 1, 1, 1, 1, 1, 1]];
float W_preference = 1;
float W_seniority = 1;
float X = 1;

 dvar float+ assignment[Faculty][Course];
 minimize sum(i in Doctors, j in Days) hours[i][j]*rate[i][j];
 
 subject to {
   forall(i in Doctors) sum(j in Days)hours[i][j]==supply[i];
   forall(j in Days) sum(i in Doctors)hours[i][j]==demand[j];
 }
 
 execute OUTPUT_RESULTS {
   var file = new IloOplOutputFile("solutionHealthCentre.txt", true);
   file.writeln("Objective Function = ", cplex.getObjValue());
   for (var i in Doctors){
   		file.write("[", i, "] \t-> [");
   		for (var j in Days)
   			file.write(hours[i][j], ", ");
   		file.writeln("]");
  }   	
 }
 