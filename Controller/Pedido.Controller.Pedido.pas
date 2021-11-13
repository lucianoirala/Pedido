unit Pedido.Controller.Pedido;

interface

uses
  Pedido.Model.Interfaces, Data.DB;

type

  TControllerPedido = Class(TInterfacedObject, iPedido)
     private
        FModelPedido: iPedido;
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
  Pedido.Model.Pedido;

{ TControllerPedido }

function TControllerPedido.AdicionarItem(Value: iItensPedido): iPedido;
begin
   Result := Self;
   FModelPedido.AdicionarItem(Value);
end;

function TControllerPedido.Buscar(Value: String): iPedido;
begin
    Result := Self;
    FModelPedido.Buscar(Value);
end;

function TControllerPedido.Cancelar(Value: String): Boolean;
begin
   Result := FModelPedido.Cancelar(Value);
end;

constructor TControllerPedido.Create;
begin
   FModelPedido := TModelPedido.New;
end;

destructor TControllerPedido.Destroy;
begin

  inherited;
end;

function TControllerPedido.GetDataSet: TDataSet;
begin
   Result := FModelPedido.GetDataSet;
end;

function TControllerPedido.GetNumPedido: Integer;
begin
   Result := FModelPedido.GetNumPedido;
end;

function TControllerPedido.Gravar: Boolean;
begin
   Result := FModelPedido.Gravar;
end;

function TControllerPedido.LimparItens: iPedido;
begin
   Result := Self;
   FModelPedido.LimparItens;
end;

class function TControllerPedido.New: iPedido;
begin
   Result := Self.Create;
end;

function TControllerPedido.SetCodCliente(Value: Integer): iPedido;
begin
   Result := Self;
   FModelPedido.SetCodCliente(Value);
end;

function TControllerPedido.SetValorTotal(Value: Currency): iPedido;
begin
   Result := Self;
   FModelPedido.SetValorTotal(Value);
end;

end.
