clear all; clc;
m = modbus('tcpip', '172.22.2.91');

registers=["LP" "Numer rej"  "Opis"  "Jednostka"  "Words"  "Format";
    2 30769  "Prąd wejściowy DC" "[A]"  2  0.001;
    3 30771  "Napięcie wejściowe DC"  "[V]"  2  0.01;
    4 30773  "Moc wejściowa DC"  "[W]"  2  1;
    5 31793  "String current  string 1"  "[A]"  2  0.001;
    6 30531  "Energia wyprodukowana całkowita"  "[kWh]"  2  1 ;
    7 30797  "Prąd na fazie L1"  "[A]"  2  0.001;
    8 30799  "Prąd na fazie L2"  "[A]"  2  0.001;
    9 30801  "Prąd na fazie L3"  "[A]"  2  0.001;
    10 30803  "Częstotliwość sieci"  "[Hz]"  2  0.01;
    11 30783  "Napięcie fazowe L1"  "(V)"  2  0.01;
    12 30785  "Napięcie fazowe L2"  "(V)"  2  0.01;
    13 30787  "Napięcie fazowe L3"  "(V)"  2  0.01;
    14 30813  "Moc pozorna"  "(VA)"  2  1;
    15 30805  "Moc bierna"  "(var)"  2  0.01;
    16 30815  "Moc pozorna L1"  "(VA)"  2  1;
    17 30817  "Moc pozorna L2"  "(VA)"  2  1;
    18 30819  "Moc pozorna L3"  "(VA)"  2  1;
    19 30807  "Moc bierna L1"  "(VAr)"  2  1;
    20 30809  "Moc bierna L2"  "(VAr)"  2  1;
    21 30811  "Moc bierna L3"  "(VAr)"  2  1;
    22 30777  "Moc czynna L1"  "(W)"  2  1;
    23 30779  "Moc czynna L2"  "(W)"  2  1;
    24 30781  "Moc czynna L3"  "(W)"  2  1;
    25 30219  "Derating"  ""  2  1;
    26 30561  "Liczba wydarzeń dla instalatora"  ""  2  1;
    27 30559  "Liczba wydarzeń dla użytkownika"  ""  2  1;
    28 30197  "Current event number"  ""  2  1;
    29 30217  "Grid relay/contactor"  ""  2  1;
    30 30201  "Stan pracy"  ""  2  1;
    31 30211  "Zalecane działanie"  ""  2  1;
    32 30199  "Czas oczekiwania na zasilanie"  "(s)"  2  1;
    33 30775  "Moc czynna AC na wszystkich fazach"  "(W)"  2  1;
    34 30231  "Maksymalna moc czynna na urządzenie"  "W"  2  1;
    35 40212  "Ograniczenie mocy czynnej  P"  "W"  2  1] ;

%%%%%%%%%%
wybPara = 3; %LP parametru
idUrzadz = 7; %ID falownika
%%%%%%%%%%%%%
% ID 5 = falownik 20 kW
% ID 7 = falownik 8 kW
%%%%%%%%%%

%próba połączenia z falownikiem
testPol(idUrzadz);

numerRejestru = registers(wybPara,2);
przesPrzec =registers(wybPara,6);
macWe = str2double([idUrzadz numerRejestru przesPrzec]);


fprintf('Odczytany zostanie parametr: %s %s',registers(wybPara,3),registers(wybPara,4)) ;

load_system('simulink_testowy.slx')
open_system('simulink_testowy/Scope')
sim('simulink_testowy.slx')

