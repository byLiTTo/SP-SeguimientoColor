% FASE 1: GENERACI�N DE MATERIAL

clear
close all
clc

% =========================================================================
% 1.1 Secuencia de video para evaluar el funcionamiento del algoritmo de 
%   seguimiento
% =========================================================================
%% OBTENCION FPS DE LA C�MARA
   
video = videoinput('winvideo',1,'YUY2_320x240');
video.TriggerRepeat = inf;
video.FrameGrabInterval = 1;

TIEMPO = [];

disp('ACTIVANDO c�mara para c�lculo de FPS...');
start(video)
while video.FramesAcquired < 300
    [I TIME] = getdata(video,1);
    TIEMPO = [TIEMPO; TIME];
    disp('.')
end
stop(video)
flushdata(video);
disp('APAGANDO c�mara...');

% Contador donde obtendremos los FPS a los que trabaja nuestra c�mara
camaraFPS = 0;
for i=1:length(TIEMPO)
    if floor(TIEMPO(i)) == 1
        camaraFPS = camaraFPS+1;
    end
end

% N�mero de FPS a los que queremos que se grabe el v�deo
videoFPS = 10;

% Intervalo de captura de cada frame al que debe trabajar el v�deo,
% para que se grabe a la cantidad de FPS deseada
intervalo = camaraFPS/videoFPS;
    
%% GENERACI�N DE ARCHIVO DE V�DEO

% Nombre que le vamos a poner al archivo.avi que vamos a generar
nombre = '01_Color.avi';

% Duraci�n deseada del v�deo que grabaremos
duracion = 30;

% N�mero de frames que debemos capturar para que se cumpla la duraci�n
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
disp('ENCENDIENDO c�mara para grabaci�n de video');
open(avi)
start(video)
while video.FramesAcquired < framesTotales
    I = getdata(video,1);
    writeVideo(avi,I);
    imshow(I),title(['Duraci�n: ' num2str(frames/videoFPS)])
    disp(['Duraci�n: ' num2str(frames/videoFPS)])
    frames = frames+1;
end
stop(video)
close(avi)
close all;
clc
disp('APAGANDO c�mara');
    
% =========================================================================
% 1.2 Im�genes de calibraci�n
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

% Matriz donde almacenaremos todas las im�genes
imagenes = []; 
imagenes = uint8(imagenes);

% Duraci�n del temporizador antes de capturar la foto
duracion = 5;

% N�mero de frames que debemos capturar para que se cumpla la duraci�n
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
    
%% GUARDADO DE LAS IM�GENES EN PAQUETE .MAT
    
disp('....');
disp('GUARDANDO archivo .mat');
save('ImagenesEntrenamiento_Calibracion.mat','imagenes');
disp('ARCHIVO GUARDADO');

