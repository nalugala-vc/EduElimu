#/bin/sh 

echo "Installing dependencies";

yay php apache mysql 
echo "Finished installing"

echo " Downloading composer";

php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('sha384', 'composer-setup.php') === 'e21205b207c3ff031906575712edab6f13eb0b361f2085f1f1237b7126d785e826a450292b6cfd1d64d92e6563bbde02') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php
php -r "unlink('composer-setup.php');"

echo "Finished downloading composer"



echo "Cloning respository"

git clone https://github.com/etemesi254/EduElimu; 

echo "Hosting the backend":

cd ./EduElimu/Backend/

composer install

& php artisan serve --host=0.0.0.0


echo "Building app"

cd ../Frontend/web


npm install 

&npm run start



cd ../app

flutter pub get

flutter build

flutter run 
