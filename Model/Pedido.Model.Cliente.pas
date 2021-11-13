unit Pedido.Model.Cliente;

interface

uses
    Pedido.Model.Interfaces, Generics.Collections, Vcl.StdCtrls;

type

   TTipoAlinhamento = (tpDireita, tpEsquerda);

   TModelCliente = Class(TInterfacedObject, iCliente)
     private
        FQuery: iQuery;
        FNomeCliente: String;

     public
        Constructor Create;
        Destructor  Destroy; override;
        Class Function New: iCliente;

        function Buscar(Value: String): iCliente;
        function GetNomeCliente: String;
   End;

implementation

uses
  System.SysUtils, DateUtils, Vcl.Graphics, Pedido.Model.Conexao.Query;

{ TModelCliente }

function TModelCliente.Buscar(Value: String): iCliente;
Var
  lSQL: String;
begin
   Result := Self;

   lSQL := 'SELECT * FROM TBCLIENTES ' +
           'WHERE CODIGO = :Codigo';

   FQuery.SQL(lSQL)
         .Params.ParamByName('Codigo').AsString := Value;

   FQuery.Listar;
   if Not FQuery.GetDataSet.IsEmpty then
     FNomeCliente := FQuery.GetDataSet.FieldByName('nome').AsString;

end;

constructor TModelCliente.Create;
begin
   FQuery := TQuery.New;
end;

destructor TModelCliente.Destroy;
begin

  inherited;
end;

function TModelCliente.GetNomeCliente: String;
begin
   Result := FNomeCliente;
end;

class function TModelCliente.New: iCliente;
begin
   Result := Self.Create;
end;

end.
