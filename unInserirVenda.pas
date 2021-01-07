unit unInserirVenda;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.StdCtrls, Vcl.Grids,
  Vcl.DBGrids, Vcl.DBCtrls, Vcl.ExtCtrls, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.ComCtrls;

type
  TFrmInserirVenda = class(TForm)
    pnlTop: TPanel;
    pnlBottom: TPanel;
    lblCliente: TLabel;
    lblNome: TLabel;
    edtNome: TEdit;
    lblCidade: TLabel;
    lblUf: TLabel;
    edtCidade: TEdit;
    edtUf: TEdit;
    lblProdutos: TLabel;
    lblProduto: TLabel;
    btnInserir: TButton;
    btnFinalizar: TButton;
    edtDescricaoProduto: TEdit;
    lblqtd: TLabel;
    edtQtd: TEdit;
    lblValorUnidade: TLabel;
    edtVlr: TEdit;
    lblVlrTotal: TLabel;
    edtVlrTotal: TEdit;
    btnInserirCliente: TButton;
    dsTmpVendaProdutos: TDataSource;
    qryTmpVendaProdutos: TFDQuery;
    dsClientes: TDataSource;
    qryClientes: TFDQuery;
    dsProdutos: TDataSource;
    qryProdutos: TFDQuery;
    statValorTotal: TStatusBar;
    dbgrdVendaAtual: TDBGrid;
    procedure btnInserirClick(Sender: TObject);
    procedure SalvarVenda;
    procedure SalvarCliente;
    procedure SomarValorStatusBar;
    procedure btnInserirClienteClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnFinalizarClick(Sender: TObject);
    procedure AjustarDbgrdVendaAtual(ADBGrid: TDBGrid);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmInserirVenda: TFrmInserirVenda;

implementation

{$R *.dfm}

uses unVendas, unSQLHelpers, unDMdados;

procedure TFrmInserirVenda.btnFinalizarClick(Sender: TObject);
begin
  //Gravar dados na table venda_produtos

  //Limpar TEMP
  LimparTemp(qryTmpVendaProdutos, dsTmpVendaProdutos, 'temp_venda_produtos');
end;

procedure TFrmInserirVenda.btnInserirClick(Sender: TObject);
begin
  SalvarVenda;
  SomarValorStatusBar;
end;

procedure TFrmInserirVenda.btnInserirClienteClick(Sender: TObject);
begin
  SalvarCliente;
end;


procedure TFrmInserirVenda.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //Limpar table temp apos fechar janela
  LimparTemp(qryTmpVendaProdutos, dsTmpVendaProdutos, 'temp_venda_produtos');

  Action := caFree;
  Release;
  FrmInserirVenda := nil;
end;

procedure TFrmInserirVenda.FormCreate(Sender: TObject);
begin
  PopularQry(qryClientes, dsClientes, 'clientes');
  PopularQry(qryProdutos, dsProdutos, 'produtos');
end;


procedure TFrmInserirVenda.SalvarCliente;
var
  NomeCliente, CidadeCliente, UFCliente: string;
begin
  // Levantar erros (CAMPOS VAZIOS)
    if (edtNome.Text = '') or (edtUf.Text = '') or (edtCidade.Text = '') then
      raise Exception.Create('Preencher campos');

    //Capturar campos
    NomeCliente   := edtNome.Text;
    CidadeCliente := edtCidade.Text;
    UFCliente     := edtUf.Text;

    //SQL
    InserirCliente(NomeCliente, CidadeCliente, UFCliente);
end;

procedure TFrmInserirVenda.SalvarVenda;
var
  IDCliente, IDProduto: Integer;
  NomeProduto: string;
  Quantidade, ValorUn, ValorTotal: Double;
begin
  // Levantar erros (CAMPOS VAZIOS)
  if (edtDescricaoProduto.Text = '') or (edtQtd.Text = '') or (edtVlr.Text = '' ) then
    raise Exception.Create('Preencher campos');

  //Capturar campos
  NomeProduto   := edtDescricaoProduto.Text;
  Quantidade    := StrToFloat(edtQtd.Text);
  ValorUn       := StrToFloat(edtVlr.Text);
  ValorTotal    := (ValorUn*Quantidade);
  IDCliente     := qryClientes.FieldByName('id').AsInteger;
  IDProduto     := qryProdutos.FieldByName('id').AsInteger;

  //SQL
  //Como o sistema nao tera cadastro, assim ja sera criado o registro na table
  InserirProduto(NomeProduto, ValorUn);
  //Insere na TEMP para exibir no DBGRID
  InserirTempVendaProdutos(NomeProduto, ValorUn, ValorTotal, IDCliente, IDProduto);

  //Popular DBGRID
  PopularDBGridTempVendasProdutos(qryTmpVendaProdutos, dsTmpVendaProdutos, dbgrdVendaAtual, 'temp_venda_produtos');
  AjustarDbgrdVendaAtual(dbgrdVendaAtual);
end;

procedure TFrmInserirVenda.SomarValorStatusBar;
var
  ValorTotal: Double;
begin
  ValorTotal := SomarValorTemp(qryTmpVendaProdutos, dsTmpVendaProdutos, 'temp_venda_produtos');
  statValorTotal.Panels[0].Text := 'Valor total de venda: ' + FloatToStr(ValorTotal);
end;

procedure TFrmInserirVenda.AjustarDbgrdVendaAtual(ADBGrid: TDBGrid);
begin
  ADBGrid.Columns[0].Width := 60;
  ADBGrid.Columns[1].Width := 160;
  ADBGrid.Columns[2].Width := 80;
  ADBGrid.Columns[3].Width := 80;
  ADBGrid.Columns[4].Width := 80;
  ADBGrid.Columns[5].Width := 80;
end;

end.
