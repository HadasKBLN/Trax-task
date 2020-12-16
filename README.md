# Trax-task

Just a little explanation:

The micro-service files are located in the "service" folder.
The micro-service is written in python, listening to port 12346, 
and containerize (its dockerfile is included).

All the terraform files are located in the "multiRegion" folder.
The AMI used as based image for the instances, I used with AMI which I created, 
by lunching instance from Ubuntu ami, then running the following commands:

    sudo curl -sSL https://get.docker.com/ | sh
    sudo usermod –aG docker `echo $USER`
    sudo docker run –restart=always –p 12346:12346 hadask/morsesrc:1.0

which install docker on the instance, and run the docker image of the morse micro service.
The instances which lunched from this ami have the docker run inside, with port 12346 exposed.

The continue is auditing with terraform files
