FROM ubuntu:bionic

ENV SPHINX_VERSION 3.2.1-f152e0b

ENV ACCEPT_EULA=Y
RUN apt-get update
RUN apt-get install -y --no-install-recommends locales apt-transport-https curl ca-certificates libmariadb-dev postgresql-server-dev-all unixodbc-dev gnupg
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && locale-gen
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN curl https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list
RUN apt-get update
RUN apt-get install -y --no-install-recommends msodbcsql17 mssql-tools openssl
RUN sed -i -E 's/(CipherString\s*=\s*DEFAULT@SECLEVEL=)2/\11/' /etc/ssl/openssl.cnf

RUN mkdir -pv /opt/sphinx/log /opt/sphinx/index
VOLUME /opt/sphinx/index

RUN curl http://sphinxsearch.com/files/sphinx-${SPHINX_VERSION}-linux-amd64.tar.gz --output /tmp/sphinxsearch.tar.gz
RUN cd /opt/sphinx && tar -xf /tmp/sphinxsearch.tar.gz
RUN rm /tmp/sphinxsearch.tar.gz

ENV PATH "${PATH}:/opt/sphinx/sphinx-3.2.1/bin"
RUN indexer -v

RUN ln -sv /dev/stdout /opt/sphinx/log/query.log
RUN ln -sv /dev/stdout /opt/sphinx/log/searchd.log

EXPOSE 36307

VOLUME /opt/sphinx/conf

CMD searchd --nodetach --config /opt/sphinx/conf/sphinx.conf
