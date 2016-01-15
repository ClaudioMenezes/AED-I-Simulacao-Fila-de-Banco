unit libfila;

interface

type
    elem=word;

    noh=record
        item: elem;
        proximo: ^noh;
    end;

    fila = record
      inicio: ^noh;
      fim: ^noh;
      tamanho: integer;
    end;

procedure criar(var f:fila);
function vazia (var f:fila):boolean;
function inserir (var f:fila; x:elem): boolean;
function remover (var f:fila): boolean;
function elemento_inicio(var f:fila): elem;
function elemento_fim(var f:fila): elem;

implementation

procedure criar(var f:fila);
    begin
        f.inicio:=nil;
        f.fim:=nil;
        f.tamanho:=0;
    end;

function vazia (var f:fila):boolean;
    begin
        if f.inicio=nil then
            vazia:=true
        else
            vazia:=false;
    end;

function inserir (var f:fila; x:elem): boolean;
    var
        novo_noh: ^noh;
    begin
        new(novo_noh); { criar novo noh }
        if (novo_noh <> nil) then
        begin
            if (vazia (f)) then
            begin
                novo_noh^.item := x;
                novo_noh^.proximo := nil;
                f.fim := novo_noh;
                f.inicio := f.fim;
                f.tamanho:=f.tamanho+1;
                inserir:=true;
            end
            else
            begin
                novo_noh^.item := x;
                novo_noh^.proximo := nil;
                f.fim^.proximo := novo_noh;
                f.fim := novo_noh;
                f.tamanho:= f.tamanho +1;
                inserir:=true;
            end;
        end
        else
            inserir:=false;
    end;

function remover (var f:fila): boolean;
    var
        aux : ^noh; { armazena o noh a ser excluido }
    begin
        if (not vazia(f)) then
        begin
            aux := f.inicio;
            f.inicio:=f.inicio^.proximo;
            dispose (aux);
            f.tamanho:=f.tamanho -1;
            remover:=true;
        end
        else
            remover:=false;
    end;

function elemento_inicio(var f:fila): elem;
    begin
        elemento_inicio := f.inicio^.item;
    end;

function elemento_fim (var f:fila): elem;
    begin
        elemento_fim := f.fim^.item;
    end;
end.