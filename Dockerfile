FROM python:3.13-slim-bookworm
LABEL description="Speedtest to InfluxDB data bridge. See README.md for heritage."

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        apt-transport-https \
        apt-utils \
        curl \
        dirmngr \
        gnupg1 \
        iputils-ping \
        libcap2-bin \
    && apt-get -q -y autoremove && apt-get -q -y clean \
    && rm -rf /var/lib/apt/lists/

RUN apt-get update \
    && curl -s https://packagecloud.io/install/repositories/ookla/speedtest-cli/script.deb.sh | bash \
    && apt-get install speedtest \
    && setcap 'cap_net_raw+eip' `readlink -f \`which python\`` \
    && rm -rf /var/lib/apt/lists/

WORKDIR /app

ADD requirements.txt .

RUN pip install --no-cache -r requirements.txt

# Final setup & execution
ADD main.py .
CMD ["python", "main.py"]
