clear all; clc;
m = modbus('tcpip', '172.22.2.91');
dataCzas = string(datetime("now","Format","dd-MM-uuuu'_T_'HH-mm"));


registers=["Numer"  "Opis"  "Jednostka"  "Words"  "Format";
    30769  "Prąd wejściowy DC" "[A]"  2  0.001;
    30771  "Napięcie wejściowe DC"  "[V]"  2  0.01;
    30773  "Moc wejściowa DC"  "[W]"  2  1;
    31793  "String current  string 1"  "[A]"  2  0.001;
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

meteoStatRegisters =["Numer"  "Opis"  "Jednostka"  "Words"  "Format";
    34617 "Wilgotność względna" "(%)" 2 0.01
    34619 "Ciśnienie" "(hPa)" 2 0.01
    34613 "Nasłoneczenie padające na sensor" "(W/m^2)" 2 1
    34609 "Temperatura otoczenia" "(C)" 2 0.1
    34621 "Temperatura modułu PV" "(C)" 2 0.1
%     30521 "Czas pracy" "(s)" 4 1
    ];

%wybór odczytywanych parametrów pracy instalacji
i=[3 4 14];
%wybór paramteru stacji meteo
mStatReg = 4;

%wybór falownika 
idFal = 7;
% 7 - 8kW
% 5 - 20 kW

%próba połączenia z falownikiem
testPol(idFal);

figure1 = figure('Color',[1 1 1]);
idx=0;
while true
      idx=idx+1;
      t(idx) = datetime('now','Format','HH:mm:ss');

      %stacja meteo odczyt
      mStat=read(m,'holdingregs',str2num(meteoStatRegisters(mStatReg,1)),3,3);
      mStat2(idx)=numConcat(mStat,str2num(meteoStatRegisters(mStatReg,5)));

      %odczytywanie danych z falownika i zapis co każdą iterację
      for j=1:length(i)
       rr(j,:)=read(m,'holdingregs',str2num(registers(i(j),1)),3,idFal)
      end
        przesPrzecinka = str2double(registers(i',5));
        rr2(:,idx)=numConcat(rr,przesPrzecinka)

%generowanie wykresów 
 subplot(3,1,1);
    yyaxis left
      plot(t(1:idx),rr2(1,1:idx));
      xlabel('time');
      ylabel(append(registers(i(1),2),' ', registers(i(1),3)));
    yyaxis right
      plot(t(1:idx),mStat2);
      ylabel('Nasłonecznienie [W/m2]')
      grid on;

    subplot(3,1,2)
    yyaxis left
      plot(t(1:idx),rr2(2,1:idx));
      xlabel('time');
      ylabel(append(registers(i(2),2),' ', registers(i(2),3)));
    yyaxis right
      plot(t(1:idx),mStat2);
      ylabel('Nasłonecznienie [W/m2]')
      grid on;

    subplot(3,1,3)
    yyaxis left
      plot(t(1:idx),rr2(3,1:idx));
      xlabel('time');
      ylabel(append(registers(i(3),2),' ', registers(i(3),3)));
    yyaxis right
      plot(t(1:idx),mStat2);
      ylabel('Nasłonecznienie [W/m2]')
      grid on;  

if not(isfolder(fullfile(pwd,'figures')))
    mkdir(fullfile(pwd,'figures'))
end
saveas(figure1,fullfile(pwd,'figures',dataCzas),'fig')


      pause(10)
end

function num2=numConcat(rr3,duration)
%     num2=rr3(:,2).*1e4+rr3(:,3).*duration;
        num2=(rr3(:,2).*65535+rr3(:,3)).*duration;

end