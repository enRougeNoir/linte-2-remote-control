function info = testPol(idFal)
m = modbus('tcpip', '172.22.2.91');
%%%%%%%test połączenia z falownikiem%%%%%%%
%Condition
%35 = fault
%307 = ok
%455 = warning
%numerRej = 30201;
while true    
try
    rr=read(m,'holdingregs',30201,3,idFal);
    if rr(3)==35
        info = "fault";
    elseif rr(3)==307
        info="ok";
    elseif rr(3)==455
        info="warning";
    end
    fprintf('Odczytano dane z falownika o ID = %.0f || Condtion: %.0f - %s\n',idFal,rr(3),info);
    break

    catch
    fprintf('Błąd połączenia z falownikiem o ID %.0f\n',idFal);
   pause(10)
end
end
%%%%%%%%%%             %%%%%%%%%%%