{string} Course = {"CSO1", "CSO2", "CSO3", "CSO4", "CSO5", "CSO6", "CSO7", "CSO8"};
{string} Faculty = ...;
{string} Day = ...;
{float} Timeslot = ...;
float T[Timeslot] = ...;
float Delta = ...;

float R[Faculty][Course] = ...;
float S[Faculty] = ...;
float P[Faculty][Timeslot] = ...;

float W3 = 100;
float W4 = 1;
float W5 = 1;

dvar boolean a[Faculty][Course][Day][Timeslot];
dvar boolean y[Faculty][Day][Timeslot];
dvar boolean z[Faculty][Day][Timeslot];

maximize
      sum(f in Faculty, c in Course, d in Day, t in Timeslot) (a[f,c,d,t] * P[f,t] * S[f])
    - W3*sum(f in Faculty, c in Course, d in Day) (                                         // 11
        sum(t in Timeslot : T[t]       < 540) a[f,c,d,t] +
        sum(t in Timeslot : T[t]+Delta > 960) a[f,c,d,t] 
    )
    - W4*sum(f in Faculty, d in Day, t in Timeslot) y[f,d,t]
    - W5*sum(f in Faculty, d in Day, t in Timeslot) z[f,d,t]
    ;

subject to {
    forall(f in Faculty, d in Day, t in Timeslot) sum(c in Course) a[f,c,d,t] <= 1;         // 8
    forall(f in Faculty, c in Course) sum(d in Day, t in Timeslot) a[f,c,d,t] == R[f,c];    // 9
    forall(d in Day, t in Timeslot) sum(f in Faculty, c in Course) a[f,c,d,t] <= 3;         // 10
    forall(f in Faculty, d in Day, t in Timeslot : (t+2) in Timeslot) 
        sum(c in Course) (a[f,c,d,t] + a[f,c,d,t+1] + a[f,c,d,t+2]) <= 2 + y[f,d,t];        // 12
    forall(f in Faculty, d in Day, t in Timeslot : (t+1) in Timeslot && T[t] >= 720) 
        sum(c in Course) (a[f,c,d,t] + a[f,c,d,t+1]) <= 1 + z[f,d,t];                       // 13
}

execute OUTPUT_RESULTS {
   function left_pad(s, n, c){
       var ret = "";
       while(ret.length + s.length < n){
           ret += c;
       }
       return ret + s;
   }
  
   var file = new IloOplOutputFile("solutionScheduling.md", true);
   file.writeln("Objective Function = ", cplex.getObjValue());

   file.write("| Day |");
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
     	file.write("| ", left_pad(Opl.floor(T[t]/60).toString(), 2, '0'), ":", left_pad((T[t]%60).toString(), 2, '0'), " | ");
     	for (var d in Day){
     	  var first = 1;
     		for (var f in Faculty)
                for (var c in Course){
                    if (a[f][c][d][t] == 1){
                        if(first == 0) file.write(", ");
                        file.write("(", f, "-", c, ")");
                        first = 0;
                    }                        
                }
            file.write(" | ");
     	}
        file.write("\n");
    }
}
