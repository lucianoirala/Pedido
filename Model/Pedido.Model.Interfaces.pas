unit Pedido.Model.Interfaces;

interface

uses
  Vcl.StdCtrls, Data.DB;

type

    TInfo = Record
        Servidor: String;
        NomeBanco: String;
        Porta: String;
    End;

   iConexao = interface
     ['{90351D26-57F1-4DF2-9D9C-9ABC66234394}']
     function Conexao: TCustomConnection;
     function Conectado: Boolean;
     function Desconectar: iConexao;
     function StartTransaction: iConexao;
     function Comit: iConexao;
     function Rollback: iConexao;
   end;

   iQuery = interface
     ['{F47B0C01-E434-48BC-AFD8-30C6EC6BD247}']
     function Listar: iQuery;
     function GetDataSet: TDataSet;
     function SQL(Value: String): iQuery;
     function ExecSQL: Boolean;
     function Params : TParams;
     function StartTransaction: iQuery;
     function Comit: iQuery;
     function Rollback: iQuery;
   end;

   iConfiguracao = interface
     ['{AC01E031-A7AD-4C8A-B2F4-88E1CA51BE13}']
     function Carregar: iConfiguracao;
     function Info: TInfo;
   end;

  iCliente = interface
    ['{FF8E822F-967F-4B6A-B4A3-F7CABAD649A0}']
    function Buscar(Value: String): iCliente;
    function GetNomeCliente: String;
  end;

  iProduto = interface
    ['{AEA4ABE3-93AF-4FB7-9495-FB9A1996B96F}']
    function Buscar(Value: String): iProduto;
    function GetDescricaoProduto: String;
    function GetPreco: Currency;
  end;

  iItensPedido = interface;

  iPedido = interface
    ['{52B5FE3B-8479-45BA-A18E-86454A6627F6}']
    function SetCodCliente(Value: Integer): iPedido;
    function SetValorTotal(Value: Currency): iPedido;
    function Buscar(Value: String): iPedido;
    function Gravar: Boolean;
    function Cancelar(Value: String): Boolean;
    function GetDataSet: TDataSet;
    function GetNumPedido: Integer;
    function AdicionarItem(Value: iItensPedido): iPedido;
    function LimparItens: iPedido;
  end;

  iItensPedido = interface
    ['{CC76F857-79B9-422C-930A-0D61F88C7B7A}']
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
  end;

implementation

end.
