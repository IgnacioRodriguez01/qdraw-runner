# **qdraw-runner**
### Intérprete gráfico del lenguaje QDraw, utilizado en la materia Elementos de Programación y Lógica de la UNQ.

![qdrawRunner preview](/img/preview.gif)

# **Instalación y uso**
Para instalar el programa, ir a la última [release](https://github.com/IgnacioRodriguez01/qdraw-runner/releases/) del proyecto, y descargar el archivo comprimido correspondiente a tu sistema operativo. Finalmente extraer el mismo, y de ahí crear (o no) un acceso directo al archivo `qdrawRunner.exe`.
***Nota:*** El proyecto se encuentra en desarrollo, ver aclaraciones en la release.
___
El código a ejecutar por el programa será el ubicado en el archivo `data/qdraw.txt`.
Para su correcta interpretación, este deberá obligatoriamente tener unas lineas adicionales al comienzo que serán utilizadas solamente por el intérprete para definir ciertos prerequisitos:

```
    sizeX = <valor>
    sizeY = <valor>
    startX = <valor>
    startY = <valor>
```

Estas lineas representan el tamaño del tablero a utilizar en sus dos ejes, y la posición del cursor al inicio.
___
Para finalmente probar el código de Qdraw, abrir el archivo `qdrawRunner.exe`, y darle a ejecutar. 

**Importante!** Para editar el código y volver a ejecutarlo, se debe editar el archivo `qdraw.txt` y guardarlo, y posteriormente reiniciar el programa.
