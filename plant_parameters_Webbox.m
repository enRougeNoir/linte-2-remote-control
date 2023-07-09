clear all; clc;
m = modbus('tcpip', '172.22.2.91');

idUrzadz =2;

registers=["Numer"  "Opis"  "Jednostka"  "Words"  "Format";
    30775 "AC active power all phases" " W" 2 1;
    30537 "Daily yield" " kWh" 2 1;
    30533 "Total yield" " MWh" 2 1] ;

for i=2:length(registers)
    rr=read(m,'holdingregs',str2num(registers(i,1)),3,idUrzadz);

    %odczytana wartosc rr po przesunieciu przecinka
    rr2(i)=numConcat(rr,str2num(registers(i,5)));
    %wynik w formie tabeli: opis; wartość rr2; jednostka
    fprintf('%s = %.2f%s\n',registers(i,2),rr2(i),registers(i,3))
end
    

%ustawienie przecinka tak aby wielkość była dana w odpowiedniej jednostce
function num2=numConcat(rr3,duration)
    num2=(rr3(2)*65535+rr3(3)) * duration;
end