FROM alpine
LABEL maintainer="vincenzo.ampolo@gmail.com"

COPY requirements.txt /

# you can specify python version during image build
ARG PYTHON_VERSION=3.9.9

# install build dependencies and needed tools
RUN apk add \
    wget \
    gcc \
    make \
    zlib-dev \
    libffi-dev \
    openssl-dev \
    musl-dev \
    bzip2-dev \
    libbz2

# download and extract python sources
RUN cd /opt \
    && wget https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz \                                              
    && tar xzf Python-${PYTHON_VERSION}.tgz

# build python and remove left-over sources
RUN cd /opt/Python-${PYTHON_VERSION} \ 
    && ./configure --prefix=/usr --enable-optimizations --with-ensurepip=install \
    && make install \
    && rm /opt/Python-${PYTHON_VERSION}.tgz /opt/Python-${PYTHON_VERSION} -rf

#     && apk add --no-cache python3 openblas libstdc++ \
RUN set -x \
    && apk add --no-cache openblas libstdc++  \
    && python3 -m venv /opt/word2vec_env \
    && source /opt/word2vec_env/bin/activate \
    && python3 -m ensurepip --upgrade \
    && apk add --no-cache --virtual .build-dependencies gcc gfortran build-base freetype-dev libpng-dev openblas-dev \
    && python3 -m pip install -r requirements.txt \
    && apk del .build-dependencies

COPY src /app

EXPOSE 18000
ENV PATH="/opt/word2vec_env/bin:$PATH"
CMD ["python3", "/app/main.py"]
ENV VECTOR_FILE=/opt/data/GoogleNews-vectors-negative300.bin  \
    BINARY_VECTOR_FILE=true
