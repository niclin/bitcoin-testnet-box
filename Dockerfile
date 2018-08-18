# bitcoin-testnet-box docker image

# Ubuntu 14.04 LTS (Trusty Tahr)
FROM ubuntu:14.04
LABEL maintainer="Nic Lin <niclin0226@gmail.com>"

# add bitcoind from the official PPA
# install bitcoind (from PPA) and make
RUN apt-get update && \
	apt-get install --yes software-properties-common && \
	add-apt-repository --yes ppa:bitcoin/bitcoin && \
	apt-get update && \
	apt-get install --yes bitcoind make

# create a non-root user
RUN adduser --disabled-login --gecos "" tester

# run following commands from user's home directory
WORKDIR /home/tester

# copy the testnet-box files into the image
ADD . /home/tester/bitcoin-testnet-box

# make tester user own the bitcoin-testnet-box
RUN chown -R tester:tester /home/tester/bitcoin-testnet-box

# color PS1
RUN mv /home/tester/bitcoin-testnet-box/.bashrc /home/tester/ && \
	cat /home/tester/.bashrc >> /etc/bash.bashrc
COPY docker_entrypoint.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/docker_entrypoint.sh

# use the tester user when running the image
USER tester

# expose two rpc ports for the nodes to allow outside container access
EXPOSE 18332 19011

# run commands from inside the testnet-box directory
WORKDIR /home/tester/bitcoin-testnet-box
CMD ["/bin/bash"]
ENTRYPOINT ["docker_entrypoint.sh"]
