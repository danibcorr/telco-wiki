---
authors: Daniel Bazo Correa
description:
    Red telefónica conmutada, tecnologías de abonado digital y estructura jerárquica de
    Internet.
title: Redes de acceso fijo
---

Una red de acceso fijo conecta el equipo de un abonado con la red del proveedor a través
de un medio físico permanente, típicamente el par de cobre tendido hasta el domicilio
del usuario. Este capítulo describe tres capas de esa conexión: la red telefónica
conmutada, que fue la primera infraestructura de acceso fijo y sigue proporcionando el
par de cobre que otras tecnologías reutilizan; las tecnologías de línea de abonado
digital, que transmiten datos sobre ese mismo par de cobre a velocidades muy superiores
a las de la voz; y la estructura jerárquica de proveedores que conecta al abonado con el
resto de Internet una vez que el enlace de acceso está establecido.

## Introducción

El acceso fijo se caracteriza por reutilizar, en la medida de lo posible, la
infraestructura de cableado ya desplegada para el servicio telefónico. El par de cobre
que conecta a un abonado con su central telefónica local nació para transportar voz
analógica, pero admite frecuencias muy por encima de la banda de voz, lo que ha
permitido superponer sobre él tecnologías de transmisión de datos sin necesidad de
tender un cableado nuevo. Entender el acceso fijo exige, por tanto, conocer primero la
estructura de la propia red telefónica conmutada, que sigue determinando la topología
física sobre la que operan las tecnologías de datos más recientes.

## Red telefónica conmutada

La **red telefónica conmutada**, también llamada red telefónica básica, es la
infraestructura de conmutación de circuitos que proporciona el servicio de voz fijo.
Está compuesta por tres elementos: el bucle de abonado que llega hasta cada domicilio,
las centrales de conmutación que dan conectividad a los usuarios y los enlaces
interurbanos que transportan tráfico entre esas centrales.

### Bucle de abonado

El **bucle de abonado** es el par de hilos de cobre que une el terminal de un usuario
con la central de conmutación local a la que está conectado. Es el segmento de acceso
más antiguo de toda la red telefónica y el más numeroso, porque existe un bucle
independiente por cada línea de abonado. Diseñado originalmente para transportar voz
analógica en una banda estrecha, el bucle de abonado admite frecuencias muy superiores a
las de la voz, una propiedad que las tecnologías de línea de abonado digital explotan
más adelante en este capítulo.

### Centrales de conmutación y enlaces

Las **centrales de conmutación** dan conectividad a los usuarios y actúan como los
equipos intermedios entre los terminales finales de la llamada, encaminando cada
comunicación hacia el bucle de abonado del destinatario o hacia el enlace que lleva
hacia otra central. Los **enlaces** transportan el tráfico entre centrales y están
formados por mazos de cable o por fibra óptica, a diferencia del bucle de abonado
individual que llega a cada domicilio. El tráfico que circula por estos enlaces
interurbanos suele multiplexarse siguiendo las jerarquías digitales descritas en
[multiplexación](../../01_fundamentos/04_acceso_al_medio/section_1_multiplexacion.md),
de modo que un mismo enlace físico transporta de forma simultánea las conversaciones de
un número elevado de abonados.

### Áreas de transporte y puntos de presencia

Una **área de transporte de acceso local**, o LATA, es un área geográfica pequeña o
metropolitana compuesta por centrales locales y centrales de tránsito. Algunas llamadas
se pueden establecer sin salir del área de transporte, porque el origen y el destino
comparten la misma LATA. La interconexión entre usuarios de LATA distintas la realizan
los **nodos de interconexión**, o IXC, que actúan como pasarela entre LATA gracias a los
**puntos de presencia**, o POP, que hacen de frontera de acceso de cada LATA hacia los
IXC.

```mermaid linenums="1"
flowchart LR
    Abonado[Terminal de abonado] --> Bucle[Bucle de abonado]
    Bucle --> Local[Central local]
    Local --> Transito[Central de transito]
    Transito --> Ixc[Nodo de interconexion IXC]
    Ixc --> Pop[Punto de presencia POP]
    Pop --> OtraLata[Central de otra LATA]
```

### Plan de numeración telefónica

El plan nacional de numeración telefónica fija números de nueve cifras. El primer dígito
distingue el tipo de servicio: los números que comienzan por 6 se asignan a servicios
móviles, mientras que los que comienzan por 8 o por 9 son indicativos provinciales, es
decir, identifican geográficamente al abonado. La Comisión del Mercado de las
Telecomunicaciones aplica este plan y asigna los rangos de números a los distintos
operadores. Este plan nacional es una instancia particular del marco internacional E.164
descrito en
[direccionamiento](../01_arquitectura/section_1_capas_y_encapsulado.md#direccionamiento),
que fija el límite de quince cifras dentro del cual conviven el indicativo de país, el
indicativo nacional de destino y el número de abonado de cualquier país.

???+ example "Capacidad del segmento de numeración móvil"

    El plan nacional fija números de nueve cifras y asigna a los servicios móviles
    todos los números que comienzan por el dígito 6. Se pide cuántas combinaciones de
    número de abonado quedan disponibles dentro de ese segmento, antes de que la
    Comisión del Mercado de las Telecomunicaciones reparta esos números entre
    operadores concretos.

    Fijado el primer dígito en 6, quedan ocho dígitos libres para completar el número
    de nueve cifras. El número de combinaciones posibles de esos ocho dígitos es
    $10^{8} = 100\,000\,000$. El segmento de numeración móvil admite, por tanto, cien
    millones de números de abonado distintos antes de ningún reparto entre operadores.

## Tecnologías de línea de abonado digital

Las **tecnologías de línea de abonado digital**, agrupadas bajo la sigla DSL, transmiten
datos a través del mismo bucle de abonado de cobre que la red telefónica conmutada,
utilizando un ancho de banda situado por encima de los 4 kHz que ocupa la voz. Un filtro
paso bajo instalado en el domicilio del abonado separa el tráfico de voz, que sigue
viajando en banda base hacia la central local, del tráfico de datos, que se modula en la
banda superior del mismo par de cobre.

### Familia DSL

Dentro de la familia DSL conviven varias tecnologías que reparten de forma distinta la
velocidad entre el sentido ascendente y el sentido descendente. La línea de abonado
digital asimétrica, o ADSL, ofrece más velocidad en sentido descendente que en sentido
ascendente y está pensada para usuarios particulares residenciales, cuyo tráfico es
predominantemente de descarga. La línea de abonado digital simétrica, o SDSL, y la línea
de abonado digital de alta velocidad, o HDSL, ofrecen la misma velocidad en ambos
sentidos. La línea de abonado digital de muy alta velocidad, o VDSL, alcanza las
velocidades más altas de toda la familia a costa de reducir de forma notable la
distancia máxima de alcance. Todas estas tecnologías modulan los datos en la banda
superior del bucle de abonado mediante las técnicas de modulación digital descritas en
[modulaciones digitales](../../01_fundamentos/03_modulacion/section_2_modulaciones_digitales.md),
adaptadas a las condiciones de atenuación y de ruido que presenta cada línea concreta.

### ADSL: canalización del ancho de banda

ADSL acomoda un ancho de banda de hasta 1,1 MHz sobre el bucle de abonado, y la
velocidad efectiva es adaptativa porque depende del ancho de banda disponible en cada
línea concreta. Ese ancho de banda se divide en 256 canales espaciados 4,3125 kHz entre
sí. El canal 0 transporta la voz, los canales 1 a 5 actúan como banda de guarda y no se
utilizan para datos, los canales 6 a 30 transportan el enlace ascendente y los canales
31 a 255 transportan el enlace descendente.

???+ example "Ancho de banda total del plan de canales de ADSL"

    El plan de canales de ADSL reparte el ancho de banda en 256 canales espaciados
    4,3125 kHz entre sí. Se pide comprobar que ese reparto es coherente con el ancho de
    banda total de 1,1 MHz citado para la tecnología, y cuántos canales quedan
    disponibles para cada sentido de transmisión.

    Multiplicando el número de canales por su espaciado se obtiene el ancho de banda
    total: $256 \times 4{,}3125\text{ kHz} = 1104\text{ kHz} \approx 1{,}1\text{ MHz}$,
    que coincide con el ancho de banda citado para la tecnología. Dentro de ese
    reparto, el enlace ascendente ocupa los canales 6 a 30, es decir,
    $30 - 6 + 1 = 25$ canales, y el enlace descendente ocupa los canales 31 a 255, es
    decir, $255 - 31 + 1 = 225$ canales. Sumando esos 25 y 225 canales al canal de voz
    y a los cinco canales de guarda se recupera el total de 256 canales del plan
    completo, lo que confirma que el reparto es consistente.

### Velocidad y distancia máxima

La velocidad alcanzable y la distancia máxima del bucle de abonado están enfrentadas en
toda la familia DSL: cuanto mayor es la velocidad que ofrece una tecnología, menor es la
distancia hasta la que puede desplegarse, porque la atenuación del par de cobre crece
con la frecuencia y con la longitud del bucle.

| Tecnología | Velocidad descendente | Velocidad ascendente | Distancia máxima |
| ---------- | --------------------- | -------------------- | ---------------- |
| ADSL       | 1,5 a 6,1 Mbit/s      | 16 a 640 kbit/s      | 4 km             |
| SDSL       | 768 kbit/s            | 768 kbit/s           | 4 km             |
| HDSL       | 1,5 a 2 Mbit/s        | 1,5 a 2 Mbit/s       | 4 km             |
| VDSL       | 25 a 55 Mbit/s        | 3,2 Mbit/s           | 1 a 3 km         |

La simetría de SDSL y de HDSL entre sentido ascendente y descendente es coherente con su
propio nombre, mientras que ADSL y VDSL muestran la asimetría característica de sus
respectivos diseños. VDSL alcanza el régimen binario más alto de toda la familia
precisamente porque renuncia a la mayor parte del alcance: su distancia máxima de uno a
tres kilómetros es muy inferior a los cuatro kilómetros que soportan las demás
tecnologías de la tabla.

## Estructura de Internet

Una vez que el bucle de abonado entrega los datos a la central local, la comunicación
continúa a través de una jerarquía de equipos y de proveedores que conecta al abonado
con el resto de Internet.

### Equipos finales y encaminadores

El **host** es el elemento final que se conecta a la red, ya sea un ordenador personal,
un equipo móvil o un servidor, y se conecta a la red de acceso local o de área extensa a
través de un encaminador. El **encaminador**, o router, interconecta redes de área local
y de área extensa entre sí y encamina los paquetes entre ellas.

### Del abonado al proveedor de acceso

El **proveedor de servicio de Internet**, o ISP, es la empresa que proporciona acceso a
Internet a sus clientes: dispone de un grupo de servidores con conexiones de alta
velocidad a las redes de otros ISP, asigna direcciones IP a los clientes individuales y
necesita los equipos y los enlaces de telecomunicación necesarios para operar. El
**punto de presencia**, o POP, es la frontera del ISP: el ISP distribuye varios puntos
de presencia para facilitar el acceso de sus clientes, que se conectan a través del
punto de presencia más cercano.

```mermaid linenums="1"
flowchart LR
    Host[Equipo terminal] --> Isp[Proveedor de acceso ISP]
    Isp --> PopIsp[Punto de presencia del ISP]
    PopIsp --> Resto[Resto de la jerarquia de Internet]
```

El ISP que atiende a un abonado del acceso fijo es, en la jerarquía de proveedores que
sostiene el resto de Internet más allá de ese punto de presencia, un operador de nivel 3
o de nivel 2 según su alcance. Esa jerarquía completa, con sus tres niveles, los
acuerdos de tránsito y de _peering_ entre operadores y los puntos neutros de intercambio
que los interconectan, es el objeto propio de
[interconexión de redes y de operadores](../04_encaminamiento/section_3_interconexion_de_redes.md),
que no repite este capítulo.

## Protocolos del acceso

El enlace entre el equipo del abonado y el equipo del proveedor al otro lado del bucle
de abonado necesita su propio protocolo de nivel de enlace, distinto de los protocolos
de nivel de enlace de una red local, porque conecta exactamente dos sistemas a través de
un único medio dedicado.

### Enlace punto a punto

El **protocolo punto a punto**, o PPP, es el protocolo de nivel de enlace habitual en
los accesos de este tipo. Soporta múltiples protocolos de nivel de red sobre el mismo
enlace físico, trabaja con direcciones IP asignadas de forma dinámica y ofrece detección
de errores mediante un código de redundancia cíclico en cada trama.

### Establecimiento y configuración del enlace

El **protocolo de control de enlace**, o LCP, es el responsable de establecer, probar y
negociar las capacidades del enlace punto a punto antes de que pueda circular por él
ningún tráfico de nivel de red. Una vez que el LCP deja el enlace establecido, cada
protocolo de nivel de red que va a utilizarlo necesita su propio **protocolo de control
de red**, o NCP, que configura ese protocolo concreto sobre el enlace ya activo. Esta
separación entre un único LCP que gestiona el enlace en sí y un NCP por cada protocolo
de nivel de red permite que un mismo enlace punto a punto transporte simultáneamente
varios protocolos de red distintos, cada uno configurado por su propio NCP.
