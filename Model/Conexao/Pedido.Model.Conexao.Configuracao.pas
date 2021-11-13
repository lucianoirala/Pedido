unit Pedido.Model.Conexao.Configuracao;

interface

uses
    IniFiles, Pedido.Model.Interfaces;

type

  TConfiguracao = Class(TInterfacedObject, iConfiguracao)
    private
       FArquivoINI: TiniFile;
       FInfo: TInfo;

    public
       Constructor Create;
       Destructor  Destroy; override;
       Class Function New: iConfiguracao;

       function Carregar: iConfiguracao;
       function Info: TInfo;
  End;

implementation

uses
  System.SysUtils, Vcl.Forms;

{ TConfiguracao }

function TConfiguracao.Carregar: iConfiguracao;
begin
    if Not FileExists(FArquivoINI.FileName) then
       raise Exception.Create('Arquivo de Configuração não encontrado!')
    else
    begin
       With FInfo do
       begin
          Servidor  := FArquivoINI.ReadString('BANCO', 'Servidor', '');
          NomeBanco := FArquivoINI.ReadString('BANCO', 'NomeBanco', '');
          Porta     := FArquivoINI.ReadString('BANCO', 'Porta', '0');
       end;
    end;

end;

function TConfiguracao.Info: TInfo;
begin
    Result := FInfo;
end;

constructor TConfiguracao.Create;
begin
   FArquivoINI := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Config.ini');
end;

destructor TConfiguracao.Destroy;
begin
      FreeAndNil(FArquivoINI);
  inherited;
end;

class function TConfiguracao.New: iConfiguracao;
begin
   Result := Self.Create;
end;

end.
