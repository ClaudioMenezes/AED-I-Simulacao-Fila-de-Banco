program simulacaoBanco;

uses libfila, crt;

var qtdT0, qtdT1, qtdT2, qtdT3, qtdT4, qtdT5, qtdT6 : word;

// FUNCAO CALCULA MEDIA DO TEMPO DE ATENDIMENTO PARA 5 FILAS E RETORNA O VALOR

function tempoMediaAtendimento5Filas(espera1,espera2,espera3,espera4,espera5,clientes1,clientes2,clientes3,clientes4,clientes5:word):real;
var media1,media2,media3,media4,media5 :real;
begin
       media1 := (espera1/clientes1);
       media2 := (espera2/clientes2);
       media3 := (espera3/clientes3);
       media4 := (espera4/clientes4);
       media5 := (espera5/clientes5);
       tempoMediaAtendimento5Filas := (media1+ media2 + media3 + media4 + media5)/5;
end;

function menorFila (fila1, fila2, fila3, fila4, fila5 : fila) : integer;
var menor, i : integer;
    vetor : array [1..5] of integer;
begin
    menor := fila1.tamanho;

    //vetor[1] := fila1.tamanho;
    vetor[2] := fila2.tamanho;
    vetor[3] := fila3.tamanho;
    vetor[4] := fila4.tamanho;
    vetor[5] := fila5.tamanho;
    for i:=2 to 5 do
    begin
        if (vetor[i] < menor) then
            menor := vetor[i];
    end;
    menorFila := menor;
end;
//PROCEDIMENTOS INCREMENTA CADA TRANSACAO

procedure qtdTransacao0 ();
begin
    inc(qtdT0);
end;

procedure qtdTransacao1 ();
begin
    inc(qtdT1);
end;

procedure qtdTransacao2 ();
begin
    inc(qtdT2);
end;

procedure qtdTransacao3 ();
begin
    inc(qtdT3);
end;

procedure qtdTransacao4 ();
begin
    inc(qtdT4);
end;

procedure qtdTransacao5 ();
begin
    inc(qtdT5);
end;

procedure qtdTransacao6 ();
begin
    inc(qtdT6);
end;

// FUNCAO SELECIONA RANDOMICAMENTE UMA TRANSACAO E A RETORNA O VALOR DA TRANSACAO SELECIONADA

function transacao (): word;
var opcao : byte;

begin
    opcao := random(7);
    case opcao of
        0 : begin
                transacao := 1;
                qtdTransacao0;
            end;
        1 : begin
                transacao := 2;
                qtdTransacao1;
            end;
        2 : begin
                transacao := 2;
                qtdTransacao2;
            end;
        3 : begin
                transacao := 1;
                qtdTransacao3;
            end;
        4 : begin
                transacao := 2;
                qtdTransacao4;
            end;
        5 : begin
                transacao := 3;
                qtdTransacao5;
            end;
        6 : begin
                transacao := 10;
                qtdTransacao6;
            end;
    end;
end;

//PROCEDIMENTO SIMULACAO FILA UNICA
procedure simulacaoFilaBanco(filaUnica:fila);
var i, qtdCliente, totalClientesAtendidos, esperaTotalMedia : word;
    tempoChegada, tempoTotal : integer;
    parada :boolean;
    caixa : array [1..5] of integer;

begin
    esperaTotalMedia := 0;
    totalClientesAtendidos := 0;
    tempoTotal := 0;
    tempoChegada := 0;
    qtdCliente := 0;
    parada:= false;
    caixa[1]:=0;
    caixa[2]:=0;
    caixa[3]:=0;
    caixa[4]:=0;
    caixa[5]:=0;

 // INICIO DO EXPEDIENTE VAI ATE 300 MIN = 5 HORAS
    while (tempoTotal <= 300) do
    begin
        qtdCliente := random(20); // Quantidade de clientes

        // INICIO INSERIR CLIENTE
        for i:=1 to qtdCliente do
        begin
            inserir(filaUnica,transacao());
            esperaTotalMedia:= filaUnica.fim^.item + esperaTotalMedia; // TEMPO DE ESPERA TOTAL
        end;
        // FIM INSERIR CLIENTE
          for i:=1 to 5 do
          begin
          caixa[i]:= tempoChegada;
          end;
        //INICIO REMOVER CLIENTE ATENDIDO
        while ((parada = false) and (not(vazia(filaUnica)))) do
        begin
            // DECREMENTA O TEMPO

            for i:=1 to 5 do
            begin

                if((caixa[i] > 0) and not(vazia(filaUnica))) then
                begin
                    caixa[i] := caixa[i] - filaUnica.inicio^.item;
                    remover(filaUnica);
                end;
            end;

            if ((caixa[1] <= 0) and (caixa[2] <= 0) and (caixa[3] <= 0) and (caixa[4] <= 0) and (caixa[5] <=0))  then
            begin
                parada := true;
            end;
         end;

        //FIM REMOVER CLIENTE ATENDIDO

        totalClientesAtendidos := qtdCliente + totalClientesAtendidos;
        tempoChegada := random(10); // Tempo para chegar novos clientes
        tempoTotal := tempoTotal + tempoChegada;
        parada:= false;
    end; // FIM DO WHILE
    // FIM DO EXPEDIENTE DE 300 MIN = 5 HORAS

    //IMPRESSAO DOS RESULTADOS APOS SIMULACAO
        writeln('Tempo Medio de espera do cliente para ser atendido: ', (esperaTotalMedia div totalClientesAtendidos), ' minutos e ', (((esperaTotalMedia mod totalClientesAtendidos)/60)):0:0, ' segundos.');
        writeln('Quantidade de clientes atendidos num expediente bancario: ',totalClientesAtendidos);
        writeln('Quantidade de transacoes realizadas: ', totalClientesAtendidos);
        writeln('Quantidade transacao 0: ',qtdT0);
        writeln('Quantidade transacao 1: ',qtdT1);
        writeln('Quantidade transacao 2: ',qtdT2);
        writeln('Quantidade transacao 3: ',qtdT3);
        writeln('Quantidade transacao 4: ',qtdT4);
        writeln('Quantidade transacao 5: ',qtdT5);
        writeln('Quantidade transacao 6: ',qtdT6);
        writeln('Quantidade de clientes apos fechar : ', filaUnica.tamanho);
end;

// PROCEDIMENTO SIMULACAO COM 5 FILAS
procedure simulacao5FilaBanco(fila1, fila2, fila3, fila4, fila5 : fila);
var qtdCliente, totalClientesAtendidos, tempoTotal,tempoEsperaFila1,
    tempoEsperaFila2,tempoEsperaFila3,tempoEsperaFila4,tempoEsperaFila5,
    totalClienteFila1,totalClienteFila2,totalClienteFila3,totalClienteFila4,
    totalClienteFila5,auxTempoChegada, somaFilas : word;
    tempoChegada : integer;
    tempoMedioFinal : real;

begin

    totalClientesAtendidos := 0;
    tempoTotal := 0;
    tempoChegada := 0;
    qtdCliente := 0;
    tempoEsperaFila1:=0;
    tempoEsperaFila2:=0;
    tempoEsperaFila3:=0;
    tempoEsperaFila4:=0;
    tempoEsperaFila5:=0;
    totalClienteFila1:=0;
    totalClienteFila2:=0;
    totalClienteFila3:=0;
    totalClienteFila4:=0;
    totalClienteFila5:=0;

    // INICIO DO EXPEDIENTE VAI ATE 300 MIN = 5 HORAS
    while (tempoTotal <= 300) do
    begin
        qtdCliente := random(20); // Quantidade de clientes
        totalClientesAtendidos := qtdCliente + totalClientesAtendidos;
        // INICIO INSERIR CLIENTE
        while (qtdCliente > 0) do
        begin
            // INSERIR FILA 1
            if ((fila1.tamanho = menorFila(fila1, fila2, fila3, fila4, fila5)) and (qtdCliente >  0))  then
            begin
                inserir(fila1,transacao());
                tempoEsperaFila1:=fila1.fim^.item + tempoEsperaFila1; // TEMPO DE ESPERA PARA CADA FILA
                totalClienteFila1:= totalClienteFila1 +1;
                qtdCliente:= qtdCliente - 1;
            end;

            // INSERIR FILA 2
            if ((fila2.tamanho = menorFila(fila1, fila2, fila3, fila4, fila5)) and (qtdCliente >  0))  then
            begin
                inserir(fila2,transacao());
                tempoEsperaFila2:=fila2.fim^.item + tempoEsperaFila2; // TEMPO DE ESPERA PARA CADA FILA
                inc(totalClienteFila2);
                qtdCliente:= qtdCliente - 1;

            end;

            // INSERIR FILA 3
            if ((fila3.tamanho = menorFila(fila1, fila2, fila3, fila4, fila5)) and (qtdCliente >  0))  then
            begin
                inserir(fila3,transacao());
                tempoEsperaFila3:=fila3.fim^.item + tempoEsperaFila3;//TEMPO DE ESPERA PARA CADA FILA
                inc(totalClienteFila3);
                qtdCliente:= qtdCliente - 1;
            end;

            // INSERIR FILA 4
            if ((fila4.tamanho = menorFila(fila1, fila2, fila3, fila4, fila5)) and (qtdCliente >  0))  then
            begin
                inserir(fila4,transacao());
                tempoEsperaFila4:=fila4.fim^.item + tempoEsperaFila4;//TEMPO DE ESPERA PARA CADA FILA
                inc(totalClienteFila4);
                qtdCliente:= qtdCliente - 1;
            end;

            // INSERIR FILA 5
            if ((fila5.tamanho = menorFila(fila1, fila2, fila3, fila4, fila5)) and (qtdCliente >  0))  then
            begin
                inserir(fila5,transacao());
                tempoEsperaFila5:=fila5.fim^.item + tempoEsperaFila5;//TEMPO DE ESPERA PARA CADA FILA
                inc(totalClienteFila5);
                qtdCliente:= qtdCliente - 1;
            end;
        end; // FIM INSERIR CLIENTE

            // INICIO REMOVER CLIENTE ATENDIDO DE CADA FILA

            auxTempoChegada := tempoChegada; // TEMPO DE CHEGADA EH IGUAL PARA TODAS FILAS
            //FILA 1
            while ((tempoChegada > 0) and not(vazia(fila1))) do
            begin
                tempoChegada := tempoChegada - fila1.inicio^.item;
                remover(fila1);
            end;

            //FILA 2
            tempoChegada := auxTempoChegada;

            while ((tempoChegada > 0) and not(vazia(fila2))) do
            begin
                tempoChegada := tempoChegada - fila2.inicio^.item;
                remover(fila2);
            end;

            //FILA 3
            tempoChegada := auxTempoChegada;
            while ((tempoChegada > 0) and not(vazia(fila3))) do
            begin
                tempoChegada := tempoChegada - fila3.inicio^.item;
                remover(fila3);
            end;

            //FILA 4
            tempoChegada := auxTempoChegada;

            while ((tempoChegada > 0) and not(vazia(fila4))) do
            begin
                tempoChegada := tempoChegada - fila4.inicio^.item;
                remover(fila4);
            end;

            //FILA 5
            tempoChegada := auxTempoChegada;

            while ((tempoChegada > 0) and not(vazia(fila5))) do
            begin
                tempoChegada := tempoChegada - fila5.inicio^.item;
                remover(fila5);
            end;

        //FIM REMOVER CLIENTE ATENDIDO DE CADA FILA

        tempoChegada := random(10); // Tempo para chegar novos clientes
        tempoTotal := tempoTotal + tempoChegada;
    end; // FIM DO WHILE
    // FIM DO EXPEDIENTE DE 300 MIN = 5 HORAS

    //IMPRESSAO DOS RESULTADOS APOS SIMULACAO
        tempoMedioFinal := tempoMediaAtendimento5Filas(tempoEsperaFila1,tempoEsperaFila2,tempoEsperaFila3,tempoEsperaFila4,tempoEsperaFila5,totalClienteFila1,totalClienteFila2,totalClienteFila3,totalClienteFila4,totalClienteFila5);
        writeln('Tempo Medio de espera do cliente para ser atendido: ', (tempoMedioFinal):0:2, ' minutos.');
        writeln('Quantidade de clientes atendidos num expediente bancario: ', totalClientesAtendidos);
        writeln('Quantidade de transacoes realizadas: ', totalClientesAtendidos);
        writeln('Quantidade transacao 0: ', qtdT0);
        writeln('Quantidade transacao 1: ', qtdT1);
        writeln('Quantidade transacao 2: ', qtdT2);
        writeln('Quantidade transacao 3: ', qtdT3);
        writeln('Quantidade transacao 4: ', qtdT4);
        writeln('Quantidade transacao 5: ', qtdT5);
        writeln('Quantidade transacao 6: ', qtdT6);
        somaFilas := fila1.tamanho + fila2.tamanho + fila3.tamanho + fila4.tamanho + fila5.tamanho;
        writeln('Quantidade de clientes apos fechar : ', somaFilas);
end;

// PROGRAMA PRINCIPAL

var
    filaUnica, fila1, fila2, fila3, fila4, fila5: fila;

begin
    clrscr;
    randomize;
    qtdT0 := 0;
    qtdT1 := 0;
    qtdT2 := 0;
    qtdT3 := 0;
    qtdT4 := 0;
    qtdT5 := 0;
    qtdT6 := 0;
    criar(filaUnica);

    writeln('SIMULACAO FILA UNICA');
    simulacaoFilaBanco(filaUnica); // CHAMADA DA SIMULACAO FILA UNICA
    qtdT0 := 0;
    qtdT1 := 0;
    qtdT2 := 0;
    qtdT3 := 0;
    qtdT4 := 0;
    qtdT5 := 0;
    qtdT6 := 0;
    writeln('SIMULACAO 5 FILAS');
    criar(fila1);
    criar(fila2);
    criar(fila3);
    criar(fila4);
    criar(fila5);

    simulacao5FilaBanco(fila1, fila2, fila3, fila4, fila5); // CHAMADA DA SIMULACAO COM 5 FILAS
    readln;
end.