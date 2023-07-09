%odczytywanie rejestrów ze stacji meteorologicznej
clear all; clc;
m = modbus('tcpip', '172.22.2.91');

registers=["Numer"  "Opis"  "Jednostka"  "Words"  "Format";
    34617 "Wilgotność względna" "(%)" 2 0.01
    34619 "Ciśnienie" "(hPa)" 2 0.01
    34613 "Nasłoneczenie padające na sensor" "(W/m^2)" 2 1
    34609 "Temperatura otoczenia" "(C)" 2 0.1
    34621 "Temperatura modułu PV" "(C)" 2 0.1
    ];

for i=2:length(registers)
    rr=read(m,'holdingregs',str2num(registers(i,1)),3,3);
    rr2(i)=numConcat(rr,str2num(registers(i,5)));
    fprintf('%s = %.2f%s\n',registers(i,2),rr2(i),registers(i,3))
end

%ustawienie przecinka tak aby wielkość była dana w odpowiedniej jednostce
function num2=numConcat(rr3,duration)
        num2=(rr3(2)*65535+rr3(3))*duration;

end
