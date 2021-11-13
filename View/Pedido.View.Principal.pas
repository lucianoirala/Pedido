unit Pedido.View.Principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Grids, Vcl.ExtCtrls, System.ImageList,
  Vcl.ImgList, Generics.collections, System.Classes, Pedido.Model.Interfaces;

type
  TViewPrincipal = class(TForm)
    PnlVenda: TPanel;
    PnlRodape: TPanel;
    BtSair: TButton;
    BtGravarPedido: TButton;
    BtBuscarPedido: TButton;
    STGProduto: TStringGrid;
    IMLIcones: TImageList;
    GroupBox1: TGroupBox;
    EdtValorUnitario: TLabeledEdit;
    BtAdicionar: TButton;
    EdtCodProduto: TLabeledEdit;
    EdtQuantidade: TLabeledEdit;
    GroupBox2: TGroupBox;
    EdtNomeCliente: TLabeledEdit;
    EdtCodCliente: TLabeledEdit;
    Panel1: TPanel;
    Label1: TLabel;
    EdtTotal: TEdit;
    btCancelarPedido: TButton;
    LBLDescricao: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure BtSairClick(Sender: TObject);
    procedure STGProdutoDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect;
      State: TGridDrawState);
    procedure BtAdicionarClick(Sender: TObject);
    procedure BtGravarPedidoClick(Sender: TObject);
    procedure EdtValorUnitarioEnter(Sender: TObject);
    procedure EdtValorUnitarioKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EdtValorUnitarioKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure BtBuscarClick(Sender: TObject);
    procedure EdtValorUnitarioExit(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure STGProdutoSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
    procedure STGProdutoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EdtCodClienteKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EdtCodProdutoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EdtQuantidadeKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure BtBuscarPedidoClick(Sender: TObject);
    procedure btCancelarPedidoClick(Sender: TObject);
  private
    { Private declarations }
    FSelecionado     : Integer;
    FDescricaoProduto: String;
    FEnterComoTAB    : Boolean;
    FPedido          : iPedido;

    function FormatarCampoMoeda(Value: String): String;
    function FormatarMoeda(Value: Currency): String;
    function ValidarFormulario: Boolean;
    procedure LimparFormulario;
    procedure LimparGrid;
    procedure AdicionarProduto;
    procedure RemoverProduto;
    procedure AlterarProduto;
    procedure PopularGrid(Value: String);
    procedure BuscarCliente;
    procedure BuscarProduto;
    procedure BuscarPedido;
    procedure CancelarPedido;
    procedure GravarPedido;
    function  ConverterMoeda(Value: String): Currency;
    procedure MudarCorCampo(Sender: TObject);
    function EntredaDeDados(pTitulo, pMensagem: String; Var pValor: String): Boolean;
  public
    { Public declarations }
  end;

var
  ViewPrincipal: TViewPrincipal;

implementation

uses
  Pedido.Controller.Cliente, Pedido.Controller.Produto,
  Pedido.Controller.Pedido, Pedido.Controller.ItensPedido;

{$R *.dfm}

procedure TViewPrincipal.AdicionarProduto;
Var
   I: Integer;
   lTotalItem: Currency;
   lTotalPedido: Currency;
   lValorUnitario: Currency;
   lCodProduto: String;
begin
  if Not ValidarFormulario then
     Exit;

  lCodProduto    := EdtCodProduto.Text;
  lTotalPedido   := ConverterMoeda(EdtTotal.Text);
  lValorUnitario := ConverterMoeda(EdtValorUnitario.Text);
  lTotalItem     := StrToInt(EdtQuantidade.Text) * lValorUnitario;

  if EdtCodProduto.ReadOnly then
  begin
     lTotalPedido := lTotalPedido - ConverterMoeda(STGProduto.Cells[4, FSelecionado]);
     STGProduto.Cells[2, FSelecionado] := EdtQuantidade.Text;
     STGProduto.Cells[3, FSelecionado] := FormatarMoeda(ConverterMoeda(EdtValorUnitario.Text));
     STGProduto.Cells[4, FSelecionado] := FormatarMoeda(lTotalItem);
  end
  else
  begin
     I := STGProduto.RowCount - 1;
     lCodProduto := StringOfChar('0', 4 - Length(lCodProduto)) + lCodProduto;
     STGProduto.Cells[0, I] := lCodProduto;
     STGProduto.Cells[1, I] := FDescricaoProduto;
     STGProduto.Cells[2, I] := EdtQuantidade.Text;
     STGProduto.Cells[3, I] := FormatarMoeda(ConverterMoeda(EdtValorUnitario.Text));
     STGProduto.Cells[4, I] := FormatarMoeda(lTotalItem);
     STGProduto.RowCount := STGProduto.RowCount + 1;
  end;

  EdtTotal.Text := FormatarMoeda(lTotalPedido + lTotalItem);
  EdtCodProduto.Clear;
  EdtQuantidade.Clear;
  FDescricaoProduto     := '';
  EdtValorUnitario.Text := '0,00';
  EdtCodProduto.ReadOnly := False;
  EdtCodProduto.Color   := clWindow;
  EdtCodProduto.SetFocus;
  BtAdicionar.Caption := 'Adicionar [F2]';
  BtAdicionar.ImageIndex := 1;
  LBLDescricao.Visible := False;

end;

procedure TViewPrincipal.AlterarProduto;
begin
   if STGProduto.Cells[0, FSelecionado] = '' then
      Exit;

   FEnterComoTAB := False;
   EdtCodProduto.ReadOnly:= True;
   EdtCodProduto.Color   := clSilver;
   EdtCodProduto.Text    := STGProduto.Cells[0, FSelecionado];
   FDescricaoProduto     := STGProduto.Cells[1, FSelecionado];
   EdtQuantidade.Text    := STGProduto.Cells[2, FSelecionado];
   EdtValorUnitario.Text := STGProduto.Cells[3, FSelecionado];
   EdtQuantidade.SetFocus;
   BtAdicionar.Caption := 'Alterar [F2]';
   BtAdicionar.ImageIndex := 6;
end;

procedure TViewPrincipal.BtAdicionarClick(Sender: TObject);
begin
   AdicionarProduto;
end;

procedure TViewPrincipal.BtBuscarClick(Sender: TObject);
begin
  BuscarPedido;
end;

procedure TViewPrincipal.BtBuscarPedidoClick(Sender: TObject);
begin
   BuscarPedido;
end;

procedure TViewPrincipal.btCancelarPedidoClick(Sender: TObject);
begin
  CancelarPedido;
end;

procedure TViewPrincipal.BtGravarPedidoClick(Sender: TObject);
begin
   GravarPedido;
end;

procedure TViewPrincipal.BtSairClick(Sender: TObject);
begin
   Close;
end;

procedure TViewPrincipal.BuscarCliente;
Var
  lCliente: iCliente;
begin
   FEnterComoTAB := False;
   lCliente := TControllerCliente.New;
   lCliente.Buscar(EdtCodCliente.Text);

   EdtNomeCliente.Text := lCliente.GetNomeCliente;
   if EdtNomeCliente.Text = '' then
   begin
      Showmessage('Cliente Não Encontrado!');
      EdtCodCliente.SetFocus;
      EdtCodCliente.SelectAll;
      Exit;
   end;
   EdtCodProduto.SetFocus;
   BtBuscarPedido.Enabled := False;
   btCancelarPedido.Enabled := False;
end;

procedure TViewPrincipal.BuscarPedido;
Var
   lNumPedido: String;
   lCodProduto: String;
begin
  if Not EntredaDeDados('Buscar Pedido', 'Digite o Número do Pedido: ', lNumPedido) then
     Exit;

  FPedido.Buscar(lNumPedido);

  if FPedido.GetDataSet.IsEmpty then
     Showmessage('Pedido não Encontrado!')
  else
  begin
     With FPedido.GetDataSet do
     begin
        EdtCodCliente.Text := FieldByName('codigo_cliente').AsString;
        EdtNomeCliente.Text := FieldByName('nome').AsString;
        EdtTotal.Text := FormatarMoeda(FieldByName('valor_total_Pedido').AsCurrency);
        while Not EOF do
        begin
           lCodProduto := FieldByName('codigo_produto').AsString;
           lCodProduto := StringOfChar('0', 4 - Length(lCodProduto)) + lCodProduto;
           PopularGrid(lCodProduto + ';' +
                       FieldByName('descricao').AsString + ';' +
                       FieldByName('quantidade').AsString + ';' +
                       FormatarMoeda(FieldByName('valor_unitario').AsCurrency) + ';' +
                       FormatarMoeda(FieldByName('valor_total_item').AsCurrency));
           Next;
        end;
     end;
     BtBuscarPedido.Enabled := False;
     BtCancelarPedido.Enabled := False;
  end;
  EdtCodCliente.SetFocus;
end;

procedure TViewPrincipal.BuscarProduto;
Var
  lProduto: iProduto;
begin
   lProduto := TControllerProduto.New;
   lProduto.Buscar(EdtCodProduto.Text);

   FDescricaoProduto := lProduto.GetDescricaoProduto;
   EdtValorUnitario.Text := FormatarMoeda(lProduto.GetPreco);
   if FDescricaoProduto = '' then
   begin
      Showmessage('Produto Não Encontrado!');
      EdtCodProduto.SetFocus;
      EdtCodProduto.SelectAll;
      Exit;
   end;
   LBLDescricao.Caption := FDescricaoProduto;
   LBLDescricao.Visible := True;
   FEnterComoTAB := True;
end;

procedure TViewPrincipal.CancelarPedido;
Var
   lNumPedido: String;
begin
  if Not EntredaDeDados('Cancelar Pedido', 'Digite o Número do Pedido: ', lNumPedido) then
     Exit;

  if FPedido.Cancelar(lNumPedido) then
     Showmessage('Pedido Cancelado com Sucesso!')
  else
     Showmessage('Pedido Não Encontrado!')
end;

function TViewPrincipal.ConverterMoeda(Value: String): Currency;
begin
   Result := StrToCurrDef(StringReplace(Value, '.', '', [rfReplaceAll]), 0)
end;

procedure TViewPrincipal.EdtCodClienteKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   if Key = VK_RETURN then
      BuscarCliente;
end;

procedure TViewPrincipal.EdtCodProdutoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   if Key = VK_RETURN then
      BuscarProduto;
end;

procedure TViewPrincipal.EdtQuantidadeKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   if Key = VK_RETURN then
      FEnterComoTAB := True;
end;

procedure TViewPrincipal.EdtValorUnitarioEnter(Sender: TObject);
begin
   if Trim(EdtValorUnitario.Text) = '0,00' then
      EdtValorUnitario.Text := ''
   else
      PostMessage(EdtValorUnitario.Handle, EM_SETSEL, 0, Length(EdtValorUnitario.Text))
end;

procedure TViewPrincipal.EdtValorUnitarioExit(Sender: TObject);
begin
   if Trim(EdtValorUnitario.Text) = '' then
      EdtValorUnitario.Text := '0,00';
end;

procedure TViewPrincipal.EdtValorUnitarioKeyPress(Sender: TObject; var Key: Char);
begin
   if Not (CharInSet(Key, ['0'..'9', Chr(8), ','])) then
      Key := #0
end;

procedure TViewPrincipal.EdtValorUnitarioKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
Var
  lTexto: String;
begin
  if (Key in [96..107]) or (Key in [48..57]) then
  begin
      lTexto := FormatarCampoMoeda(EdtValorUnitario.Text);
      EdtValorUnitario.Text := lTexto;
      EdtValorUnitario.SelStart := Length(lTexto);
  end;
end;

function TViewPrincipal.EntredaDeDados(pTitulo, pMensagem: String; var pValor: String): Boolean;
Var
  lFormDialogoEntrada: TForm;
  lTituloEdit: TLabel;
  EdtCampo: TEdit;
  lEditTopo: Integer;
begin
   Result := False;
   lFormDialogoEntrada := TForm.Create(Nil);
   Try
      With lFormDialogoEntrada do
      begin
          Canvas.Font := Font;
          Color := $00EBB99D;
          BorderStyle := bsDialog;
          Caption := pTitulo;
          Position := poOwnerFormCenter;
          Width := 450;
          Height := 230;
          lTituloEdit := TLabel.Create(Nil);
          With lTituloEdit do
          begin
             Parent := lFormDialogoEntrada;
             Caption:= pMensagem;
             Top  := 20;
             Left := 20;
             Width := lFormDialogoEntrada.Width - 50;
             Font.Size := 14;
          end;

          EdtCampo := TEdit.Create(Nil);
          With EdtCampo do
          begin
             Parent := lFormDialogoEntrada;
             AutoSize := False;
             Top := lTituloEdit.Top + 35;
             Left:= 20;
             Height := 30;
             lEditTopo := Top;
             Color := clMoneyGreen;
             Width := lFormDialogoEntrada.Width - 50;
             Text  := pValor;
             SelectAll;
             Font.Name := 'Arial Unicode MS';
             Font.Size := 12;
             NumbersOnly := True;
          end;

          with TButton.Create(lFormDialogoEntrada) do
          begin
            Parent := lFormDialogoEntrada;
            Caption := 'OK';
            ModalResult := mrOk;
            Default := True;
            SetBounds(60, lEditTopo + 65, 145, 45);
            Cursor := crHandPoint;
            Font.Name := 'Arial Unicode MS';
            Font.Size := 14;
          end;

          with TButton.Create(lFormDialogoEntrada) do
          begin
            Parent := lFormDialogoEntrada;
            Caption := '&Cancelar';
            ModalResult := mrCancel;
            Cancel := True;
            SetBounds(230, lEditTopo + 65, 150, 45);
            Cursor := crHandPoint;
            Font.Name := 'Arial Unicode MS';
            Font.Size := 14;
          end;
          while Not Result do
          begin
              ShowModal;
              if ModalResult = mrOk then
              begin
                  if StrToIntDef(EdtCampo.Text, 0) > 0 then
                  begin
                      pValor := EdtCampo.Text;
                      Result := True;
                  end;
              end
              else
                 Break;
          end;
      end;
   Finally
     FreeAndNil(lFormDialogoEntrada);
   End;
end;

function TViewPrincipal.FormatarCampoMoeda(Value: String): String;
Var
   S: String;
begin
      Result := '';
      S := Value;
      S := StringReplace(S,',','',[rfReplaceAll]);
      S := StringReplace(S,'.','',[rfReplaceAll]);
      if Length(s) = 3 then
          s := Copy(s,1,1) + ',' + Copy(S,2,15)
      else
      begin
          if (Length(s) > 3) and (Length(s) < 6) then
             s := Copy(s,1,length(s)-2) + ',' + Copy(S,length(s)-1,15)
          else
          begin
            if (Length(s) >= 6) and (Length(s) < 9) then
               s := Copy(s,1,length(s)-5) + '.' + Copy(s,length(s)-4,3) + ',' + Copy(S,length(s)-1,15)
            else
               if (Length(s) >= 9) and (Length(s) < 12) then
                  s := Copy(s,1,length(s)-8) + '.' + Copy(s,length(s)-7,3) + '.' +
                       Copy(s,length(s)-4,3) + ',' + Copy(S,length(s)-1,15)
               else
                  if (Length(s) >= 12) and (Length(s) < 15)  then
                     s := Copy(s,1,length(s)-11) + '.' + Copy(s,length(s)-10,3) + '.' +
                          Copy(s,length(s)-7,3) + '.' + Copy(s,length(s)-4,3) + ',' + Copy(S,length(s)-1,15);
          end;
      end;
      Result := S;
end;

function TViewPrincipal.FormatarMoeda(Value: Currency): String;
begin
   Result := FormatCurr('###,###,##0.00', Value);
end;

procedure TViewPrincipal.FormCreate(Sender: TObject);
var
  I: Integer;
begin
    FDescricaoProduto := '';
    FSelecionado      := 0;
    FEnterComoTAB     := True;
    FPedido           := TControllerPedido.New;

    for I := 0 to Pred(ComponentCount) do
    begin
       if (Components[I] is TButton) then
          (Components[I] as TButton).Cursor := crHandPoint;

       if (Components[I] is TLabeledEdit) then
       begin
          (Components[I] as TLabeledEdit).OnEnter := MudarCorCampo;
          (Components[I] as TLabeledEdit).OnExit :=  MudarCorCampo;
       end;
    end;

    ReportMemoryLeaksOnShutdown := True;
end;

procedure TViewPrincipal.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   case Key of
      VK_F2 : BtAdicionar.Click;
      VK_F3 : BtSair.Click;
      VK_F4 : BtBuscarPedido.Click;
      VK_F5 : btCancelarPedido.Click;
      VK_F6 : BtGravarPedido.Click;
   end;
end;

procedure TViewPrincipal.FormKeyPress(Sender: TObject; var Key: Char);
begin
    if Key = #13 then
    begin
       Key := #0;
       if FEnterComoTAB then
          Perform(WM_NEXTDLGCTL, 0, 0);
    end;
end;

procedure TViewPrincipal.FormShow(Sender: TObject);
begin
    EdtCodCliente.SetFocus;
end;

procedure TViewPrincipal.GravarPedido;
Var
   I: Integer;
   lItens: iItensPedido;
   lNumPedido: String;
begin
   if STGProduto.RowCount < 3 then
   begin
     Showmessage('Adicione Produtos para Finalizar a Venda!');
     Exit;
   end;

   FPedido.SetCodCliente(StrToInt(EdtCodCliente.Text))
          .SetValorTotal(ConverterMoeda(EdtTotal.Text))
          .LimparItens;

   With STGProduto do
   begin
       for I := 1 to Pred(RowCount) do
       begin
          if Cells[0, I] <> '' then
          begin
              lItens := TControllerItensPedido.New;
              lItens.SetCodProduto(StrToInt(Cells[0, I]))
                    .SetQuantidade(StrToInt(Cells[2, I]))
                    .SetValorUnitario(ConverterMoeda(Cells[3, I]))
                    .SetValorTotal(ConverterMoeda(Cells[4, I]));
              FPedido.AdicionarItem(lItens);
          end;
       end;
   end;

   if FPedido.Gravar then
   begin
      lNumPedido :=  FPedido.GetNumPedido.ToString;
      lNumPedido := StringOfChar('0', 4 - Length(lNumPedido)) + lNumPedido;
      Showmessage('Pedido [No. ' + lNumPedido + '] Gravado com Sucesso!');
      LimparFormulario;
      BtBuscarPedido.Enabled := True;
      btCancelarPedido.Enabled := True;
   end
   else
      Showmessage('Não foi possível Gravar o Pedido!');

   EdtCodCliente.SetFocus;

end;

procedure TViewPrincipal.LimparFormulario;
Var
  I: Integer;
begin
   EdtCodCliente.Clear;
   EdtNomeCliente.Clear;
   EdtCodProduto.Clear;
   EdtQuantidade.Clear;
   FDescricaoProduto := '';
   EdtValorUnitario.Text := '0,00';
   EdtTotal.Text := '0,00';
   LimparGrid;
end;

procedure TViewPrincipal.LimparGrid;
Var
  I: Integer;
begin
   With STGProduto do
   begin
       for I := 1 to Pred(RowCount) do
       begin
          Cells[0, I] := '';
          Cells[1, I] := '';
          Cells[2, I] := '';
          Cells[3, I] := '';
          Cells[4, I] := '';
       end;
       RowCount := 2;
   end;
end;

procedure TViewPrincipal.MudarCorCampo(Sender: TObject);
Var
  lCampo: TLabeledEdit;
begin
    if (Sender is TLabeledEdit) then
    begin
       lCampo := (Sender as TLabeledEdit);
       if lCampo.Color = clWindow then
          lCampo.Color := clMoneyGreen
       else
         lCampo.Color := clWindow;
    end;
end;

procedure TViewPrincipal.PopularGrid(Value: String);
Var
   I: Integer;
   lAux: TStringList;
begin
   lAux := TStringList.Create;
   ExtractStrings([';'], [], PWideChar(Value), lAux);
   try
       With STGProduto do
       begin
           I := RowCount - 1;
           Cells[0, I] := lAux[0];
           Cells[1, I] := lAux[1];
           Cells[2, I] := lAux[2];
           Cells[3, I] := lAux[3];
           Cells[4, I] := lAux[4];
           RowCount := RowCount + 1;
       end;
   finally
      FreeAndNil(lAux);
   end;
end;

procedure TViewPrincipal.RemoverProduto;
Var
  lLista: TStringList;
  I: Integer;
  lTotalItem: String;
  lTotalVenda: Currency;
begin
   if STGProduto.Cells[0, FSelecionado] = '' then
      Exit;

   if MessageDlg('Deseja realmente excluir o Produto: ' + #13#10 +
                  STGProduto.Cells[1, FSelecionado] + '?',
                  mtConfirmation,[mbyes,mbno],0) = 7 then
      Exit;

   STGProduto.Cells[0, FSelecionado] := '';
   lTotalItem := STGProduto.Cells[4, FSelecionado];
   lTotalItem := StringReplace(lTotalItem, '.', '', [rfReplaceAll]);
   lTotalVenda := StrToCurrDef(StringReplace(EdtTotal.Text, '.', '', [rfReplaceAll]), 0);
   EdtTotal.Text := FormatarMoeda(lTotalVenda - StrToCurrDef(lTotalItem, 0));

   lLista := TStringList.Create;
   try
       for I := 1 to Pred(STGProduto.RowCount) do
       begin
          if STGProduto.Cells[0, I] <> '' then
             lLista.Append(STGProduto.Cells[0, I] + ';' +
                           STGProduto.Cells[1, I] + ';' +
                           STGProduto.Cells[2, I] + ';' +
                           STGProduto.Cells[3, I] + ';' +
                           STGProduto.Cells[4, I]);
       end;

       LimparGrid;

       for I := 0 to Pred(lLista.Count) do
           PopularGrid(lLista[I]);
   finally
      FreeAndNil(lLista);
      FSelecionado := 0;
   end;

   Showmessage('Produto Excluido com Sucesso!');

end;

procedure TViewPrincipal.STGProdutoDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect;
  State: TGridDrawState);
var
  lDelta: Integer;
  lTexto: String;
  WidthOfText: integer;
  WidthOfCell: integer;
  LeftOffset: integer;
begin
  STGProduto.Brush.Color := clGreen;
  STGProduto.Font.Color := clBlue;
  STGProduto.Font.Size  := 16;

  With STGProduto do
  begin
     if ARow = 0 then
     begin
        Canvas.Font.Size  := 12;
        Canvas.Brush.Color := clBtnFace;

        case ACol of
           0: begin
                 lTexto := 'Código';
                 Canvas.TextRect(Rect, Rect.Left , Rect.Top +2, lTexto);
              end;

           1: begin
                 lTexto := 'Descrição';
                 Canvas.TextRect(Rect, Rect.Left , Rect.Top +2, lTexto);
              end;

           2: begin
                 lTexto := 'Qtd';
                 WidthOfText := Canvas.TextWidth(lTexto);
                 WidthOfCell := ColWidths[ACol];
                 LeftOffset := WidthOfCell - WidthOfText -5;
                 Canvas.TextRect(Rect, Rect.Left + LeftOffset, Rect.Top +2, lTexto);
              end;

           3: begin
                 lTexto := 'Vl. Unitário';
                 WidthOfText := Canvas.TextWidth(lTexto);
                 WidthOfCell := ColWidths[ACol];
                 LeftOffset := WidthOfCell - WidthOfText -5;
                 Canvas.TextRect(Rect, Rect.Left + LeftOffset, Rect.Top +2, lTexto);
              end;

           4: begin
                 lTexto := 'Vl. Total';
                 WidthOfText := Canvas.TextWidth(lTexto);
                 WidthOfCell := ColWidths[ACol];
                 LeftOffset := WidthOfCell - WidthOfText -5;
                 Canvas.TextRect(Rect, Rect.Left + LeftOffset, Rect.Top +2, lTexto);
              end;
        end;
     end
     else
     begin
        Canvas.Font.Size  := 10;
        Canvas.Brush.Color := clWhite;
        lTexto := Cells[ACol,ARow];
        if ACol <= 1 then
           Canvas.TextRect(Rect, Rect.Left , Rect.Top +2, lTexto)
        else
        begin
           WidthOfText := Canvas.TextWidth(lTexto);
           WidthOfCell := ColWidths[ACol];
           LeftOffset := WidthOfCell - WidthOfText -5;
           Canvas.TextRect(Rect, Rect.Left + LeftOffset, Rect.Top +2, lTexto);
        end;

        if FSelecionado > 0 then
        begin
            if gdSelected  in State then
            begin
                with STGProduto.Canvas do
                begin
                    Brush.Color := clSkyBlue;
                    FillRect(Rect);
                    if ACol <= 1 then
                       TextOut(Rect.Left, Rect.Top +2, lTexto)
                    else
                       TextOut(Rect.Left + LeftOffset, Rect.Top +2, lTexto);
                end;
            end;
        end;
     end;
  end;

end;

procedure TViewPrincipal.STGProdutoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   if Key = VK_DELETE then
      RemoverProduto;

   if Key = VK_RETURN then
      AlterarProduto;
end;

procedure TViewPrincipal.STGProdutoSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
   FSelecionado := ARow;
end;

function TViewPrincipal.ValidarFormulario: Boolean;
begin
   Result := False;

   if Trim(EdtNomeCliente.Text) = '' then
   begin
      Showmessage('Selecione um Cliente para realizar a venda!');
      EdtNomeCliente.SetFocus;
      Exit;
   end;

   if FDescricaoProduto = '' then
   begin
      Showmessage('Informe um produto para Adicionar!');
      EdtCodProduto.SetFocus;
      Exit;
   end;

   if StrToIntDef(EdtQuantidade.Text, 0) = 0 then
   begin
      Showmessage('Informe a quantidade do Produto!');
      EdtQuantidade.SetFocus;
      Exit;
   end;

   if Trim(EdtValorUnitario.Text) = '0,00' then
   begin
      Showmessage('O Campo Preço não pode ser ZERO!');
      EdtValorUnitario.SetFocus;
      Exit;
   end;
   Result := True;
end;

end.
