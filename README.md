# Resource Efficient Real-Time Reliability Model for Multi-Agent IoT Systems

> This repository contains Matlab scripts and snapshots of the environment to replicate experiments described in publication:
>
> **put a link on the publication here**

Resource Efficient Real-Time Reliability Model for Multi-Agent IoT Systems is called ERT-CORE. 
It defines specific input parameters, i.e., system's workload, average request processing time and availability. Defined parameters reflect system's state and react on its changes. Based on these parameters system reliability evaluation is performed. 

It is resource-efficient model and has a linear time complexity, which allows it to be used for real-time system reliability evaluation for monitoring purposes.


## Time Complexity evaluation
Scripts for time complexity evaluation can be found under `time_complexity/` folder. Please run `main.m` to replicate this experiment. 

There are also snapshots of the Matlab environment, i.e. `finalComputation1.mat`, which could be reused in order to produce time complexity graphs. Time complexity evaluation on 3.7 GHz CPU could take up to one week.

In  the  time  complexity  estimation,  a  pseudo-random  se-quence  of  numbers  is  generated  to  feed  an  input  data  for ERT-CORE  and  Reliability  of  a  Thing  [1]  models.  Only Reliability-Aware  IoT  model  [2]  requires  pseudo-random Poisson  number  distribution  as  an  input  data.  To  exclude an  operating  system  resource  usage  deviations  from  the measurement, a 50 000 iterations for each reliability model computations  with  different  number  of  the  systems  in  the range  of〈0, 1000〉are  performed  and  an  average  time  is taken.


## Measurement
Script for measurement performed in publication can be found under `parameter_behavior/` folder. Please run `sampleParameterBehaviorRandom_nv.m` to replicate this experiment.

In the experiment, a set of user’s agents run in the system. Time periods when specific agent is operational in the simulation are following:
- Agent 1 runs from 25th to 50th second, 
- Agent 2 from 70th to 100th second, 
- Agent 3 from 130th to 145th second, 
- and Agent 4 from 160th to 185th second.


## Authors

**Ivan Eroshkin** received the B.S. degree in electrical engineering from Czech Technical University in Prague, Czech Republic, in 2017, the M.S. degree in electrical engineering from Czech Technical University in Prague, Czech Republic, in 2020 and the M.S. degree in mobile computing systems from EURECOM, Sophia Antipolis, France, in 2020. He is currently pursuing the Ph.D. degree in electrical engineering at Czech Technical University in Prague, Czech Republic.

In 2019, he was a Research Intern in the Nokia Bell Labs, Paris, France.
From 2020 to 2021, he was a Research Intern in the Open Networking Foundation, Menlo Park, California, USA.
His research interests include the development of Software-Defined Networks and future Internet of Things, software virtualization, optimization techniques for embedded devices.


**Lukas Vojtech** received his MSc and PhD degree in telecommunication engineering from the Czech Technical University in Prague, Czech Republic in 2003 and 2010 respectively. Now, he is Associate Professor at the Department of Telecommunication Engineering at the Czech Technical University in Prague, Czech Republic. 

From 2006 to 2007, he has joined Sitronics R&D centre in Prague focusing on hardware development. From 2012, he has participated in Eureka founded projects AutoEPCIS and U-Health (member of the project coordination committees) and national (CZ government) projects NANOTROTEX, BE-TEX, KOMPOZITEX and RFID LOCATOR. In the last five years, he acts as project leader and member of the project coordination committees. His current research activities include Electromagnetic compatibility, Radiofrequency identification, Internet of Things and Hardware development.

Lukas Vojtech is a Member (M) of IEEE Czechoslovakia Section from year 2011, IEEE Region: R8 -Europe.


**Marek Neruda** received his MSc and PhD degree in telecommunication engineering from the Czech Technical University in Prague, Czech Republic in 2007 and 2014 respectively. Now, he is Researcher at the Department of Telecommunication Engineering at the Czech Technical University in Prague, Czech Republic. 

From 2012, he has participated in Eureka founded projects AutoEPCIS and U-Health and national (CZ government) projects NANOTROTEX, KOMPOZITEX and RFID LOCATOR. His current research activities include Electromagnetic compatibility, Radiofrequency identification and Internet of Things.


## References
[1] D. Ursino and L. Virgili. Humanizing IoT: Defining the Profile and the Reliability  of  a  Thing  in  a  Multi-IoT  Scenario,  pages  51–76. Springer International Publishing, Cham, 2020.

[2] Jingjing Yao and Nirwan Ansari. Fog resource provisioning in reliability-aware  IoT  networks. IEEE  Internet  of  Things  Journal,  6(5):8262–8269,2019.
