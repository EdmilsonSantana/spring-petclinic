FROM jenkins/jenkins:lts

USER root

RUN apt-get update \
    && apt-get install -y apt-transport-https ca-certificates curl software-properties-common \
    && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - \
    && add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable" \
   && apt-get update && apt-get install -y docker-ce docker-ce-cli containerd.io \
   && rm -rf /var/lib/apt/lists/*

RUN usermod -a -G sudo jenkins
RUN echo "jenkins ALL=NOPASSWD: ALL" >> /etc/sudoers

USER jenkins