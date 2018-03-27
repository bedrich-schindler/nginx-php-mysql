# Nginx, PHP, MySQL - Docker image

This is Docker image based on Ubuntu 16.04 with preconfigured Nginx, PHP 7.2 and MySQL inside. 
It also has tools for development such as Git, Composer, NPM, Grunt and Robo pre-installed.

Web root directory is `/www` and it is configured inside of `/etc/nginx/sites-enabled/default`. 
If you make the change in that file, `service nginx reload` has to be executed. Image is delivered
with three preconfigured configurations `nginx` (default), `symfony3` and `symfony4` which can be
changed using Docker image argument `NGINX_CONFIG`. To login in to the database use user `root` and
password `pass`. 