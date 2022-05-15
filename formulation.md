# Optimization Project
**COURSE SCHEDULING IN THE COMPUTER SCIENCE AND OPTIMISATION DEPARTMENT OF MONFORT COLLEGE**

## Notes from statement

- > Gerardo said, “I suggest that we model it in two stages: in stage 1, we assign courses to the faculty; in stage 2, we assign each coursefaculty pair to a class time.” Pedro liked the idea. Gerardo added, “An additional advantage is that we can split the scheduling stage into two separate problems: MWF and TuTh.”

- > They also agreed that the preferences of senior faculty would be prioritized over those of junior faculty (...) (Table 4).
<!-- ![](https://i.imgur.com/NyYHPqv.png) -->

### Course Assignment Phase
#### Hard restrictions
- > Each faculty is assigned to only the courses that he/she is qualified to teach (Table 5). For example, Dr. Barbosa is qualified to teach all courses except CSO6 and CSO8. 
![](https://i.imgur.com/pR2VsRv.png)

Note: We will assume that contingent faculty can be qualified to teach any course.

#### Soft restrictions
- > (...) he would like all courses, and particularly CSO6, to be taught by full-time faculty, if possible

- > Ideally, the number of preparations (different courses that each faculty taught per semester) for each full-time faculty would be no more than two.

### Scheduling Phase
#### Hard restrictions
- > Each full-time faculty member’s actual course load must be equal to his/her required course load per semester according to their contracts (Table 4).
![](https://i.imgur.com/NyYHPqv.png)

- > The number of classes assigned to the faculty needs to be equal to the number of classes required for each course (Table 6). For example, the CSO department must offer exactly five classes of CSO3 in the Spring 2023 semester over all faculty due to the student demand.
![](https://i.imgur.com/cmR6dSp.png)

- > At most three course classes can be assigned to the same class period based on allotments determined by the Assistant Dean. In other words, no more than three classes of one or multiple CSO courses can be scheduled in the same class period.


#### Soft restrictions
- > Most of the students and faculty preferred that their class day began later than 9:00 am and ended before 4:00 pm

- > Ideally, no more than two classes of the course CSO3 should be assigned to any full-time faculty because of the extra workload emanating from the lab.

- > (...) it would be reasonable to try to avoid having instructors teach more than two consecutive class periods in a day

 - > In fact, he did not have a pleasant experience with back-to-back classes scheduled in the afternoon


### Objective Function

- > (...) the objective of the optimization model in each of the two stages, i.e. the “course assignment” stage and the “scheduling” stage, would be maximizing the total faculty preferences
![](https://i.imgur.com/9q4ZqLz.png)


## Formulation
### Course Assignment Phase
#### Sets and Indices
- Courses \(C\): {$CS01$, $CS02$, $CS03$, $CS04$, $CS05$, $CS06$, $CS07$, $CS08$}
- Faculty Members (F): {*Barbosa*, *Castro*, *Gerardo*, *Lameiras*, *Machado*, *Pedro*, *Queirós*, *Soeiro*, *contingent*}
To simplify, this set can be represented by the initials of each name, with *contingent* represented as $\alpha$


#### Parameters
$S_f$: Seniority of faculty member $f$

$P_{f,c}$: Preference of faculty member $f$ for course $c$
$Q_{f,c}$: Qualification of faculty member $f$ for course $c$

$W_P$: Weight that a faculty member's preference has on the objective function
$W_S$: Weight that a faculty member's seniority has on the objective function
$X$: Weight that a represents how important it is for course 6 to not be lectured by non-faculty

#### Decision Variables
$r_{f,c}$: Assignment of faculty member $f$ to course $c$

$s_f$: Number of course preparations above 2, for each faculty member $f$. Used for soft restriction 3

#### Objective Function
Maximize $\displaystyle \sum_{f}\sum_{c} r_{f,c}(P_{f,c}W_P + S_f W_S) - \sum_{f} {s_f}$

#### Constraints
##### Hard restrictions
**Domain constraints**
$r_{f,c} \in \{0, 1\}$
$s_f \in \mathbb{Z}_0^+$
<!-- $\displaystyle s_f = \max\left\{0, \sum_c {r_{f,c}} - 2\right\}$ -->

1. **Each faculty is assigned to only the courses that he/she is qualified to teach.**
$\forall f, c: r_{f,c} \leq Q_{f,c}$

##### Soft restrictions
2. **All courses, and particularly CSO6, are to be taught by full-time faculty, if possible.**
This soft restriction is encoded by defining $P_{\alpha,c}$. Namely:
$\forall c \neq 6, P_{\alpha, c} = -1$
$P_{\alpha, 6} = -X$

3. **Ideally, the number of preparations (different courses that each faculty taught per semester) for each full-time faculty would be no more than two.**
$\displaystyle \forall f \neq \alpha: \sum_{c} r_{f,c} \leq 2 + s_f$

---

### Scheduling Phase
The MWF and TuTh problems have the same formulation, with different input set for Timeslots

#### Sets and Indices
- MWF Timeslots: {9:10, 10:20, 11:30, 13:30, 14:40, 15:50, 17:25}
- TuTh Timeslots: {8:15, 9:50, 11:25, 13:00, 14:35, 16:10, 18:00}

#### Parameters
$R_{f,c}$: Assignment of faculty member $f$ to course $c$. Result of previous stage

$L_f$: Course load for faculty member $f$, as in, number of classes taught in a week

$S_f$: Seniority of faculty member $f$

$P_{f,t}$: Preference of faculty member $f$ for timeslot $t$

$N_c$: Required number of classes for course $c$

$T_t$: Start time of timeslot $t$
$D$: Duration of the time slots
> (...) sixty minutes per class on Monday, Wednesday, and Friday (MWF) or (...) 85 minutes per class on Tuesday and Thursday (TuTh) 

$U$: Weight that represents how important it is for classes to avoid begining too early or ending too late in a day (soft restriction 9)
$V$: Weight that a represents how important it is that no more than two classes of the course 3 are assigned to any full-time faculty (soft restriction 10)
$Y$: Weight that a represents how important it is for faculty members to not lecture more than 2 consecutive classes (soft restriction 11)
$Z$: Weight that a represents how important it is for faculty members to not lecture consecutive classes in the afternoon (soft restriction 12)

#### Decision Variables
$a_{f,c,t}$: pairing of a course/faculty pair $(f,c)$ to a timeslot $t$, taught on the period $t$.

$v_f$: Number of classes of the course CSO3 above 2 assigned to each faculty member $f$. Used for soft restriction 10

$y_{f,t}$: Number of consecutive classes over 2, starting at timeslot $t$, for faculty member $f$. Used for soft restriction 11

$z_{f,t}$: Number of consecutive classes in the afternoon, starting at timeslot $t$, for faculty member $f$. Used for soft restriction 12

#### Objective Function
Maximize $\displaystyle \sum_{f}\sum_{c}\sum_{t} a_{f,c,t}(P_{f,t}V + S_f W) - UU' - V \sum_{f} {v_f} - Y \sum_{f}\sum_{t} y_{f,t} - Z \sum_{f}\sum_{t} z_{f,t}$

#### Constraints
##### Hard restrictions
**Domain constraints**
$a_{f,c,t} \in \{0, 1\}$
$v_f \in \mathbb{Z}_0^+$
$y_{f,t} \in \{0, 1\}$
$z_{f,t} \in \{0, 1\}$

4. **Each full-time faculty member can be teaching at most one course at one given timeslot** :egg: 
$\displaystyle \forall f, t: \sum_c a_{f,c,t} \leq 1$

5. **A teacher can only teach a course he was assigned in a previous stage** :egg: 
$\displaystyle \forall f, c, t: a_{f,c,t} \leq R_{f,c}$

6. **Each full-time faculty member’s actual course load must be equal to his/her required course load per semester according to their contracts.**
$\displaystyle \forall f: \sum_{c}\sum_{t} a_{f,c,t} = L_f$ 

7. **The number of classes assigned to the faculty needs to be equal to the number of classes required for each course**
$\displaystyle \forall c: \sum_{f}\sum_{t} a_{f,c,t} = N_c$

8. **At most three course classes can be assigned to the same class period**
$\displaystyle \forall t: \sum_{f}\sum_{c} a_{f,c,t} \leq 3$

##### Soft restrictions
9. **Most of the students and faculty preferred that their class day began later than 9:00 am and ended before 4:00 pm**
$\displaystyle U' = \sum_{f} \sum_{c}\left(\sum_{t:~T_t < 9:00}{a_{f,c,t}} + \sum_{t:~T_t+D > 16:00}{a_{f,c,t}}\right)$
*Note: $U'$ is a temporary variable*

10. **Ideally, no more than two classes of the course CSO3 should be assigned to any full-time faculty**
$\displaystyle \forall f \neq \alpha: \sum_{t} a_{f,3,t} \leq 2 + v_f$

11. **Avoid having instructors teach more than two consecutive class periods in a day**
$\displaystyle \forall f, \forall t < T-2: \sum_{c} (a_{f,c,t} + a_{f,c,t+1} + a_{f,c,t+2}) \leq 2 + y_{f,t}$
<!-- $\displaystyle \forall f: \sum_{t=1}^{T-2} (a_{f,c,t} + a_{f,c,t+1} + a_{f,c,t+2}) \leq 2 + y_{f,t}$ -->

12. **as well as back-to-back classes scheduled in the afternoon**
$\displaystyle \forall f, \forall t < T-1 \wedge T_t>\text{12:00}: \sum_{c} (a_{f,c,t} + a_{f,c,t+1}) \leq 1 + z_{f,t}$
<!-- $\displaystyle \forall f: \sum_{t:~T_t>12:00}^{T-1} (a_{f,c,t} + a_{f,c,t+1}) \leq 1 + z_{f,t}$ -->
