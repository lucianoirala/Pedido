unit Pedido.Controller.ItensPedido;

interface

uses
  Pedido.Model.Interfaces;

type

  TControllerItensPedido = Class(TInterfacedObject, iItensPedido)
     private
       FModelItensPedido: iItensPedido;
     public
       Constructor Create;
       Destructor  Destroy; override;
       Class Function New: iItensPedido;

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
  Pedido.Model.ItensPedido;

{ TControllerItensPedido }

constructor TControllerItensPedido.Create;
begin
   FModelItensPedido := TModelItensPedido.New(Nil);
end;

destructor TControllerItensPedido.Destroy;
begin

  inherited;
end;

function TControllerItensPedido.GetCodProduto: Integer;
begin
   Result := FModelItensPedido.GetCodProduto;
end;

function TControllerItensPedido.GetQuantidade: Integer;
begin
   Result := FModelItensPedido.GetQuantidade;
end;

function TControllerItensPedido.GetValorTotal: Currency;
begin
   Result := FModelItensPedido.GetValorTotal;
end;

function TControllerItensPedido.GetValorUnitario: Currency;
begin
   Result := FModelItensPedido.GetValorUnitario;
end;

function TControllerItensPedido.Gravar: Boolean;
begin
   Result := FModelItensPedido.Gravar;
end;

class function TControllerItensPedido.New: iItensPedido;
begin
   Result := Self.Create;
end;

function TControllerItensPedido.SetCodProduto(Value: Integer): iItensPedido;
begin
  Result := Self;
  FModelItensPedido.SetCodProduto(Value);
end;

function TControllerItensPedido.SetNumPedido(Value: Integer): iItensPedido;
begin
  Result := Self;
  FModelItensPedido.SetNumPedido(Value);
end;

function TControllerItensPedido.SetQuantidade(Value: Integer): iItensPedido;
begin
  Result := Self;
  FModelItensPedido.SetQuantidade(Value);
end;

function TControllerItensPedido.SetValorTotal(Value: Currency): iItensPedido;
begin
  Result := Self;
  FModelItensPedido.SetValorTotal(Value);
end;

function TControllerItensPedido.SetValorUnitario(Value: Currency): iItensPedido;
begin
  Result := Self;
  FModelItensPedido.SetValorUnitario(Value);
end;

end.
