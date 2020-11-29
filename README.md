# TPE tla
En primer lugar para poder compilar el proyecto debemos tener instaladas las dependencias de linux para compilar lex y yacc.

En ubuntu se puede lograr con el siguiente comando: 
sudo apt install bison flex

Una vez instaladas estas dependencias pararse en el directorio raiz del proyecto y ejecutar el comando "make all" el cual creara un archivo de nombre "erstellen" que sera nuestro compilador.

Para compilar un archivo y generar un ejecutable hace falta utilizar el script "Sprache.sh" de la siguiente manera: 
./Sprache.sh <path de archivos .de> <nombre ejecutable>

Esto generara dos archivos de salida, uno con extension .c con el codigo generado por nuestro compilador en c y el ejecutable.

Aclaracion: puede que el script requiera permisos de ejecucion para poder ser utilizado, lo cual se puede realizar mediante el comando chmod +x <script path>