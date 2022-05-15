{string} Course = {"CSO1", "CSO2", "CSO3", "CSO4", "CSO5", "CSO6", "CSO7", "CSO8"};
{string} Faculty = ...;
{float} Day = ...;
{float} Timeslot = ...;
float T = ...;
float Delta = ...;

float R[Faculty][Course] = ...;
float S[Faculty] = ...;
float P[Faculty][Timeslot] = ...;

float U = ...;
float V = ...;
float Y = ...;
float Z = ...;

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
    // - V*sum(f in Faculty) v[f]
    // - Y*sum(f in Faculty, d in Day, t in Timeslot) y[f,d,t]
    // - Z*sum(f in Faculty, d in Day, t in Timeslot) z[f,d,t]
    
subject to {
    forall(f in Faculty, d in Day, t in Timeslot) sum(c in Course) a[f,c,d,t] <= 1;                    // 7
    forall(f in Faculty, c in Course) sum(d in Day, t in Timeslot) a[f,c,d,t] == R[f,c];               // 8
    forall(d in Day, t in Timeslot) sum(f in Faculty, c in Course) a[f,c,d,t] <= 3;                    // 9

    // forall(f in Faculty : f != "contingent") sum(d in Day, t in Timeslot) a[f,"CSO3",d,t] <= 2 + v[f]; // 11
    // forall(f in Faculty, d in Day, t in Timeslot : (t-2) in Timeslot) sum(c in Course) 
}
