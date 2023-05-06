{
    filename:       		zeitmessung.pas
    title:          		zeitmessung Assembler-Routine mit Pascal
    author:        		 	John Lienau
							Tobias Pinnau
    version:        		v0.1
    date:           		05.07.2022
    copyright:      		Copyright (c) 2022

    brief:          		Es wird in Pascal der Mittelwert eines Arrays berechnet und die Zeitgemessen
    
    compilierungs Aufruf: 	fpc -gs zeitmessung.pas
}

Program zeitmessung;

	uses
		sysutils, dateutils;

	{$ASMMODE intel}

	const
		anzahl:uint64=7;

	type 
		TBuffer= packed array[0..7-1] of single;
		Tsum = packed array[0..7] of single;

	function compute(var t:TBuffer):double;
		var
			i:uint64;
			sum:double;
			sumArray:Tsum;
			durchlaufe:uint64;
			compute1: double;

		//durchlaufe=trunc(anzahl/8)-1;

		begin
			durchlaufe := anzahl div 8;
			sum:=0;
			for i:=0 to 7 do
				sumArray[i] :=0;
			asm 
				mov r15, t
				xor r14, r14
				vmovups ymm0,sumArray
			end;
			for i:= 1 to durchlaufe  do
			begin
				asm
					vaddps ymm0, ymm0, [r15]
					add r15, 32
					
				end;				
			end;

			asm 
				vmovups sumArray, ymm0
			end;
			for i:= 1 to anzahl mod 8 do
			sum := sum + t[durchlaufe + i]; 

			for i:= 0 to 7 do
				sum:= sum + sumArray[i];

			compute1 := sum / anzahl;	
			compute := compute1		
		end;

	var
		s:double;
		i:Longint;
		t:TBuffer;
		z1, z2:TDateTime;


	begin 
		Randomize;
		for i := 0 to anzahl -1 do
			t[i]:= random;
			
		// startzeit
		z1:=now;
		// computing
		s:=compute(t);
		// endzeit
		z2:=now;

		// ausgabe
		writeln('Ergebnis: ',s:0:10);
		// differenz zwischen z1 und z2 (genutze zeit beim compute())
		writeln('Zeit (ms): ',millisecondsbetween(z1,z2));
	end.
