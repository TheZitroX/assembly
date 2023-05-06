{
    filename:       AssemblerRooutine.pas
    title:          Assembler-Routine mit Pascal
    author:         John Lienau
                    Tobias Pinnau
    version:        v0.1
    date:           14.06.2022
    copyright:      Copyright (c) 2022

    brief:          Es wird in Pascal zwei Assembler programme eingebunden
}

Program AssemblerRooutine;

{$L rinstrpos.o}
function rinstrpos(p:byte; s:shortstring; c:char):byte; external name 'rinstrpos';

function rinstr(s:shortstring; c:char):byte; external name 'rinstr';

var
	s : string;
	p : byte;
	c : char;

begin 
	s:='lHao Wet!l';
	c:='l';
	WriteLn('Suche "',c,'" in "',s,'"');
	p:= rinstr(s,c);
	while p<>0 do
	begin 
		WriteLn('Gefunden an Position ',p);
		p:=rinstrpos(p-1,s,c)
	end;
end.
