FROM letfn/python

USER root
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get install -y nodejs
RUN find /usr -name node -ls && node --version
RUN npm install npm --global
RUN npm install pkg --global

USER app
COPY --chown=app:app requirements.txt /app/src/requirements.txt
RUN . /app/venv/bin/activate && pip install --no-cache-dir -r /app/src/requirements.txt

RUN cd /tmp && touch index.js && pkg -t node12-darwin,node12-linux index.js && rm -f index.js index-*

COPY plugin /plugin

ENTRYPOINT [ "/tini", "--", "/plugin" ]
