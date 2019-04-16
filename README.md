# Offside Real Time System

Offside Real Time System és un sistema basat en C++ y MATLAB el qual, en un entorn concret, permet detectar situacions de fora de joc en temps real. La compilació del sistema s'explica en un apartat més endevant.

El repositori està dividit en 4 carpetes:

<hr>
<h2>Requisits del Sistema</h2>
<ul>
<li>Tots els nodes han de treballar sota una distribució de Linux. \
<li>El Sistema de Càmera i el Sistema de Pilota han de compilar-se i executar-se en plaques Raspberry Pi.
<li>El Node Principal ha de tenir instalat MATLAB.
</ul>
<hr>

<h2>Directoris</h2>
<h4> /src </h4>
És on hi ha tot el codi font del sistema. 
<h4> /test </h4>
És on hi ha els samples que hem estat utilitzant per a testejar el software. Bàicament hi ha els samples dels algorismes de visió per computadors degut a que el testeig dels demés sitemes o be ha estat a mode de prova-error o be hi ha un driver de test a la carpeta /src.
<h4> /Tools </h4>
És on hi ha tots els scripts necessaris per a configurar el sistema. Bàsicament hi ha l'escriptura de les variables d'entorn necessàries per a poder compilar i executar.
<h4> /build </h4>
És on hi ha les carpetes per a compilar cadascun dels sistemes. Hi han els Makefiles i els scripts de compilació. 

<hr>
<h2>Build</h2>
Per a compilar el sistema anem a la carpeta de build que volem compilar (pe: /build/BallDetection) i executar:

<ul>
<li>build.sh
</ul>

També es poden còrrer les comandes Makefile (veure dins del build.sh):

<ul>
<li>make clean
<li>make setup
<li>make Camera (En el Sistema Càmera, per exemple).
</ul>
