unit Pedido.Controller.Produto;

interface

uses
  Pedido.Model.Interfaces;

type

   TControllerProduto = Class(TInterfacedObject, iProduto)
      private
         FModelProduto: iProduto;
      public
         Constructor Create;
         Destructor  Destroy; override;
         Class Function New: iProduto;

         function Buscar(Value: String): iProduto;
         function GetDescricaoProduto: String;
         function GetPreco: Currency;
   End;

implementation

uses
  Pedido.Model.Produto;

{ TControllerProduto }

function TControllerProduto.Buscar(Value: String): iProduto;
begin
   Result := Self;
   FModelProduto.Buscar(Value);
end;

constructor TControllerProduto.Create;
begin
    FModelProduto := TModelProduto.New;
end;

destructor TControllerProduto.Destroy;
begin

  inherited;
end;

function TControllerProduto.GetDescricaoProduto: String;
begin
   Result := FModelProduto.GetDescricaoProduto;
end;

function TControllerProduto.GetPreco: Currency;
begin
   Result := FModelProduto.GetPreco;
end;

class function TControllerProduto.New: iProduto;
begin
   Result := Self.Create;
end;

end.
