FROM ubuntu:24.04
ENV TARGETARCH="linux-x64"
# Also can be "linux-arm", "linux-arm64".

RUN apt update && \
  apt upgrade -y && \
  apt install -y curl git jq libicu74 wget apt-transport-https gnupg2

# Install Azure CLI
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

RUN wget https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb && \
dpkg -i packages-microsoft-prod.deb && \
rm packages-microsoft-prod.deb
RUN su && apt-get update && \ 
 apt-get install -y dotnet-sdk-8.0 && \
 dotnet --list-sdks

WORKDIR /azp/

COPY ./start.sh ./
RUN chmod +x ./start.sh

# Create agent user and set up home directory
RUN useradd -m -d /home/agent agent
RUN chown -R agent:agent /azp /home/agent

USER agent
# Another option is to run the agent as root.
# ENV AGENT_ALLOW_RUNASROOT="true"

ENTRYPOINT [ "./start.sh" ]