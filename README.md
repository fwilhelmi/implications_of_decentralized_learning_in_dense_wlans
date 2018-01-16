# Implications of Decentralized Learning in Dense WLANs - Submission to FG-ML5G First Meeting

### Authors
* [Francesc Wilhelmi](https://github.com/fwilhelmi)
* [Cristina Cano](http://ccanobs.github.io/)
* [Boris Bellalta](http://www.dtic.upf.edu/~bbellalt/)
* [Anders Jonsson](http://www.tecn.upf.es/~jonsson/)

### Project description
Understanding the consequences of applying Reinforcement Learning (RL) in dense and uncoordinated environments (e.g., Wi-Fi) is critical to optimize the performance of next-generation wireless networks. In this document we present a decentralized approach in which Wireless Networks (WNs) attempt to learn the best possible configuration in an adversarial environment according to their own performance. In particular, we provide a Multi-Armed Bandits (MABs) based model in which devices are allowed to tune their frequency channel, transmit power and Carrier Sense Threshold (CST). Our results show that, despite using only local information, a collaborative behavior can be obtained among independent devices that share the same resources. Furthermore, we study the effects of applying such method under different equilibrium situations with respect to the adversarial setting. Finally, some insights  are provided regarding the consequences of applying learning in presence of legacy nodes.

### Repository description
This repository contains the Code and other files used for the submission done to the FG-ML5G First Meeting, which is held in Geneva, 29 January - 2 February 2018.

### Running instructions
To run the code, just 
1) "add to path" all the folders and subfolders in "./Code", 
2) Access to "Code" folder
3) Execute scripts in folder "./Code/Experiments"

Additional notes:
* The "constants.m" file contains the information regarding the simulation parameters (e.g., number of Wireless Networks, allowed transmit power levels, etc.).
* The experiments output can be found in the "./Code/Output/" folder, in which we store figures and the workspace.

### Contribute

If you want to contribute, please contact to francisco.wilhelmi@upf.edu
