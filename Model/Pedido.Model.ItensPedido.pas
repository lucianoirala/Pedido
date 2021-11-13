unit Pedido.Model.ItensPedido;

interface


uses
  Pedido.Model.Interfaces, Generics.Collections;

type

  TModelItensPedido = Class(TInterfacedObject, iItensPedido)
     private
       FQuery: iQuery;
       FNumPedido: Integer;
       FCodProduto: Integer;
       FQuantidade: Integer;
       FValorUnitario: Currency;
       FValorTotal: Currency;
       FListaItens: TList<iItensPedido>;

     public
       Constructor Create(Value: TList<iItensPedido>);
       Destructor  Destroy; override;
       Class Function New(Value: TList<iItensPedido>): iItensPedido;

       function Gravar: Boolean;
       function SetNumPedido(Value: Integer): iItensPedido;
       function SetCodProduto(Value: Integer): iItensPedido;
       function SetQuantidade(Value: Integer): iItensPedido;
       function SetValorUnitario(Value: Currency): iItensPedido;
       function SetValorTotal(Value: Currency): iItensPedido;
       function GetCodProduto: Integer;
       function GetQuantidade: Integer;
       function GetValorUnitario: Currency;
       function GetValorTotal: Currency;
  End;

implementation

uses
  Pedido.Model.Conexao.Query;

{ TModelItensPedido }

Constructor TModelItensPedido.Create(Value: TList<iItensPedido>);
begin
   FQuery := TQuery.New;
   FListaItens := Value;
end;

destructor TModelItensPedido.Destroy;
begin

  inherited;
end;

function TModelItensPedido.GetCodProduto: Integer;
begin
   Result := FCodProduto;
end;

function TModelItensPedido.GetQuantidade: Integer;
begin
   Result := FQuantidade;
end;

function TModelItensPedido.GetValorTotal: Currency;
begin
   Result := FValorTotal;
end;

function TModelItensPedido.GetValorUnitario: Currency;
begin
   Result := FValorUnitario;
end;

function TModelItensPedido.Gravar: Boolean;
Var
  lSQL: String;
  I: Integer;
begin
   Result := False;
   lSQL := 'INSERT INTO TBITENS_PEDIDO ' +
           '(num_pedido, codigo_produto, quantidade, ' +
           ' valor_unitario, valor_total) ' +
           'VALUES(:NumPedido, :codProduto, :Qtd, :VlUnitario, :VlTotal)';

   FQuery.SQL(lSQL);
   FQuery.StartTransaction;
   for I := 0 to Pred(FListaItens.Count) do
   begin
       With FQuery.Params do
       begin
          ParamByName('NumPedido').AsInteger  := FNumPedido;
          ParamByName('codProduto').AsInteger := iItensPedido(FListaItens[I]).GetCodProduto;
          ParamByName('Qtd').AsInteger        := iItensPedido(FListaItens[I]).GetQuantidade;
          ParamByName('VlUnitario').AsCurrency:= iItensPedido(FListaItens[I]).GetValorUnitario;
          ParamByName('VlTotal').AsCurrency   := iItensPedido(FListaItens[I]).GetValorTotal;
       end;

       try
         Result := FQuery.ExecSQL;

         Except
         begin
           FQuery.Rollback;
           Result := False;
           Break;
         end;
       end;
   end;

   if Result then
      FQuery.Comit;
end;

class Function TModelItensPedido.New(Value: TList<iItensPedido>): iItensPedido;
begin
   Result := Self.Create(Value);
end;

function TModelItensPedido.SetCodProduto(Value: Integer): iItensPedido;
begin
   Result := Self;
   FCodProduto := Value;
end;

function TModelItensPedido.SetNumPedido(Value: Integer): iItensPedido;
begin
   Result := Self;
   FNumPedido := Value;
end;

function TModelItensPedido.SetQuantidade(Value: Integer): iItensPedido;
begin
   Result := Self;
   FQuantidade := Value;
end;

function TModelItensPedido.SetValorTotal(Value: Currency): iItensPedido;
begin
   Result := Self;
   FValorTotal := Value;
end;

function TModelItensPedido.SetValorUnitario(Value: Currency): iItensPedido;
begin
   Result := Self;
   FValorUnitario := Value;
end;

end.

