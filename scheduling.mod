{string} Course = {"CSO1", "CSO2", "CSO3", "CSO4", "CSO5", "CSO6", "CSO7", "CSO8"};
{string} Faculty = ...;
{float} Day = ...;
{float} Timeslot = ...;
float T[Timeslot] = ...;
float Delta = ...;

float R[Faculty][Course] = ...;
float S[Faculty] = ...;
float P[Faculty][Timeslot] = ...;

float W = 1;
float U = 1;
float V = 1;
float Y = 1;
float Z = 1;

dvar boolean a[Faculty][Course][Day][Timeslot];
dvar float+ v[Faculty];
dvar boolean y[Faculty][Day][Timeslot];
dvar boolean z[Faculty][Day][Timeslot];

maximize
      sum(f in Faculty, c in Course, d in Day, t in Timeslot) a[f,c,d,t]*(P[f,t]*V + S[f]*W)
    // - U*sum(f in Faculty, c in Course, d in Day) (
    //     sum(t in Timeslot : t       < 540) a[f,c,d,t] +
    //     sum(t in Timeslot : t+Delta > 960) a[f,c,d,t] 
    // )
    - V*sum(f in Faculty) v[f]
    // - Y*sum(f in Faculty, d in Day, t in Timeslot) y[f,d,t]
    // - Z*sum(f in Faculty, d in Day, t in Timeslot) z[f,d,t]
    ;

subject to {
    forall(f in Faculty, d in Day, t in Timeslot) sum(c in Course) a[f,c,d,t] <= 1;                    // 7
    forall(f in Faculty, c in Course) sum(d in Day, t in Timeslot) a[f,c,d,t] == R[f,c];               // 8
    forall(d in Day, t in Timeslot) sum(f in Faculty, c in Course) a[f,c,d,t] <= 3;                    // 9

    forall(f in Faculty : f != "contingent") sum(d in Day, t in Timeslot) a[f,"CSO3",d,t] <= 2 + v[f]; // 11
    // forall(f in Faculty, d in Day, t in Timeslot : (t-2) in Timeslot) sum(c in Course) 
}

execute OUTPUT_RESULTS {
   var file = new IloOplOutputFile("solutionScheduling.txt", true);
   file.writeln("Objective Function = ", cplex.getObjValue());

   file.write("| |");
   for (var d in Day){
       file.write(" ", d, " |");
   }
   file.write("\n");

   file.write("|-|");
   for (var d in Day){
       file.write("-|");
   }
   file.write("\n");

   for (var t in Timeslot){
     	file.write("|", Opl.floor(T[t]/60), ":", T[t]%60, "|");
     	for (var d in Day){
     		for (var f in Faculty)
                for (var c in Course){
                    if (a[f][c][d][t] == 1) 
                        file.write("(", f, "-", c, "), ");
                }
            file.write("|");
     	}
        file.write("\n");
    }
}
 
