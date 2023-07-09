clear all; clc;
m = modbus('tcpip', '172.22.2.91');

% idUrzadz = 7; %FALOWNIK 8 kW ||| ID = 7
idUrzadz = 7;  %FALOWNIK 20 kW ||| ID = 5
%próba połączenia z falownikiem
testPol(idUrzadz);

registers=["Numer"  "Opis"  "Jednostka"  "Words"  "Format";
    30769  "Prąd wejściowy DC" "[A]"  2  0.001;
    30771  "Napięcie wejściowe DC"  "[V]"  2  0.01;
    30773  "Moc wejściowa DC"  "[W]"  2  1;
    31793  "String current  string 1"  "[A]"  2  0.001;
%   30533  "Energia wyprodukowana całkowita"  "[MWh]"  2  1 ;
    30531  "Energia wyprodukowana całkowita"  "[kWh]"  2  1 ; 
    30797  "Prąd na fazie L1"  "[A]"  2  0.001;
    30799  "Prąd na fazie L2"  "[A]"  2  0.001;
    30801  "Prąd na fazie L3"  "[A]"  2  0.001;
    30803  "Częstotliwość sieci"  "[Hz]"  2  0.01;
    30783  "Napięcie fazowe L1"  "(V)"  2  0.01;
    30785  "Napięcie fazowe L2"  "(V)"  2  0.01;
    30787  "Napięcie fazowe L3"  "(V)"  2  0.01;
    30813  "Moc pozorna"  "(VA)"  2  1;
    30805  "Moc bierna"  "(var)"  2  0.01;
    30815  "Moc pozorna L1"  "(VA)"  2  1;
    30817  "Moc pozorna L2"  "(VA)"  2  1;
    30819  "Moc pozorna L3"  "(VA)"  2  1;
    30807  "Moc bierna L1"  "(VAr)"  2  1;
    30809  "Moc bierna L2"  "(VAr)"  2  1;
    30811  "Moc bierna L3"  "(VAr)"  2  1;
    30777  "Moc czynna L1"  "(W)"  2  1;
    30779  "Moc czynna L2"  "(W)"  2  1;
    30781  "Moc czynna L3"  "(W)"  2  1;
    30219  "Derating"  ""  2  1;
    30561  "Liczba wydarzeń dla instalatora"  ""  2  1;
    30559  "Liczba wydarzeń dla użytkownika"  ""  2  1;
    30197  "Current event number"  ""  2  1;
    30217  "Grid relay/contactor"  ""  2  1;
    30201  "Stan pracy"  ""  2  1;
    30211  "Zalecane działanie"  ""  2  1;
    30199  "Czas oczekiwania na zasilanie"  "(s)"  2  1;
    30775  "Moc czynna AC na wszystkich fazach"  "(W)"  2  1;
    30231  "Maksymalna moc czynna na urządzenie"  "W"  2  1;
    40212  "Ograniczenie mocy czynnej P"  "W"  2  1] ;


while true
for i=2:length(registers)
    rr=read(m,'holdingregs',str2num(registers(i,1)),3,idUrzadz);

    %odczytana wartosc rr po przesunieciu przecinka
    rr2(i)=numConcat(rr,str2num(registers(i,5)));
    %wynik w formie tabeli: opis; wartość rr2; jednostka
    fprintf('%s = %.2f%s\n',registers(i,2),rr2(i),registers(i,3))
end
    pause(120)
    
end

%ustawienie przecinka tak aby wielkość była dana w odpowiedniej jednostce
function num2=numConcat(rr3,duration)
     num2=(rr3(2)*65535+rr3(3)) * duration;

end