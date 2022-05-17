function idx = funcion_kmeans(X, k)
    
    % X: Matriz tipo double, cada fila es la descripcion matematica de una muestra
    % k: numero de agrupaciones
    
    % 1.- Inicializacion: agrupacion inicial en el atributo de maxima por
    % dispercion
    
    idx = funcion_agrupa_por_desviacion(X, k);
    
    if sum(unique(idx)>0) ~= k
        for i=1:k-1
            idx(i) = i;
        end
        idx(k:end) = k;
    end

    % Partimos de una agrupacion basada en particion en la componente de mayor distancia

    % Implementamos algoritmo de agrupamiento
    % Dada una agrupacion, calculamos centroides y volvemos a agrupar en base a
    % ellos. Si la agrupacion resultante difiere de la de partida, repetimos
    % operaciones. Cuando las agrupaciones no cambian, termina.

    Matrices_iguales = false;

    while ~(Matrices_iguales)
        C = calcula_centroides(X, idx);
        idx_new = genera_nueva_agrupacion(X,C);
        Matrices_iguales = compara_matrices(idx,idx_new);
        idx = idx_new;
    end
end

function idx = funcion_agrupa_por_desviacion(X, k)
    idx = zeros(length(X),1);
    
    desv = std(X);
    pos_atrib = desv == max(desv);
    Xatrib = X(:,pos_atrib);
        
    intervalo = (max(Xatrib)- min(Xatrib))/k;
    inicio = min(Xatrib);
    siguiente = inicio+intervalo;
    
    for i=1:k
        pos = find(Xatrib >= inicio & Xatrib < siguiente);
        idx(pos) = i;
        
        inicio = siguiente;
        siguiente = siguiente+intervalo+0.1;
    end
end

function C = calcula_centroides(X, idx)
    C = [];
    
    valoresIdx = unique(idx);
    numIdx = length(valoresIdx);
    
    for i=1:numIdx
        F = idx == valoresIdx(i);
        valoresX = X(F,:);
        mediaX = mean(valoresX);
        
        Rc = mediaX(1);
        Gc = mediaX(2);
        Bc = mediaX(3);
        
        C = [C; Rc Gc Bc];
    end
end

function idx = genera_nueva_agrupacion(X, C)
    idx = zeros(length(X),1);
    
    [numAgrup numAtributos] = size(C);
    [numMuestras numComponentes] = size(X);
    
    vectorDistancia = zeros(2,numMuestras);
    
    for i=1:numAgrup
        P = C(i,:)';
        Pamp = repmat(P,1,numMuestras);
        NP = X(:,:)';
        vectorDistancia(i,:) = sqrt(sum((Pamp-NP).^2));
    end
 
    distancia_min = min(vectorDistancia);
    agrupacion = vectorDistancia == distancia_min;
    agrupacion_columna = agrupacion';
    
    for i=1:numAgrup
        idx(agrupacion_columna(:,i)) = i;
    end
    
end

function varLogica = compara_matrices(m1, m2)
    ERROR = double(m1)-double(m2);
    
    m = min(ERROR(:));
    M = max(ERROR(:));
    
    if m==M && m==0
        varLogica = true;
    else
        varLogica = false;
    end
end