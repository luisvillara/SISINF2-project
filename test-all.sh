#!/bin/bash
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!" 
rm -rf ./logs
mkdir ./logs
docker-compose run --rm django python manage.py compilemessages > ./logs/messages.log

function execute(){
  local _command=$1
  local _name=$2
  echo "execute: $_command"
  _file="./logs/$_name.log"
  eval $_command > $_file
  output_command=$?
  if [ $output_command -ne 0 ];then
    echo "!!!!!!!!                                             !!!!!!!!"
    echo "!!!!!!!!                 Have errors                 !!!!!!!!"
    echo "!!!!!!!!                                             !!!!!!!!"
    echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    cat $_file
    rm -rf ./logs
    exit
  fi
}

# list of commands
execute "docker-compose run --rm django isort -c -rc -df" isort
execute "docker-compose run --rm django flake8" flake8
execute "docker-compose run --rm django python manage.py check" check
execute "docker-compose run --rm node npm run lint" lint
execute "docker-compose run --rm django py.test --ds=cuchibox.settings.testing -x" tests

echo "!!!!!!!!                                             !!!!!!!!"
echo "!!!!!!!!             All perfect man                 !!!!!!!!"
echo "!!!!!!!!                                             !!!!!!!!"
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
docker-compose run --rm django rm /srv/www/django/locale/es/LC_MESSAGES/django.mo >> ./logs/messages.log
rm -rf ./logs
