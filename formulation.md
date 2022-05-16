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
$L_f$: Course load for faculty member $f$, as in, number of classes taught in a week
$S_f$: Seniority of faculty member $f$

$N_c$: Required number of classes for course $c$

$P_{f,c}$: Preference of faculty member $f$ for course $c$
$Q_{f,c}$: Qualification of faculty member $f$ for course $c$

$W_1$: Weight that a faculty member's preference has on the objective function
$W_2$: Weight that a faculty member's seniority has on the objective function
$X$: Weight that a represents how important it is for course 6 to not be lectured by non-faculty (soft restriction 5)
$W_3$: Weight that represents how important it is that no more than 2 courses are assigned to any full-time faculty (soft restriction 6)
$W_4$: Weight that represents how important it is that no more than 2 classes of the course 3 are assigned to any full-time faculty (soft restriction 7)


#### Decision Variables
$r_{f,c}$: Number of classes of course $c$ given by faculty member $f$ 

$p_{f,c}$: Assignment of faculty member $f$ to course $c$, boolean variable that is 1 when $r_{f,c} \geq 1$ and 0 when $r_{f,c} = 0$

$s_f$: Number of course preparations above 2, for each full-time faculty member $f$. Used for soft restriction 6

$v_f$: Number of classes of the course CSO3 above 2 assigned to each full-time faculty member $f$. Used for soft restriction 7

#### Objective Function
Maximize $\displaystyle \sum_{f}\sum_{c} r_{f,c}(P_{f,c}W_1 + S_f W_2) - W_3 \sum_{f} {s_f} - W_4 \sum_{f} {v_f}$

#### Constraints
##### Hard restrictions
**Domain constraints**
$r_{f,c} \in \mathbb{Z}_0^+$
$p_{f,c} \in \{0,1\}$
$s_f \in \mathbb{Z}_0^+$
$v_f \in \mathbb{Z}_0^+$
<!-- $\displaystyle s_f = \max\left\{0, \sum_c {r_{f,c}} - 2\right\}$ -->

1. **Each faculty is assigned to only the courses that he/she is qualified to teach.**
$\displaystyle \forall f, c: r_{f,c}(1-Q_{f,c}) = 0$

2. **Each full-time faculty member’s actual course load must be equal to his/her required course load per semester according to their contracts**
$\displaystyle \forall f \neq \alpha: \sum_{c} r_{f,c} = L_f$

3. **The number of classes assigned to faculties needs to be equal to the number of classes required for each course**
$\displaystyle \forall c: \sum_{f} r_{f,c} = N_c$

4. **Relate $r_{f,c}$ to its boolean counterpart $p_{f,c}$**
$\displaystyle \forall f, c: r_{f,c} \leq p_{f,c} \cdot L_f$
$\displaystyle \forall f, c: r_{f,c} \geq p_{f,c}$

##### Soft restrictions
5. **All courses, and particularly CSO6, are to be taught by full-time faculty, if possible.**
This soft restriction is encoded by defining $P_{\alpha,c}$. Namely:
$\forall c \neq 6, P_{\alpha, c} = -1$
$P_{\alpha, 6} = -X$

6. **Ideally, the number of preparations (different courses that each faculty taught per semester) for each full-time faculty would be no more than two.**
$\displaystyle \forall f \neq \alpha: \sum_{c} p_{f,c} \leq 2 + s_f$

7. **Ideally, no more than two classes of the course CSO3 should be assigned to any full-time faculty**
$\displaystyle \forall f \neq \alpha: r_{f,3} \leq 2 + v_f$

---

### Scheduling Phase
The MWF and TuTh problems have the same formulation, with different input set and duration $\Delta$ for Timeslots

#### Sets and Indices
- MWF Timeslots: {9:10, 10:20, 11:30, 13:30, 14:40, 15:50, 17:25}
- TuTh Timeslots: {8:15, 9:50, 11:25, 13:00, 14:35, 16:10, 18:00}

#### Parameters
$R_{f,c}$: Assignment of faculty member $f$ to course $c$. Result of previous stage; i.e., how much load from course $c$ was allocated to faculty member $f$

<!-- $L_f$: Course load for faculty member $f$, as in, number of classes taught in a week -->

$S_f$: Seniority of faculty member $f$

$P_{f,t}$: Preference of faculty member $f$ for timeslot $t$

$D_d$: Day of week; can be $\{1,3,5\}$ and $\{2, 4\}$.

$T_t$: Start time of timeslot $t$
$\Delta$: Duration of the time slots
> (...) sixty minutes per class on Monday, Wednesday, and Friday (MWF) or (...) 85 minutes per class on Tuesday and Thursday (TuTh) 

$W_1$: Weight that a faculty member's preference of slots has on the objective function
$W_2$: Weight that a faculty member's seniority has on the objective function

$W_3$: Weight that represents how important it is for classes to avoid begining too early or ending too late in a day (soft restriction 11)
$W_4$: Weight that a represents how important it is for faculty members to not lecture more than 2 consecutive classes (soft restriction 12)
$W_5$: Weight that a represents how important it is for faculty members to not lecture consecutive classes in the afternoon (soft restriction 13)

#### Decision Variables
$a_{f,c,d,t}$: pairing of a course/faculty pair $(f,c)$ to a timeslot $t$ in day $d$.

$y_{f,d,t}$: Number of consecutive classes over 2, starting at timeslot $t$ of day $d$, for faculty member $f$. Used for soft restriction 12

$z_{f,d,t}$: Number of consecutive classes in the afternoon, starting at timeslot $t$ of day $d$, for faculty member $f$. Used for soft restriction 13

#### Objective Function
Maximize $\displaystyle \sum_{f}\sum_{c}\sum_{d}\sum_{t} a_{f,c,d,t}(P_{f,t} W_1 + S_f W_2) - W_3 U' - W_4 \sum_{f}\sum_{d}\sum_{t} y_{f,d,t} - W_5 \sum_{f}\sum_{d}\sum_{t} z_{f,d,t}$

#### Constraints
##### Hard restrictions
**Domain constraints**
$a_{f,c,d,t} \in \{0, 1\}$
$y_{f,d,t} \in \{0, 1\}$
$z_{f,d,t} \in \{0, 1\}$

8. **Each full-time faculty member can be teaching at most one course at one given timeslot** :egg: 
$\displaystyle \forall f, d, t: \sum_c a_{f,c,d,t} \leq 1$

9. **A teacher must lecture exactly as many timeslots of a course as he was assigned in a previous stage** :egg: 
$\displaystyle \forall f, c: \sum_d\sum_t a_{f,c,d,t} = R_{f,c}$

<!-- 
6. **Each full-time faculty member’s actual course load must be equal to his/her required course load per semester according to their contracts**
$\displaystyle \forall f: \sum_{c}\sum_{t} a_{f,c,t} = L_f$ 
-->

10. **At most three course classes can be assigned to the same class period**
$\displaystyle \forall d,t: \sum_{f}\sum_{c} a_{f,c,d,t} \leq 3$

##### Soft restrictions
11. **Most of the students and faculty preferred that their class day began later than 9:00 am and ended before 4:00 pm**
$\displaystyle U' = \sum_{f} \sum_{c} \sum_{d}\left(\sum_{t:~T_t < 9:00}{a_{f,c,d,t}} + \sum_{t:~T_t+\Delta > 16:00}{a_{f,c,d,t}}\right)$
*Note: $U'$ is a temporary variable*

12. **Avoid having instructors teach more than two consecutive class periods in a day**
$\displaystyle \forall f, d, \forall t < T-2: \sum_{c} (a_{f,c,d,t} + a_{f,c,d,t+1} + a_{f,c,d,t+2}) \leq 2 + y_{f,d,t}$
<!-- $\displaystyle \forall f: \sum_{t=1}^{T-2} (a_{f,c,t} + a_{f,c,t+1} + a_{f,c,t+2}) \leq 2 + y_{f,t}$ -->

13. **as well as back-to-back classes scheduled in the afternoon**
$\displaystyle \forall f, d, \forall t < T-1 \wedge T_t \geq \text{12:00}: \sum_{c} (a_{f,c,d,t} + a_{f,c,d,t+1}) \leq 1 + z_{f,d,t}$
<!-- $\displaystyle \forall f: \sum_{t:~T_t>12:00}^{T-1} (a_{f,c,t} + a_{f,c,t+1}) \leq 1 + z_{f,t}$ -->
