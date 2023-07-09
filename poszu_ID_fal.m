clear all; clc;
m = modbus('tcpip', '172.22.2.91');

%test pracy
%Condition
%35 = fault
%307 = ok
%455 = warning
numerRej = 30201;

%DANE EDYTOWALNE
poczID = 4;
maksID = 21;
interwal = 60;
%KONIEC DANYCH EDYTOWALNYCH

fprintf('\n CZAS ODCZYTU: %s\n\n',datetime('now','Format','HH:mm:ss'));
idUrzadz = poczID;
while idUrzadz <= maksID
    try
    rr=read(m,'holdingregs',numerRej,3,idUrzadz)
    fprintf('Odczytano dane z urządzenia o ID: %.0f\n',idUrzadz);
    catch
    fprintf('Błąd połączenia z urządzeniem o ID: %.0f\n',idUrzadz);
    end

    if idUrzadz == maksID
        pause(interwal)
        idUrzadz=poczID;
        fprintf('\n CZAS ODCZYTU: %s\n\n',datetime('now','Format','HH:mm:ss'));
    else
        idUrzadz=idUrzadz+1;
    end
end