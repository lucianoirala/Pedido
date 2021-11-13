unit Pedido.Model.Pedido;

interface

uses
  Pedido.Model.Interfaces, Data.DB, Generics.Collections;

type

  TModelPedido = Class(TInterfacedObject, iPedido)
     private
         FQuery: iQuery;
         FDataSource: TDataSource;
         FDataEmissao: TDate;
         FCodCliente: Integer;
         FValorTotal: Currency;
         FNumPedido: Integer;
         FListaItens: TList<iItensPedido>;

         function GravarItens: Boolean;
     public
        Constructor Create;
        Destructor  Destroy; override;
        Class Function New: iPedido;

        function SetCodCliente(Value: Integer): iPedido;
        function SetValorTotal(Value: Currency): iPedido;
        function Buscar(Value: String): iPedido;
        function Gravar: Boolean;
        function Cancelar(Value: String): Boolean;
        function GetDataSet: TDataSet;
        function AdicionarItem(Value: iItensPedido): iPedido;
        function GetNumPedido: Integer;
        function LimparItens: iPedido;
  End;

implementation

uses
  Pedido.Model.Conexao.Query, System.SysUtils, Pedido.Model.ItensPedido;

{ TModelPedido }

function TModelPedido.AdicionarItem(Value: iItensPedido): iPedido;
begin
   Result := Self;
   FListaItens.Add(Value);
end;

function TModelPedido.Buscar(Value: String): iPedido;
Var
  lSQL: String;
begin
   Result := Self;

   lSQL := 'SELECT p.codigo_cliente, c.nome, p.valor_total AS valor_total_pedido, ' +
           '       i.codigo_produto, pr.descricao, i.quantidade, i.valor_unitario, ' +
           '       i.valor_total AS valor_total_item ' +
           'FROM tbpedido p ' +
           'INNER JOIN tbitens_pedido i ' +
           'ON ' +
           '   p.num_pedido = i.num_pedido ' +
           'INNER JOIN tbprodutos pr ' +
           'ON ' +
           '   pr.codigo = i.codigo_produto ' +
           'INNER JOIN tbclientes c ' +
           'ON ' +
           '   c.codigo = p.codigo_cliente ' +
           'WHERE p.num_pedido = :NumPedido';

   FQuery.SQL(lSQL)
         .Params.ParamByName('NumPedido').AsString := Value;

   FQuery.Listar;
   FDataSource.DataSet := FQuery.GetDataSet;

end;

function TModelPedido.Cancelar(Value: String): Boolean;
Var
  lSQL: String;
begin
   lSQL := 'DELETE FROM TBPEDIDO ' +
           'WHERE NUM_PEDIDO = :NumPedido';

   FQuery.SQL(lSQL)
         .Params.ParamByName('NumPedido').AsString := Value;

   Result := FQuery.ExecSQL;
end;

constructor TModelPedido.Create;
begin
   FQuery   := TQuery.New;
   FDataSource := TDataSource.Create(Nil);
   FListaItens := TList<iItensPedido>.Create;
end;

destructor TModelPedido.Destroy;
begin
     FreeAndNil(FDataSource);
     FreeAndNil(FListaItens);
  inherited;
end;

function TModelPedido.GetDataSet: TDataSet;
begin
   Result := FDataSource.DataSet;
end;

function TModelPedido.GetNumPedido: Integer;
begin
   Result := FNumPedido;
end;

function TModelPedido.Gravar: Boolean;
Var
  lSQL: String;
begin
   Result := False;

   lSQL := 'INSERT INTO TBPEDIDO ' +
           '(data_emissao, codigo_cliente, valor_total) ' +
           'VALUES(:DataEmissao, :CodCliente, :ValorTotal)';

   FQuery.SQL(lSQL);
   With FQuery.Params do
   begin
      ParamByName('DataEmissao').AsDate := Date;
      ParamByName('CodCliente').AsInteger := FCodCliente;
      ParamByName('ValorTotal').AsCurrency := FValorTotal;
   end;

   if FQuery.ExecSQL then
      Result := GravarItens;

end;

function TModelPedido.GravarItens: Boolean;
var
  I: Integer;
  lSQL: String;
  lITensPedido: iItensPedido;
begin
    Result := False;
    lSQL := 'SELECT MAX(num_pedido) AS num_pedido FROM TBPEDIDO';

   FQuery.SQL(lSQL)
         .Listar;

   FNumPedido := FQuery.GetDataSet.FieldByName('num_pedido').AsInteger;

   lITensPedido := TModelItensPedido.New(FListaItens)
                                    .SetNumPedido(FNumPedido);
   Result := lITensPedido.Gravar;
   if Not Result then
      Cancelar(FNumPedido.ToString);

end;

function TModelPedido.LimparItens: iPedido;
begin
   Result := Self;
   FListaItens.Clear;
end;

class function TModelPedido.New: iPedido;
begin
   Result := Self.Create;
end;

function TModelPedido.SetCodCliente(Value: Integer): iPedido;
begin
   Result := Self;
   FCodCliente := Value;
end;

function TModelPedido.SetValorTotal(Value: Currency): iPedido;
begin
   Result := Self;
   FValorTotal := Value;
end;

end.

