function rr2 = func(macWe)

m = modbus('tcpip', '172.22.2.91');

    rr=read(m,'holdingregs',macWe(2),3,macWe(1));
    rr2=numConcat(rr,macWe(3));
    fprintf('\n CZAS ODCZYTU: %s %s %.2f',datetime('now','Format','HH:mm:ss'),'  ;  ',rr2);
    pause(10)
end

%ustawienie przecinka tak aby wielkość była dana w odpowiedniej jednostce
function num2=numConcat(rr3,duration)
%     num2=rr3(2)*1e4+rr3(3)*duration;
        num2=(rr3(2)*65535+rr3(3))*duration;

end