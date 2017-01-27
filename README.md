###Prolog
============

It may be turtles all the way down in some universes, but not in the data center world. At the bottom of every cloud is a 
bare metal turtle() holding up your VMs, containers, and apps. If you have to install 10 - 100s of machines on a regular basis, 
with heterogenous hardware and application stacks, you want to be able to automate that from one place, fast.

Kubernetes is an open-source system for automating deployment, scaling, and management of containerized applications. (I stole this quote from the front page of here https://kubernetes.io/.)

Stacki is an open-source system for automating deployment, scaling, and management of bare metal systems. (I plagarized the 93% of 
the above quote I previousl plagarized.)

Together, Stacki+Kubernetes, can deploy a Kubernetes stack on bare metal, in about the same time it takes to make a pot of coffee 
and drink the first couple of cups. 




This pallet will give you a functioning Kubernetes cluster.

On bare metal. 

The only service running in a container is a docker registry if you want it.

It's promiscuous: nothing is nailed down with tls certs yet, or put it on a closed network, but that brings it's own challenges.
