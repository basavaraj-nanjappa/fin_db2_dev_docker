
cat /etc/os-release

# update the package
RUN dnf update -y \
    && dnf install -y make unzip

# Install php
dnf module enable -y php:7.4
dnf install -y php7.4
dnf install -y php-json php-mbstring php-xml php-pear php-devel php-pdo php-gd php-zip 

# Setting up of composer
EXPECTED_CHECKSUM="$(php -r 'copy("https://composer.github.io/installer.sig", "php://stdout");')"
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
ACTUAL_CHECKSUM="$(php -r "echo hash_file('sha384', 'composer-setup.php');")"

if [ "$EXPECTED_CHECKSUM" != "$ACTUAL_CHECKSUM" ]
then
    >&2 echo 'ERROR: Invalid installer checksum'
    rm composer-setup.php
    exit 1
fi

php composer-setup.php --quiet
rm composer-setup.php

