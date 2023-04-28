# **qdraw-runner**
Intérprete gráfico del lenguaje QDraw, utilizado en la materia Elementos de Programación y Lógica de la UNQ.

![QDraw Runner preview](/img/preview.gif)

# **Instalación y uso**
Para correr el programa, es necesario instalar Processing. https://processing.org/

El código a ejecutar por el programa será el ubicado en el archivo data/qdraw.txt.
Para su correcta interpretación, este deberá tener unas lineas adicionales al comienzo que serán utilizadas solamente por el intérprete para definir ciertos prerequisitos:

```
    sizeX = <valor>
    sizeY = <valor>
    startX = <valor>
    startY = <valor>
```

Estas lineas representan el tamaño del tablero a utilizar en sus dos ejes, y la posición del cursor al inicio. A partir de la precondición establecida, se deberá colocar aquí lo necesario para que el programa se pueda desplazar adecuadamente.

Para finalmente probar el código de Qdraw, en la IDE de Processing, abrir el archivo qdrawRunner.pde, y darle a ejecutar. 

Si el programa está correcto, se mostrará la ventana con el resultado finalizado, pero si posee algún error se verá este mismo por consola.

Para editar el código y volver a ejecutarlo, se debe editar el archivo y guardarlo, y posteriormente volver a ejecutar la ventana de Processing.
