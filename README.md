# YaMDb (REST API) - база отзывов о фильмах, книгах и музыке.

Проект YaMDb собирает отзывы (Review) пользователей на произведения (Title). Произведения делятся на категории: «Книги», «Фильмы», «Музыка». Список категорий (Category) может быть расширен (например, можно добавить категорию «Изобразительное искусство» или «Ювелирка»).
Сами произведения в YaMDb не хранятся, здесь нельзя посмотреть фильм или послушать музыку.
В каждой категории есть произведения: книги, фильмы или музыка. Например, в категории «Книги» могут быть произведения «Винни Пух и все-все-все» и «Марсианские хроники», а в категории «Музыка» — песня «Давеча» группы «Насекомые» и вторая сюита Баха. Произведению может быть присвоен жанр из списка предустановленных (например, «Сказка», «Рок» или «Артхаус»). Новые жанры может создавать только администратор.
Благодарные или возмущённые читатели оставляют к произведениям текстовые отзывы (Review) и выставляют произведению рейтинг (оценку в диапазоне от одного до десяти). Из множества оценок автоматически высчитывается средняя оценка произведения.
 
## Установка Docker на Linux

Открывайте терминал.

Для начала запустите команду удаления старых версий Docker. Скорее всего — их на вашем компьютере нет, но подстраховаться необходимо:

```
sudo apt remove docker docker-engine docker.io containerd runc 
```

Вывод будет примерно таким:

```
E: Невозможно найти пакет docker-engine
```

Затем обновите индекс пакетов APT и установите пакеты, которые позволят APT загружать пакеты по протоколу https:

```
sudo apt update
# обновить список пакетов

sudo apt install \
  apt-transport-https \
  ca-certificates \
  curl \
  gnupg-agent \
  software-properties-common -y
# установить необходимые пакеты для загрузки через https
```

Добавьте ключ GPG для подтверждения подлинности в процессе установки:

```
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
# ОК
```

apt-key добавляет ключ от репозиториев в систему. Ключи защищают репозитории от возможности подделки пакета.
Добавьте репозиторий Docker в пакеты apt:

```
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
```

Снова обновите индекс пакетов, потому что в APT добавлен новый репозиторий:

```
sudo apt update
```

Теперь установите Docker:

```
sudo apt install docker-ce -y
```

Эта команда установит Docker, запустит демон-процесс и активирует автоматический запуск при загрузке.
Проверьте, что Docker работает:

```
sudo systemctl status docker
```

Теперь выполните команду sudo systemctl enable docker, чтобы докер-демон автоматически запускался при старте системы.
При проблемах с установкой можно выполнить скрипт, который выполнит все команды за вас:

```
# эта команда скачает скрипт для установки докера
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh # эта команда запустит его
```

## Команды для запуска приложения

Для запуска проекта выполните команду от имени суперпользователя:

```
docker-compose up
```

В результате выполнения команды у вас развернётся проект, запущенный через gunicorn с базой данных postgres.
Создадуться два контейнера. infra_sp2_web_1 и infra_sp2_db_1.

Посмотреть список запущенных контейнеров (от имени суперпользователя):

```
docker container ls
```

Запустить контейнер (от имени суперпользователя):

```
docker container start <CONTAINER ID>
```

Остановить контейнер (от имени суперпользователя):

```
docker container stop <CONTAINER ID>
```

## Создание суперпользователя

Для создания суперпользователя необходимо (от имени суперпользователя):

```
docker exec -it <CONTAINER ID> bash
```
где <CONTAINER ID> - ID "infra_sp2_web_1"


внутри контейнера создаем пользователя:

```
python manage.py createsuperuser
```

## Работа приложения 

Пока запущены контейнеры infra_sp2_web_1 и infra_sp2_db_1, приложение доступно по адресу http://localhost:8000

## Как запустить автотесты:

Находясь в директории "infra_sp2" выполните установку пакетов venv и pip:

```
sudo apt install python3-pip python3-venv git -y
```

установите виртуальное окружение:

```
python -m venv venv
```

Запустите виртуальное окружение:

```
source venv/bin/activate
```

Выполните установку зависимостей из файла requirements.txt:

```
pip install -r requirements.txt
```

После установки всех зависимостей из файла, в директории "infra_sp2" запустите автотесты:

```
pytest
```

## Заполнение базы начальными данными

Скопируем fixtures.json в контейнер infra_sp2_web_1:

```
sudo docker cp /infra_sp2/fixtures.json <ID infra_sp2_web_1>:/code/ 
```

Заходим в контейнер:

```
docker exec -it <CONTAINER ID> bash
```
где <CONTAINER ID> - ID "infra_sp2_web_1"


Выполняем команды:

```
python3 manage.py shell  
# выполнить в открывшемся терминале:
>>> from django.contrib.contenttypes.models import ContentType
>>> ContentType.objects.all().delete()
>>> quit()

python manage.py loaddata fixtures.json 
```

Готово.

## Используемые технологии

* [Image YAMDB](https://hub.docker.com/repository/docker/ilyukevich/yamdb) - образ для первого контейнера YAMDB
* [Image POSTGRESQL](https://hub.docker.com/_/postgres) - образ для второго контейнера POSTGRESQL
* [Docker](https://docs.docker.com/engine/install/ubuntu/) - официальная документация Docker
* [Dockerfile](https://docs.docker.com/engine/reference/builder/) - официальная документация Dockerfile
* [Docker Compose](https://docs.docker.com/compose/) - официальная документация Docker Compose

## Автор

* **Artsiom Ilyukevich** - [ilyukevich](https://github.com/ilyukevich)

## Лицензии

Этот проект использует MIT License - see the [LICENSE.md](LICENSE.md)

