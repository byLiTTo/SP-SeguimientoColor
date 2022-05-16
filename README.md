# IMPLEMENTACIÓN DE ALGORITMO BÁSICO DE SEGUIMIENTO DE OBJETOS POR COLOR
:computer: Proyecto práctico para la asignatura Sistemas de Percepción   
:school: Universidad de Huelva  
:books: Curso 2019-2020


# Objetivo del trabajo
Generar una secuencia de video que muestre el seguimiento de un objeto de una escena captada por una WebCam. El seguimiento se basará en el color del objeto y se visualizará a través de una marca en el centroide de cada agrupación conexa de píxeles detectada.

# 1. Generación de material
El código se encuentra en el script de la carpeta `01_GeneracionMaterial`.
## 1.1. Secuencia de video para evaluar el funcionamiento del algoritmo de seguimiento:
Generar un archivo de video con el objeto de estudio moviéndose por una determinada región del espacio.

Obtención de los FPS de la cámara:
```
video = videoinput('winvideo',1,'YUY2_320x240');
video.TriggerRepeat = inf;
video.FrameGrabInterval = 1;
    
TIEMPO = [];
    
disp('ACTIVANDO cámara para cálculo de FPS');
start(video)
while video.FramesAcquired < 300
    [I TIME] = getdata(video,1);
    TIEMPO = [TIEMPO; TIME];
end
stop(video)
flushdata(video);
disp('APAGANDO cámara');

% Contador donde obtendremos los FPS a los que trabaja nuestra cámara
camaraFPS = 0;
for i=1:length(TIEMPO)
    if floor(TIEMPO(i)) == 1
        camaraFPS = camaraFPS+1;
    end
end

% Número de FPS a los que queremos que se grabe el vídeo
videoFPS = 10;

% Intervalo de captura de cada frame al que debe trabajar el vídeo,
% para que se grabe a la cantidad de FPS deseada
intervalo = camaraFPS/videoFPS;
```

Generación de archivo de video:
```
% Nombre que le vamos a poner al archivo.avi que vamos a generar
nombre = '01_Color.avi';

% Duración deseada del vídeo que grabaremos
duracion = 30;

% Número de frames que debemos capturar para que se cumpla la duración
% que hemos indicado
framesTotales = duracion*videoFPS;

%video = videoinput('winvideo',1,'YUY2_320x240');
%video.TriggerRepeat = inf;
video.FrameGrabInterval = intervalo;
video.ReturnedColorSpace = 'rgb';

set(video,'LoggingMode','memory');

avi = VideoWriter(nombre,'Uncompressed AVI');
avi.FrameRate = videoFPS;

frames = 0;
disp('....');
disp('ENCENDIENDO cámara para grabación de video');
open(avi)
start(video)
while video.FramesAcquired < framesTotales
    I = getdata(video,1);
    writeVideo(avi,I);
    imshow(I),title(['Duración: ' num2str(frames/videoFPS)])
    frames = frames+1;
end
stop(video)
close(avi)
close all;
disp('APAGANDO cámara');
```

## 1.2. Imágenes de calibración:
Capturar varias imágenes con el objeto situado en distintas posiciones representativas de la región del espacio que queramos monitorizar, así como una imagen representativa del fondo de la escena (sin el objeto, en la situación más parecida a las imágenes que se hicieron con el objeto).

Lectura de las imágenes del video:
```
video = VideoReader(nombre);
get(video);

% Segundo a partir del cual comenzaremos a capturar imágenes
inicio = 5;

% Número de imágenes que vamos a capturar
numIma = 18;

%Tamaño del salto del vector para que capruremos el número de imágenes
% que hemos indicado
salto = floor((framesTotales-(videoFPS*inicio)) / numIma);

% Matriz donde almacenaremos todas las imágenes
imagenes = []; 
imagenes = uint8(imagenes);

close all

disp('....');
disp('CARGANDO imágenes capturadas');
%disp('pulse cualquier tecla para avanzar...');
frame = (videoFPS*inicio);
for i=1:(numIma-1)
    I = read(video,frame);
    imagenes(:,:,:,i) = I;
    imshow(imagenes(:,:,:,i)), title(['Imagen : ' num2str(i)])
    pause
    frame = frame+salto;
end

% Añadimos la imagen correspondiente al penúltimo frame, que es donde
% el objeto será de menor tamaño (según como hemos grabado los vídeos)
I = read(video,framesTotales-1);
imagenes(:,:,:,numIma) = I;
imshow(imagenes(:,:,:,numIma)), title(['Imagen : ' num2str(numIma)])

%close all;
disp('TERMINADO de cargar imágenes');
```

Guardado de las imágenes en paquete .mat:
```
disp('....');
disp('GUARDANDO archivo .mat');
save('ImagenesEntrenamiento_Calibracion.mat','imagenes');
disp('ARCHIVO GUARDADO');
```

