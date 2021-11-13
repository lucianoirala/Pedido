program Pedido;

uses
  Vcl.Forms,
  Pedido.View.Principal in '..\View\Pedido.View.Principal.pas' {ViewPrincipal},
  Pedido.Model.Interfaces in '..\Model\Pedido.Model.Interfaces.pas',
  Pedido.Model.Cliente in '..\Model\Pedido.Model.Cliente.pas',
  Pedido.Model.Produto in '..\Model\Pedido.Model.Produto.pas',
  Pedido.Controller.Produto in '..\Controller\Pedido.Controller.Produto.pas',
  Pedido.Controller.Cliente in '..\Controller\Pedido.Controller.Cliente.pas',
  Pedido.Model.Conexao.Configuracao in '..\Model\Conexao\Pedido.Model.Conexao.Configuracao.pas',
  Pedido.Model.Conexao in '..\Model\Conexao\Pedido.Model.Conexao.pas',
  Pedido.Model.Conexao.Query in '..\Model\Conexao\Pedido.Model.Conexao.Query.pas',
  Pedido.Controller.Pedido in '..\Controller\Pedido.Controller.Pedido.pas',
  Pedido.Model.Pedido in '..\Model\Pedido.Model.Pedido.pas',
  Pedido.Controller.ItensPedido in '..\Controller\Pedido.Controller.ItensPedido.pas',
  Pedido.Model.ItensPedido in '..\Model\Pedido.Model.ItensPedido.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TViewPrincipal, ViewPrincipal);
  Application.Run;
end.
