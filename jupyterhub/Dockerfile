FROM ahkui/jupyter:latest

LABEL maintainer="ahkui <ahkui@outlook.com>"

RUN npm install --no-cache -g --unsafe-perm=true \
    configurable-http-proxy \
    && python3 -m pip install --no-cache-dir \
    oauthenticator \
    dockerspawner 

COPY jupyterhub_config.py /root/.jupyter/
COPY admin.txt /root/.jupyter/

CMD ["sh", "-c", "jupyterhub upgrade-db && jupyterhub -f /root/.jupyter/jupyterhub_config.py"]
