{string} Course = {"CSO1", "CSO2", "CSO3", "CSO4", "CSO5", "CSO6", "CSO7", "CSO8"};
{string} Faculty = {"Barbosa", "Castro", "Gerardo", "Lameiras", "Machado", "Pedro", "Queiros", "Soeiro", "contingent_MWF", "contingent_TuTh"};
{string} Faculty_MWF = {"Barbosa", "Castro", "Pedro", "Queiros", "contingent_MWF"};
{string} Faculty_TuTh = {"Gerardo", "Lameiras", "Machado", "Soeiro", "contingent_TuTh"};

float facultyLoad[Faculty] = [3, 2, 3, 3, 1, 3, 3, 3, 1000000000, 1000000000];
float seniority[Faculty] = [2, 4, 3, 2, 10, 6, 6, 5, 1, 1];
float courseLoad[Course] = [2, 6, 5, 1, 1, 6, 1, 1];
float preference[Faculty][Course] = [
    [4, 3, 5, 0, 0, 1, 0, 0],
    [3, 0, 3, 5, 0, 5, 0, 0],
    [1, 3, 3, 0, 0, 5, 0, 5],
    [5, 5, 3, 0, 0, 0, 0, 0],
    [0, 0, 5, 0, 0, 0, 0, 0],
    [3, 5, 5, 0, 0, 1, 0, 0],
    [3, 5, 1, 0, 5, 1, 0, 0],
    [1, 1, 3, 0, 0, 5, 5, 0],
    
    [-1, -1, -1, -1, -1,                // Added data for soft restriction 5 
    -2, 				                // X: Weight that a represents how important it is for course 6 to not be lectured by non-faculty
    -1, -1],

    [-1, -1, -1, -1, -1, -2, -1, -1]    // Contingent data is doubled since there will be different contingents for MWF and TuTh runs
];
float qualification[Faculty][Course] = [
    [1, 1, 1, 1, 1, 0, 1, 0],
    [1, 1, 1, 1, 1, 1, 1, 1],
    [1, 1, 1, 1, 1, 1, 1, 1],
    [1, 1, 1, 1, 1, 0, 1, 1],
    [1, 1, 1, 1, 1, 0, 1, 0],
    [1, 1, 1, 1, 1, 0, 1, 1],
    [1, 1, 1, 1, 1, 0, 1, 1],
    [1, 1, 1, 1, 1, 1, 1, 1],

    [1, 1, 1, 1, 1, 1, 1, 1],           // Added data for contigente faculty
    [1, 1, 1, 1, 1, 1, 1, 1]
]; 
float W1 = 1;
float W2 = 4;

dvar float+ classes[Faculty][Course];
dvar boolean assignment[Faculty][Course];
dvar float+ u[Faculty];
dvar float+ v[Faculty];
maximize
    sum(f in Faculty, c in Course) (classes[f,c] * preference[f,c] * seniority[f])
    - sum(f in Faculty : f != "contingent_MWF" && f != "contingent_TuTh") (
        W1*u[f] +
        W2*v[f]
    );

subject to {
    forall(f in Faculty, c in Course) {
        classes[f,c]*(1-qualification[f,c]) == 0;         // 1
        classes[f,c] >= assignment[f,c];                  // 4
        classes[f,c] <= assignment[f,c]*facultyLoad[f];   // 4
    }
    forall(f in Faculty : f != "contingent_MWF" && f != "contingent_TuTh") {
        sum(c in Course) classes[f,c] == facultyLoad[f];  // 2 
        sum(c in Course) assignment[f,c] <= 2 + u[f];	  // 6
        classes[f,"CSO3"] <= 2 + v[f];	                  // 7
    }
    forall(c in Course) {
        sum(f in Faculty) classes[f,c] == courseLoad[c];  // 3
    }
}

execute OUTPUT_RESULTS {
    var epsilon = 1e-6;
    var file = new IloOplOutputFile("solutionAssignment.txt", true);
    file.writeln("Objective Function = ", cplex.getObjValue());

    file.write("R = [\n");
    for (var i in Faculty_MWF){
        file.write("    [");
        var first = 1;
        for (var j in Course){
            if(first == 0) file.write(", ");
            file.write(classes[i][j]);
            first = 0;
        }
        file.write("],\n");
    }
    file.write("];\n");

    file.write("R = [\n");
    for (var i in Faculty_TuTh){
        file.write("    [");
        var first = 1;
        for (var j in Course){
            if(first == 0) file.write(", ");
            file.write(classes[i][j]);
            first = 0;
        }
        file.write("],\n");
    }
    file.write("];\n");
}
