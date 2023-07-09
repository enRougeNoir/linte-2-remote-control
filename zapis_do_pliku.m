%skrypt który prowokuje zapis do pliku wybranych parametrow
clear all; clc;

dateOnl = string(datetime('now','Format','dd-MMM-uuuu'));
timeOnl = string(datetime('now','Format','HH:mm:ss'));

timeDelay = 30;
fileName = date + ".csv";

registers =["Numer rejestru" "Opis" "Jednostka" "Words" "Format" "ID urządzenia" 

  34613 "Nasłonecznienie" "[W/m^2]" 2 1 3

  30773 "DC mocCzyn wej:fal5" "[W]" 2 1 5
  30773 "DC mocCzyn wej:fal7" "[W]" 2 1 7

  30775 "AC mocCzyn wyj:fal5" "[W]" 2 1 5
  30775 "AC mocCzyn wyj:fal7" "[W]" 2 1 7

  30813 "Moc pozorna:fal5" "[VA]" 2 1 5
  30813 "Moc pozorna:fal7" "[VA]" 2 1 7
  ];

%sprawdzenie czy plik zapisowy istnieje
if isfile(fileName)
    disp("Plik tesktowy .csv już istnieje i zostanie zedytowany")
else
    disp("Plik tekstowy .csv nie istnieje i został właśnie utworzony")
end
tablica = ["Data" "Czas" registers(2:length(registers),2)';...
    "Y:m:d" "H:M:S" registers(2:length(registers),3)'];

daneWiersz = [dateOnl timeOnl];

%%%%%%% ODCZYTYWANIE PARAMETRÓW PRZEZ MODBUS %%%%%%%%%%%
m = modbus('tcpip', '172.22.2.91');
%próba połączenia z falownikiem
testPol(5); testPol(7);

i=1; seriaPom = 1;
while i <= length(registers)
i=i+1;

    idUrzadz = str2num(registers(i,6));
    numerRej = str2num(registers(i,1));
    rr=read(m,'holdingregs',numerRej,3,idUrzadz);

    %odczytana wartosc rr po przesunieciu przecinka
    przesPrzec = str2num(registers(i,5));
    rr2(i)=numConcat(rr,przesPrzec);

%zapis do wiersza roboczego
daneWiersz(seriaPom,i+1) = rr2(i);

%sprawdzenie czy mamy już zapisane wszystkie rejestry: jeśli tak to przerwa
%na 30 sekund i powrót; jeśli nie to ciąg dalszy
if i == length(registers)
fprintf('Odczytano dane z urządzenia o ID: %.0f\n',idUrzadz);

%połączenie tablicy pierwotnej z danymi z i-tej iteracji
tablica = vertcat(tablica,daneWiersz(seriaPom,:))

if isfile(fileName)
    writematrix(tablica(seriaPom+2,:),fileName,'WriteMode','append')
else
    writematrix(tablica,fileName)
end

%przerwa w po odczytaniu serii a nastepnie powrot do pomiarow
pause(timeDelay)
i=1; seriaPom = seriaPom+1;

dateOnl = string(datetime('now','Format','dd-MMM-uuuu'));
timeOnl = string(datetime('now','Format','HH:mm:ss'));

daneWiersz(seriaPom,1:2) = [dateOnl timeOnl];
else
    fprintf('Odczytano dane z urządzenia o ID: %.0f\n',idUrzadz);
end
end


%ustawienie przecinka tak aby wielkość była dana w odpowiedniej jednostce
function num2=numConcat(rr3,duration)
    num2=rr3(2)*1e4+rr3(3)*duration;
end




 

