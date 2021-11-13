unit Pedido.Controller.Cliente;

interface

uses
  Pedido.Model.Interfaces, Vcl.StdCtrls;

type

   TControllerCliente = Class(TInterfacedObject, iCliente)
      private
         FModelCliente: iCliente;
      public
         Constructor Create;
         Destructor  Destroy; override;
         Class Function New: iCliente;

         function Buscar(Value: String): iCliente;
         function GetNomeCliente: String;

   End;

implementation

uses
  Pedido.Model.Cliente;

{ TControllerCliente }

function TControllerCliente.Buscar(Value: String): iCliente;
begin
   Result := Self;
   FModelCliente.Buscar(Value);
end;

constructor TControllerCliente.Create;
begin
   FModelCliente := TModelCliente.New;
end;

destructor TControllerCliente.Destroy;
begin

  inherited;
end;

function TControllerCliente.GetNomeCliente: String;
begin
   Result := FModelCliente.GetNomeCliente;
end;

class function TControllerCliente.New: iCliente;
begin
   Result := Self.Create;
end;

end.
