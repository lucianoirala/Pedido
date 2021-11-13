unit Pedido.Model.Conexao;

interface

uses
  Pedido.Model.Interfaces, Data.DB,FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.VCLUI.Wait, FireDAC.Comp.UI, FireDAC.Phys.MySQLDef, FireDAC.Phys.MySQL,
  FireDAC.Phys.IBBase, FireDAC.Comp.Client;

type

  TConexao = Class(TInterfacedObject, iConexao)
     private
         FConexao   : TFDConnection;
         FServidor  : String;
         FBancoDados: String;
         FPorta     : String;
         FConectado : Boolean;
         FDDriver   : TFDPhysMySQLDriverLink;

         procedure CarregarConfiguracao;
     public
         Constructor Create;
         Destructor  Destroy; override;
         Class Function  New: iConexao;

         function Conexao: TCustomConnection;
         function Conectado: Boolean;
         function Desconectar: iConexao;
         function StartTransaction: iConexao;
         function Comit: iConexao;
         function Rollback: iConexao;
  End;

implementation

uses
  System.SysUtils, Pedido.Model.Conexao.Configuracao;

{ TConexao }

procedure TConexao.CarregarConfiguracao;
Var
   lConfiguracao: iConfiguracao;
begin
    lConfiguracao := TConfiguracao.New;
    lConfiguracao.Carregar;
    FServidor  := 'localhost';
    FBancoDados:= 'cadastro';
    With lConfiguracao.Info do
    begin
       if Trim(Servidor) <> '' then
          FServidor := Servidor;

       if Trim(NomeBanco) <> '' then
          FBancoDados := NomeBanco;

       FPorta := Porta;
    end;

end;

function TConexao.Comit: iConexao;
begin
   Result := Self;
   FConexao.Commit;
end;

function TConexao.Conectado: Boolean;
begin
   Result := FConectado;
end;

function TConexao.Conexao: TCustomConnection;
begin
   Result := FConexao;
end;

constructor TConexao.Create;
Var
  lErro: String;
begin
   FConectado         := False;
   FDDriver           := TFDPhysMySQLDriverLink.Create(Nil);
   FDDriver.VendorLib := 'libmysql.dll';
   FConexao           := TFDConnection.Create(Nil);
   CarregarConfiguracao;
   With FConexao do
   begin
       LoginPrompt := False;
       Params.Values['DriverID'] := 'MySQL';
       Params.Values['Server']   := FServidor;
       Params.Values['Database'] := FBancoDados;
       Params.Values['User_Name']:= 'root';
       Params.Values['Password'] := '1234';
       Params.Values['Protocol'] := 'TCPIP';
       Params.Values['Port']     := FPorta;
       try
          Connected := True;
          FConectado := True;
          Except on E: Exception do
          begin
            lErro := Copy(E.Message, LastDelimiter(']', E.Message) +1, length(E.Message));
            lErro := 'Erro ao Conectar o Banco no Servidor [' + FServidor + ']: ' + lErro;
            raise Exception.Create(lErro);
          end;
        end;
   end;
end;

function TConexao.Desconectar: iConexao;
begin
    Result := Self;
    FConexao.Connected := False;
    FConectado := False;
end;

destructor TConexao.Destroy;
begin
     FreeAndNil(FDDriver);
     FreeAndNil(FConexao);
  inherited;
end;

class function TConexao.New: iConexao;
begin
   Result := Self.Create;
end;

function TConexao.Rollback: iConexao;
begin
   Result := Self;
   FConexao.Rollback;
end;

function TConexao.StartTransaction: iConexao;
begin
    Result := Self;
    With FConexao do
    begin
       TxOptions.Isolation := xiReadCommitted;
       TxOptions.AutoCommit := False;
       StartTransaction;
    end;
end;

end.
