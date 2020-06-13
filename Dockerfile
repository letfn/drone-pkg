FROM letfn/python

USER root
RUN apt-get install -y nodejs npm
RUN npm install npm --global
RUN npm install pkg --global

RUN touch /drone/src/.defn && chown -R app:app /drone/src

USER app
COPY --chown=app:app requirements.txt /app/src/requirements.txt
RUN . /app/venv/bin/activate && pip install --no-cache-dir -r /app/src/requirements.txt

RUN cd /tmp && touch index.js && pkg -t node12-darwin,node12-linux index.js && rm -f index.js index-*

COPY plugin /plugin

ENTRYPOINT [ "/tini", "--", "/plugin" ]
