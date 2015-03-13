FROM    docker-dev.yelpcorp.com/lucid_yelp

ENV     DEBIAN_FRONTEND noninteractive

RUN     apt-get update && \
        apt-get install -y \
            python2.7-dev \
            libmysqlclient-dev \
            python-pkg-resources \
            python-setuptools \
            python-virtualenv \
            python-pip

# Add the service code

# Make workdir here because in requirements.txt -e . looks for setup.py
WORKDIR /code
ADD     requirements.txt /code/requirements.txt
ADD     setup.py /code/setup.py
RUN     virtualenv --python=python2.7 /code/virtualenv_run
RUN     /code/virtualenv_run/bin/pip install \
            -i https://pypi-dev.yelpcorp.com/simple \
            -r /code/requirements.txt

# Share the logging directory as a volume
RUN     mkdir /tmp/logs
VOLUME  /tmp/logs

ADD     . /code

WORKDIR /code
ENV     BASEPATH /code
CMD /code/virtualenv_run/bin/python /code/replication_handler/batch/parse_replication_stream.py
