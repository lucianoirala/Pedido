unit Pedido.Model.Produto;

interface

uses
  Pedido.Model.Interfaces, SysUtils;

type

  TModelProduto = Class(TInterfacedObject, iProduto)
     private
        FQuery: iQuery;
        FDescricao: String;
        FPreco: Currency;
     public
        Constructor Create;
        Destructor Destroy; override;
        Class Function New: iProduto;

        function Buscar(Value: String): iProduto;
        function GetDescricaoProduto: String;
        function GetPreco: Currency;

  End;

implementation

uses
  Pedido.Model.Conexao.Query;

{ TModelProduto }

function TModelProduto.Buscar(Value: String): iProduto;
Var
  lSQL: String;
begin
   Result := Self;

   lSQL := 'SELECT * FROM TBPRODUTOS ' +
           'WHERE CODIGO = :Codigo';

   FQuery.SQL(lSQL)
         .Params.ParamByName('Codigo').AsString := Value;

   FQuery.Listar;
   if Not FQuery.GetDataSet.IsEmpty then
   begin
      FDescricao := FQuery.GetDataSet.FieldByName('descricao').AsString;
      FPreco     := FQuery.GetDataSet.FieldByName('preco_venda').AsCurrency;
   end;
end;

constructor TModelProduto.Create;
begin
    FQuery := TQuery.New;
end;

destructor TModelProduto.Destroy;
begin

  inherited;
end;

function TModelProduto.GetDescricaoProduto: String;
begin
   Result := FDescricao;
end;

function TModelProduto.GetPreco: Currency;
begin
   Result := FPreco;
end;

class function TModelProduto.New: iProduto;
begin
   Result := Self.Create;
end;

end.
