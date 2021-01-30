#Сделал так. В Dockerfile указал образ, который мы готовили на практике (ilyukevich/yamdb:v1),
#но оставил образ python:3.8.5, т.к. падают тесты если его убрать.
#В docker-compose для создания второго контейнера WEB указал взять образ из Dockerfile.
#В Dockerfile перенес все команды по автоматизации процессов.
#FROM python:3.8.5

FROM ilyukevich/yamdb:v1

RUN mkdir /code

COPY requirements.txt /code

RUN pip install -r /code/requirements.txt && \
    python manage.py makemigrations && \
    python manage.py makemigrations api && \
    python manage.py migrate


CMD gunicorn api_yamdb.wsgi:application --bind 0.0.0.0:8000
