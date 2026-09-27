---
authors: Daniel Bazo Correa
description:
    Medida de la intensidad de tráfico y fórmulas con que se dimensionan los recursos de
    un sistema con pérdidas o con espera.
title: Erlang y dimensionado de recursos
---

El [capítulo anterior](section_1_teoria_de_colas.md) estableció el marco conceptual de
la teoría de colas, la notación de Kendall y la distinción entre sistemas con pérdidas y
sistemas con espera, ilustrada con el modelo `M/M/1`. Este capítulo retoma esa
distinción para desarrollar las fórmulas que permiten dimensionar recursos concretos,
canales de voz, circuitos de señalización o servidores de un centro de atención, a
partir de una demanda de tráfico y de un objetivo de calidad de servicio. El tratamiento
se limita a la técnica: la aplicación de estas fórmulas al dimensionado de celdas de una
red móvil, con sus particularidades, se trata por separado.

## Introducción

El dimensionado de un sistema con pérdidas o con espera exige traducir dos magnitudes de
entrada, la demanda de tráfico y el objetivo de calidad, en un número de recursos. Las
**fórmulas de Erlang** resuelven esa traducción de forma cerrada bajo un conjunto de
hipótesis concreto: llegadas de Poisson, tiempos de servicio exponenciales y régimen
estacionario, las mismas hipótesis que sostienen el modelo `M/M/1` del capítulo
anterior, extendidas ahora a $c$ servidores. La **fórmula de Erlang B** resuelve el caso
con pérdidas, en el que una petición que no encuentra recurso libre se rechaza. La
**fórmula de Erlang C** resuelve el caso con espera, en el que esa misma petición se
almacena en una cola de capacidad infinita hasta que un servidor queda libre. Ambas
fórmulas comparten la misma magnitud de entrada, la intensidad de tráfico en erlangs, y
se aplican a escenarios distintos que conviene no confundir, porque aplicar Erlang B a
un sistema con espera, o Erlang C a un sistema con pérdidas, produce una estimación de
recursos incorrecta.

## Intensidad de tráfico

### Definición de erlang

La **intensidad de tráfico**, o tráfico ofrecido, se mide en **erlangs** y cuantifica la
ocupación media que un conjunto de peticiones genera sobre un recurso de servicio. Para
un sistema con tasa media de llegadas $\lambda$ y tiempo medio de servicio $1/\mu$, la
intensidad de tráfico es

$$
A = \lambda \cdot \frac{1}{\mu}
$$

donde $\lambda$ es el número medio de peticiones que llegan por unidad de tiempo y
$1/\mu$ es la duración media de cada petición, expresada en la misma unidad de tiempo
que $1/\lambda$. Esta definición generaliza al caso de $c$ servidores la intensidad de
tráfico $\rho = \lambda/\mu$ ya introducida para el modelo `M/M/1`: en un sistema de un
único servidor, $A$ y $\rho$ coinciden, porque toda la ocupación recae sobre el mismo
recurso.

Un **erlang** equivale a una hora de ocupación continua de un único circuito o servidor.
Un tráfico $A = 5$ erlangs no indica cuántas peticiones llegan ni cuánto dura cada una
por separado, sino que la ocupación conjunta que generan equivale a mantener cinco
servidores ocupados de forma continua durante una hora, o, de forma equivalente, a un
único servidor ocupado durante cinco horas. Esta propiedad de agregación es la que hace
del erlang una unidad práctica para el dimensionado: basta con conocer $A$, sin
necesidad de conocer $\lambda$ y $1/\mu$ por separado, para aplicar las fórmulas de este
capítulo.

Conviene distinguir, como en el capítulo anterior, entre el **tráfico ofrecido** $A$, el
que generan los usuarios con independencia de si el sistema puede atenderlo, el
**tráfico cursado** $A_{\text{curs}}$, el que el sistema efectivamente atiende, y el
**tráfico perdido** $A_{\text{bloq}}$, la parte del ofrecido que el sistema rechaza. En
un sistema con pérdidas se cumple $A = A_{\text{curs}} + A_{\text{bloq}}$, y es
precisamente la fracción $A_{\text{bloq}}/A$ la que cuantifica la fórmula de Erlang B.

### Hora cargada

Las fórmulas de este capítulo dimensionan un sistema para un único valor de tráfico
ofrecido $A$, pero la demanda real varía a lo largo del día con el ritmo de actividad de
los usuarios. Dimensionar para el tráfico medio diario dejaría al sistema sin capacidad
suficiente durante los periodos de mayor actividad, mientras que dimensionar para el
instante de máxima demanda absoluta llevaría a un sobredimensionado costoso y
justificado solo unos pocos minutos al año. La solución habitual es dimensionar para la
**hora cargada**, el intervalo continuo de una hora en el que la demanda alcanza su
valor más alto de forma sostenida, típicamente estimado a partir de medidas repetidas en
días representativos y no de un único pico aislado. El tráfico ofrecido $A$ que alimenta
las fórmulas de Erlang B y Erlang C es, salvo que se indique lo contrario, el tráfico
ofrecido durante la hora cargada del sistema que se dimensiona.

## Sistemas con pérdidas

### Hipótesis del modelo

Un sistema con pérdidas se modela, en notación de Kendall, como `M/M/c/c`: llegadas de
Poisson de tasa $\lambda$, tiempo de servicio exponencial de tasa $\mu$, $c$ servidores
y una capacidad total del sistema igual a $c$, sin cola de espera. La ausencia de cola
no es una simplificación menor, sino la hipótesis que define el modelo: una petición que
llega cuando los $c$ servidores están ocupados se rechaza de inmediato, sin almacenarse
en ningún punto del sistema. Esta hipótesis modela con fidelidad un sistema de
conmutación de circuitos, donde un intento de llamada sin canal libre se rechaza en
lugar de esperar, y es la razón por la que aplicar este modelo a un sistema que sí
encola las peticiones excedentes subestima la capacidad realmente disponible.

### Fórmula de Erlang B

La **fórmula de Erlang B** da la probabilidad de que una petición que llega encuentre
los $c$ servidores ocupados y sea rechazada, en función del tráfico ofrecido $A$ y del
número de servidores $c$:

$$
B(c, A) = \frac{\dfrac{A^{c}}{c!}}{\displaystyle\sum_{k=0}^{c} \dfrac{A^{k}}{k!}}
$$

donde $A$ es el tráfico ofrecido en erlangs y $c$ es el número de servidores o canales
disponibles. La fórmula solo depende de estas dos magnitudes, lo que permite tabularla o
programarla de forma directa, aunque su cálculo con la expresión anterior se vuelve
numéricamente inestable para valores de $c$ grandes, porque $A^{c}$ y $c!$ crecen muy
rápido por separado. La forma recursiva evita ese problema:

$$
B(0, A) = 1
$$

$$
B(c, A) = \frac{A \cdot B(c-1, A)}{c + A \cdot B(c-1, A)}
$$

que calcula $B(c, A)$ a partir de $B(c-1, A)$ sin evaluar potencias ni factoriales
grandes, y es la forma que conviene implementar en código.

```python linenums="1"
def erlang_b(canales: int, trafico_erlangs: float) -> float:
    """Calcula la probabilidad de bloqueo de Erlang B de forma recursiva.

    Args:
        canales: Número de servidores o canales disponibles, c.
        trafico_erlangs: Tráfico ofrecido A, en erlangs.

    Returns:
        Probabilidad de que una petición encuentre el sistema ocupado.
    """
    bloqueo = 1.0
    for canal in range(1, canales + 1):
        bloqueo = (trafico_erlangs * bloqueo) / (canal + trafico_erlangs * bloqueo)
    return bloqueo
```

### Probabilidad de bloqueo

La probabilidad de bloqueo $B(c, A)$ se conoce también como **grado de servicio**
(_grade of service_), y es el criterio de calidad que un dimensionado con pérdidas
persigue. Un grado de servicio del $1\,\%$ significa que, en promedio, una de cada cien
peticiones ofrecidas durante la hora cargada se rechaza por falta de recursos. El
dimensionado de un sistema con pérdidas consiste en fijar un grado de servicio objetivo,
por ejemplo $B \leq 2\,\%$, y encontrar el menor número de canales $c$ que lo satisface
para el tráfico ofrecido $A$ estimado en la hora cargada. Como $B(c, A)$ decrece de
forma monótona con $c$ para un $A$ fijo, ese número mínimo se obtiene evaluando la
fórmula para valores crecientes de $c$ hasta que la probabilidad de bloqueo cae por
debajo del objetivo.

???+ example "Dimensionado de un grupo de circuitos telefónicos"

    Una central telefónica local recibe, durante la hora cargada, un promedio de $1200$
    llamadas por hora, y la duración media de una llamada es de $90$ segundos. Se pide
    el tráfico ofrecido en erlangs y el número mínimo de circuitos que garantiza un
    grado de servicio no superior al $2\,\%$.

    La tasa media de llegadas es $\lambda = 1200/3600 = 0{,}333$ llamadas por segundo, y
    el tiempo medio de servicio es $1/\mu = 90$ s, de modo que el tráfico ofrecido es
    $A = \lambda \cdot (1/\mu) = 0{,}333 \times 90 = 30$ erlangs. Evaluando la fórmula
    recursiva de Erlang B para valores crecientes de $c$ se obtiene
    $B(38, 30) = 2{,}58\,\%$, todavía por encima del objetivo, y
    $B(39, 30) = 1{,}95\,\%$, que sí lo satisface. El grupo necesita, por tanto, $39$
    circuitos para no superar un bloqueo del $2\,\%$ con ese tráfico ofrecido.

???+ example "Efecto de un incremento de demanda sobre un grupo ya dimensionado"

    El grupo de $39$ circuitos del ejemplo anterior, dimensionado para un tráfico
    ofrecido de $30$ erlangs con un bloqueo del $1{,}95\,\%$, se enfrenta a un
    crecimiento de la demanda del $20\,\%$, que eleva el tráfico ofrecido a
    $36$ erlangs sin que se añada ningún circuito adicional. Se pide el nuevo grado de
    servicio.

    Evaluando $B(39, 36)$ con la misma fórmula recursiva se obtiene un bloqueo del
    $7{,}77\,\%$, casi cuatro veces superior al bloqueo original. Un incremento moderado
    de la demanda, del orden de una quinta parte, degrada el grado de servicio de forma
    mucho más que proporcional, porque la probabilidad de bloqueo crece con $A$ de forma
    marcadamente convexa en la región donde el sistema opera cerca de su capacidad. Esta
    sensibilidad es la razón por la que un dimensionado con pérdidas necesita revisarse
    de forma periódica a medida que la demanda evoluciona, y no basta con fijarlo una
    sola vez.

La siguiente tabla recoge, para varios tamaños de grupo $c$, el tráfico ofrecido máximo
que admite sin superar los grados de servicio habituales del $1\,\%$, el $2\,\%$ y el
$5\,\%$. Cada valor se ha obtenido evaluando la fórmula recursiva de Erlang B y buscando
el tráfico máximo compatible con el bloqueo objetivo.

| Canales $c$ | $A$ máximo para $B \leq 1\,\%$ | $A$ máximo para $B \leq 2\,\%$ | $A$ máximo para $B \leq 5\,\%$ |
| ----------- | ------------------------------ | ------------------------------ | ------------------------------ |
| $5$         | $1{,}36$                       | $1{,}66$                       | $2{,}22$                       |
| $10$        | $4{,}46$                       | $5{,}08$                       | $6{,}22$                       |
| $15$        | $8{,}11$                       | $9{,}01$                       | $10{,}63$                      |
| $20$        | $12{,}03$                      | $13{,}18$                      | $15{,}25$                      |
| $30$        | $20{,}34$                      | $21{,}93$                      | $24{,}80$                      |

La tabla ilustra el fenómeno conocido como **eficiencia de trunking**: la relación entre
el tráfico admisible y el número de canales mejora a medida que el grupo crece. Duplicar
$c$ de $15$ a $30$ manteniendo el bloqueo del $1\,\%$ no duplica el tráfico admisible de
$8{,}11$ a $16{,}22$, sino que lo eleva a $20{,}34$, un $151\,\%$ más de tráfico con
solo el doble de canales. Un grupo grande aprovecha mejor su capacidad porque las
fluctuaciones aleatorias de la demanda de canales distintos se compensan entre sí con
mayor eficacia cuantos más canales comparten el mismo grupo, lo que constituye el
argumento técnico a favor de concentrar tráfico en grupos grandes en lugar de repartirlo
en varios grupos pequeños con la misma capacidad total.

## Sistemas con espera

### Fórmula de Erlang C

Un sistema con espera se modela como `M/M/c`: llegadas de Poisson, tiempo de servicio
exponencial, $c$ servidores y una cola de capacidad infinita, sin límite en el número de
peticiones que pueden esperar turno. Frente al modelo con pérdidas, aquí ninguna
petición se rechaza: la que no encuentra servidor libre se almacena y espera, al precio
de un retardo adicional. La **fórmula de Erlang C** da la probabilidad de que una
petición que llega tenga que esperar porque los $c$ servidores están ocupados, $C(c,
A)$, y se expresa a partir de la propia fórmula de Erlang B:

$$
C(c, A) = \frac{c \cdot B(c, A)}{c - A \cdot \lbrack 1 - B(c, A) \rbrack}
$$

donde $A$ es el tráfico ofrecido en erlangs, $c$ es el número de servidores y $B(c, A)$
es la probabilidad de bloqueo de Erlang B evaluada con el mismo par $(c, A)$. Esta
relación exige que el factor de utilización $\rho = A/c$ sea estrictamente menor que
$1$, la misma condición de estabilidad que exigía el modelo `M/M/1` del capítulo
anterior: si $A \geq c$, la tasa de llegadas iguala o supera a la capacidad total de
servicio, la cola crece sin límite y ninguna de las magnitudes de este apartado alcanza
un régimen estacionario.

```python linenums="1"
def erlang_c(canales: int, trafico_erlangs: float) -> float:
    """Calcula la probabilidad de retardo de Erlang C a partir de Erlang B.

    Args:
        canales: Número de servidores disponibles, c.
        trafico_erlangs: Tráfico ofrecido A, en erlangs. Debe cumplir A < c.

    Returns:
        Probabilidad de que una petición encuentre ocupados todos los
        servidores y deba esperar en cola.

    Raises:
        ValueError: Si el tráfico ofrecido no es estrictamente menor que
            el número de canales, lo que viola la condición de estabilidad.
    """
    if trafico_erlangs >= canales:
        raise ValueError("El tráfico ofrecido debe ser menor que el número de canales.")
    bloqueo = 1.0
    for canal in range(1, canales + 1):
        bloqueo = (trafico_erlangs * bloqueo) / (canal + trafico_erlangs * bloqueo)
    return (canales * bloqueo) / (canales - trafico_erlangs * (1 - bloqueo))
```

### Probabilidad de retardo y tiempo de encolado

$C(c, A)$ es la probabilidad de que una petición tenga que esperar, no la probabilidad
de que espere un tiempo concreto. El tiempo medio de espera en cola, $W$, se obtiene
combinando $C(c, A)$ con la tasa media de servicio $\mu$ y el propio tráfico ofrecido:

$$
W = \frac{C(c, A)}{c\mu - \lambda}
$$

donde $\lambda = A\mu$ es la tasa media de llegadas, $\mu$ es la tasa media de servicio
de un único servidor y $c\mu - \lambda$ es la capacidad de servicio total que queda
libre, en promedio, para absorber la cola. Esta expresión es coherente con la fórmula de
Little del capítulo anterior: quien ya espera en cola sigue esperando en promedio el
mismo tiempo $1/(c\mu - \lambda)$ que absorbía una cola `M/M/1` con capacidad agregada
$c\mu$, y $C(c, A)$ pondera esa espera por la fracción de peticiones que efectivamente
la sufren, en lugar de aplicarla a todas.

???+ example "Retardo de un centro de atención telefónica dimensionado con Erlang C"

    Un centro de atención recibe llamadas con un tráfico ofrecido $A = 3$ erlangs y
    dispone de $c = 6$ operadores, cada uno con un tiempo medio de atención de
    $1/\mu = 4$ minutos. Se pide la probabilidad de que una llamada tenga que esperar y
    el tiempo medio de espera de las llamadas que sí esperan.

    El factor de utilización es $\rho = A/c = 3/6 = 0{,}5$, por debajo de la unidad, lo
    que garantiza un régimen estacionario. La probabilidad de bloqueo de Erlang B es
    $B(6, 3) = 5{,}22\,\%$, y sustituyendo en la fórmula de Erlang C se obtiene
    $C(6, 3) = 6 \times 0{,}0522 / \lbrack 6 - 3 \times (1 - 0{,}0522) \rbrack =
    9{,}91\,\%$. Con $\mu = 1/4$ llamadas por minuto, el tiempo medio de espera es
    $W = 0{,}0991 / (6 \times 0{,}25 - 0{,}75) = 0{,}132$ minutos, unos $7{,}9$
    segundos. El resultado de Erlang C es mayor que el de Erlang B porque, a diferencia
    de un sistema con pérdidas, aquí ninguna llamada se rechaza: toda la que encuentra
    los seis operadores ocupados espera en cola, y esa espera eleva la fracción de
    llamadas afectadas por encima de la fracción que Erlang B habría bloqueado.

## Sistemas con capacidad finita

### Hipótesis del modelo M/M/1/K

El modelo `M/M/1/K`, ya anunciado en la notación de Kendall del
[capítulo anterior](section_1_teoria_de_colas.md#notacion-de-kendall), combina rasgos de
los dos sistemas anteriores en un único servidor: llegadas de Poisson de tasa $\lambda$,
servicio exponencial de tasa $\mu$ y una capacidad total del sistema, cola más servidor,
limitada a $K$ peticiones. Una petición que llega cuando el sistema ya alberga $K$
peticiones se rechaza, igual que en un sistema con pérdidas, pero una petición que llega
con el servidor ocupado y con margen libre en la cola espera turno, igual que en un
sistema con espera. El modelo describe con fidelidad un búfer de tamaño fijo, como la
memoria de una interfaz de red o un almacén de mensajes de señalización con capacidad
acotada, donde el propio hardware impone el límite $K$ con independencia de la demanda.

### Probabilidad de estado y de bloqueo

La distribución estacionaria del número de peticiones en el sistema, $P_n$ para $n = 0,
\dots, K$, se obtiene de la misma cadena de nacimiento y muerte que el modelo `M/M/1`,
truncada en el estado $K$:

$$
P_n = \frac{1-\rho}{1-\rho^{K+1}}\,\rho^{n}
$$

donde $\rho = \lambda/\mu$ es la intensidad de tráfico y $K$ es la capacidad total del
sistema. A diferencia del modelo `M/M/1`, esta expresión está definida para cualquier
$\rho \neq 1$, incluido $\rho > 1$: la cola finita impide que el número de peticiones
crezca sin límite, de modo que el sistema alcanza siempre un régimen estacionario,
incluso con una intensidad de tráfico que en un sistema con cola infinita llevaría a una
saturación permanente. La **probabilidad de bloqueo**, la fracción de peticiones que se
rechaza por encontrar el sistema lleno, es directamente la probabilidad del último
estado,

$$
P_K = \frac{1-\rho}{1-\rho^{K+1}}\,\rho^{K}
$$

y la tasa de llegadas efectivamente cursada por el sistema es $\lambda_{\text{ef}} =
\lambda\,(1-P_K)$, siempre inferior a $\lambda$ salvo que $P_K = 0$.

???+ example "Búfer de interfaz con capacidad de cinco paquetes"

    Una interfaz de red recibe paquetes según un proceso de Poisson de tasa
    $\lambda = 8$ paquetes por segundo y los transmite con tiempo de servicio
    exponencial de tasa $\mu = 10$ paquetes por segundo, sobre un búfer que solo
    admite $K = 5$ paquetes en total, cola más el que está en transmisión. Se
    pide la probabilidad de que un paquete se descarte por búfer lleno y el
    retardo medio de los paquetes que sí se admiten.

    La intensidad de tráfico es $\rho = 8/10 = 0{,}8$, y la probabilidad de
    bloqueo es $P_5 = \lbrack (1-0{,}8)/(1-0{,}8^{6}) \rbrack \cdot 0{,}8^{5} =
    8{,}88\,\%$. La tasa efectivamente cursada es
    $\lambda_{\text{ef}} = 8 \times (1-0{,}0888) = 7{,}29$ paquetes por segundo.
    El número medio de paquetes en el sistema es $N = 1{,}87$, obtenido sumando
    $n \cdot P_n$ sobre los seis estados posibles, y el retardo medio de un
    paquete admitido es $T = N/\lambda_{\text{ef}} = 1{,}87/7{,}29 = 256$ ms, del
    que $156$ ms corresponden a espera en cola y el resto a transmisión. Frente
    al modelo `M/M/1` sin límite de búfer, que con la misma $\rho = 0{,}8$ no
    descarta ningún paquete pero alcanza un retardo medio mayor, este sistema
    sacrifica una fracción de los paquetes para acotar el retardo del resto.

La misma fórmula sigue siendo válida cuando $\rho > 1$, por ejemplo con $\lambda = 12$
paquetes por segundo sobre el mismo $\mu = 10$ y $K = 5$: el sistema alcanza igualmente
un régimen estacionario, con una probabilidad de bloqueo de $P_5 = 25{,}06\,\%$ y una
tasa cursada de $\lambda_{\text{ef}} = 8{,}99$ paquetes por segundo, por debajo de la
capacidad de servicio $\mu$ como exige la estabilidad. Un sistema `M/M/1` con esa misma
intensidad de tráfico no alcanzaría nunca un régimen estacionario: es la capacidad
finita del búfer, no ninguna propiedad del tráfico, la que hace posible este resultado.

## Aplicación al dimensionado

### Dimensionado de canales de tráfico

Los canales de tráfico de un sistema de conmutación de circuitos, como el canal de voz
`TCH` de una red celular, se modelan como un sistema con pérdidas: una llamada que no
encuentra canal libre se rechaza directamente en lugar de esperar en una cola, porque un
usuario que intenta iniciar una llamada no tolera un retardo de establecimiento
indefinido. El dimensionado de estos canales aplica, por tanto, la fórmula de Erlang B:
a partir del tráfico ofrecido en la hora cargada y de un grado de servicio objetivo, se
obtiene el número mínimo de canales necesarios siguiendo el procedimiento del apartado
anterior.

### Dimensionado de canales de señalización

Los canales de señalización dedicados que gestionan el establecimiento de una llamada,
como el canal `SDCCH` de una red GSM, se comportan de forma distinta: una petición de
señalización que no encuentra recurso libre no se descarta sin más, sino que se almacena
y espera a que un canal quede disponible, porque el propio protocolo de señalización
contempla ese retardo como parte normal de su funcionamiento. El dimensionado de estos
canales aplica, en consecuencia, la fórmula de Erlang C, y el criterio de calidad no es
ya un grado de servicio máximo, sino un tiempo medio de espera máximo tolerable antes de
que el protocolo de señalización lo interprete como un fallo.

### Dimensionado del canal de aviso de llamada

El canal de aviso de llamada (_paging_) notifica una llamada entrante a un terminal en
todas las celdas de su área de localización, y su capacidad se dimensiona igual que un
canal de señalización: como un sistema con pérdidas si un aviso no atendido se descarta,
o como un sistema con espera si se retransmite tras un margen de tiempo. En cualquiera
de los dos casos, el tráfico ofrecido al canal de aviso es el producto de la tasa media
de avisos generados por unidad de tiempo y la duración media de un mensaje de aviso, y
el dimensionado sigue exactamente el mismo procedimiento que el de un canal de tráfico o
de señalización, aplicando la fórmula que corresponda al comportamiento del sistema
concreto ante la saturación.

???+ example "Dimensionado del canal de aviso de llamada de una celda"

    Una celda genera avisos de llamada a una tasa media de $5$ avisos por segundo
    durante la hora cargada, y cada mensaje de aviso ocupa el canal durante
    $1{,}25$ segundos. El canal de aviso se comporta como un sistema con pérdidas: un
    aviso que no encuentra bloque de control disponible se descarta. Se pide el número
    mínimo de bloques de control que garantiza un grado de servicio no superior al
    $3\,\%$.

    El tráfico ofrecido es $A = 5 \times 1{,}25 = 6{,}25$ erlangs. Evaluando la fórmula
    recursiva de Erlang B para valores crecientes de $c$ se obtiene
    $B(11, 6{,}25) = 2{,}82\,\%$, que ya satisface el objetivo, frente a
    $B(10, 6{,}25) = 5{,}11\,\%$, que lo incumple. El canal necesita, por tanto, $11$
    bloques de control para no superar un bloqueo del $3\,\%$ con ese tráfico ofrecido.

## Limitaciones de los modelos analíticos

### Reintentos

Las fórmulas de Erlang B y Erlang C asumen que una petición rechazada, o una petición
que espera, se comporta de forma pasiva: el usuario que sufre un bloqueo no vuelve a
intentarlo de inmediato, o su reintento se ignora a efectos del modelo. En la práctica,
un usuario al que se le rechaza una llamada suele reintentarla en un intervalo corto de
tiempo, lo que añade tráfico ofrecido adicional al propio sistema que acaba de
rechazarla. Ese tráfico de reintento no está contemplado en la formulación clásica y
tiende a agravar la congestión en los instantes de mayor carga, precisamente cuando el
sistema ya opera cerca de su capacidad.

### Tráfico no estacionario

Tanto Erlang B como Erlang C exigen que el tráfico ofrecido $A$ sea constante durante el
periodo de análisis, la hipótesis de régimen estacionario que sostiene todo el
desarrollo de este capítulo. La demanda real de un sistema de telecomunicaciones varía
de forma continua a lo largo del día, y la hora cargada es una aproximación que
sustituye esa variación por un único valor representativo. Un tráfico con variaciones
abruptas dentro de la propia hora cargada, o con una distribución de llegadas que se
aleja de forma apreciable de un proceso de Poisson, hace que las fórmulas de Erlang
sobrestimen o subestimen la capacidad realmente necesaria.

### Alternativa por simulación

Cuando las hipótesis de las fórmulas analíticas no se sostienen con suficiente
fidelidad, la alternativa habitual es sustituirlas por un modelo de simulación de colas
que reproduce el comportamiento del sistema sin depender de una forma cerrada. Un modelo
de simulación admite incorporar reintentos, patrones de llegada no markovianos y tráfico
no estacionario, al precio de un coste computacional mayor y de una estimación sujeta a
la incertidumbre estadística propia de cualquier resultado obtenido por simulación en
lugar de por cálculo exacto. La elección entre el modelo analítico y la simulación es,
en la práctica, un compromiso entre la sencillez de las fórmulas de Erlang y la
fidelidad que exige el sistema concreto que se dimensiona.

La aplicación de estas fórmulas al dimensionado de canales de una celda real, con sus
propios márgenes y particularidades, se trata por separado.
