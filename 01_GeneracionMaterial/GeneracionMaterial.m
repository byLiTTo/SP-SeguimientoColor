% FASE 1: GENERACIÓN DE MATERIAL

clear
close all
clc

% =========================================================================
% 1.1 Secuencia de video para evaluar el funcionamiento del algoritmo de 
%   seguimiento
% =========================================================================
%% OBTENCION FPS DE LA CÁMARA
   
video = videoinput('winvideo',1,'YUY2_320x240');
video.TriggerRepeat = inf;
video.FrameGrabInterval = 1;

TIEMPO = [];

disp('ACTIVANDO cámara para cálculo de FPS...');
start(video)
while video.FramesAcquired < 300
    [I TIME] = getdata(video,1);
    TIEMPO = [TIEMPO; TIME];
    disp('.')
end
stop(video)
flushdata(video);
disp('APAGANDO cámara...');

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
    
%% GENERACIÓN DE ARCHIVO DE VÍDEO

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
    disp(['Duración: ' num2str(frames/videoFPS)])
    frames = frames+1;
end
stop(video)
close(avi)
close all;
clc
disp('APAGANDO cámara');
    
% =========================================================================
% 1.2 Imágenes de calibración
% =========================================================================
%% GENERACION DE IMAGENES DE CALIBRACION

%video = videoinput('winvideo',1,'YUY2_320x240');
%video.TriggerRepeat = inf;
video.FrameGrabInterval = intervalo;
video.ReturnedColorSpace = 'rgb';

set(video,'LoggingMode','memory');

% Numero de imagenes totales
numIma = 18;
capturas = 0;

% Matriz donde almacenaremos todas las imágenes
imagenes = []; 
imagenes = uint8(imagenes);

% Duración del temporizador antes de capturar la foto
duracion = 5;

% Número de frames que debemos capturar para que se cumpla la duración
% que hemos indicado
framesTotales = duracion*videoFPS;

disp('ENCENDIENDO CAMARA...')
disp('Tienes 5s de temporizador para hacer las fotos')
for i=1:numIma
    frames = 0;
    start(video)
    while  video.FramesAcquired < framesTotales
        I = getdata(video,1);
        imshow(I),title(['FOTO: ' num2str(i) '/' num2str(numIma) ' - ' num2str(frames/videoFPS)])
        frames = frames + 1; 
    end
    imagenes(:,:,:,i) = I;
    stop(video) 
end
disp(' APAGANDO CAMARA...')
close all;
    
%% GUARDADO DE LAS IMÁGENES EN PAQUETE .MAT
    
disp('....');
disp('GUARDANDO archivo .mat');
save('ImagenesEntrenamiento_Calibracion.mat','imagenes');
disp('ARCHIVO GUARDADO');

