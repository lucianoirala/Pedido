unit Pedido.Model.Conexao.Query;

interface


uses
  Data.DB, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  System.Classes, System.SysUtils, Pedido.Model.Interfaces;

type

   TQuery = Class(TInterfacedObject, iQuery)
     private
         FConexao : iConexao;
         FQuery   : TFDQuery;

         FParams  : TParams;

         procedure Desconectar;
         procedure FDQueryErro(ASender, AInitiator: TObject; var AException: Exception);
     public
        Constructor Create;
        Destructor  Destroy; override;
        Class Function New: iQuery;

        function Listar: iQuery;
        function GetDataSet: TDataSet;
        function SQL(Value: String): iQuery;
        function ExecSQL: Boolean;
        function Params : TParams;
        function StartTransaction: iQuery;
        function Comit: iQuery;
        function Rollback: iQuery;
   End;

implementation

uses
  Pedido.Model.Conexao;

{ TQuery }


function TQuery.Comit: iQuery;
begin
   Result := Self;
   FConexao.Comit;
end;

Constructor TQuery.Create;
begin
   FQuery := TFDQuery.Create(Nil);
   FQuery.FetchOptions.Mode := fmAll;
   FQuery.OnError := FDQueryErro;
   FQuery.UpdateOptions.CountUpdatedRecords := False;

   FConexao := TConexao.New;
   if Assigned(FConexao) then
     FQuery.Connection := TFDCustomConnection(FConexao.Conexao);
end;

procedure TQuery.Desconectar;
begin
   if Assigned(FConexao) AND FConexao.Conectado then
   begin
      FConexao.Desconectar;
      FConexao := Nil;
   end;
end;

destructor TQuery.Destroy;
begin
   Desconectar;
   FreeAndNil(FQuery);

   if Assigned(FParams) then
      FreeAndNil(FParams);

  inherited;
end;

function TQuery.ExecSQL: Boolean;
begin
   Result := False;
   With FQuery do
   begin
       if Assigned(FParams) then
          Params.Assign(FParams);

       Prepare;
       ExecSQL;
   end;

   if Assigned(FParams) then
      FreeAndNil(FParams);

   Result := FQuery.RowsAffected > 0;
end;

procedure TQuery.FDQueryErro(ASender, AInitiator: TObject; var AException: Exception);
Var
  lErro: String;
begin
    lErro := AException.Message;
    lErro := StringReplace(lErro, '[FireDAC][Phys][PG][libpq] ERROR:', '', [rfReplaceAll]);
    lErro := 'ERRO: ' + Trim(lErro);

    if (ASender IS TFDQuery) then
       lErro := lErro + '. [' + (ASender AS TFDQuery).SQL.Text + ']';

    if (ASender IS TFDCommand) then
       lErro := lErro + '. [' + (ASender AS TFDCommand).CommandText.Text + ']';

    raise Exception.Create(lErro);

end;

function TQuery.Listar: iQuery;
begin
   Result := Self;
   With FQuery do
   begin
       if Assigned(FParams) then
          Params.Assign(FParams);

       Prepare;
       Open;
   end;

   if Assigned(FParams) then
      FreeAndNil(FParams);
end;

class Function TQuery.New: iQuery;
begin
    Result := Self.Create;
end;

function TQuery.Params: TParams;
begin
    if Not Assigned(FParams) then
    begin
        FParams := TParams.Create(nil);
        FParams.Assign(FQuery.Params);
    end;
    Result := FParams;
end;

function TQuery.Rollback: iQuery;
begin
   Result := Self;
   FConexao.Rollback;
end;

function TQuery.SQL(Value: String): iQuery;
begin
   Result := Self;
   with FQuery do
   begin
       Close;
       SQL.Clear;
       SQL.Add(Value);
   end;
end;

function TQuery.StartTransaction: iQuery;
begin
   Result := Self;
   FConexao.StartTransaction;
end;

function TQuery.GetDataSet: TDataSet;
begin
   Result := FQuery;
end;

end.
