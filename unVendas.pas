unit unVendas;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  System.ImageList, Vcl.ImgList, Vcl.ComCtrls, Vcl.ToolWin,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.Grids, Vcl.DBGrids,
  Vcl.ExtCtrls;

type
  TFrmVendas = class(TForm)
    pnlBackground: TPanel;
    pnlToolBar: TPanel;
    dbgrdVendas: TDBGrid;
    dsVendas: TDataSource;
    qryVendas: TFDQuery;
    tlbBotoes: TToolBar;
    btnInseriVenda: TToolButton;
    imageList: TImageList;
    btnAtualizar: TToolButton;
    procedure btnInseriVendaClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnAtualizarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmVendas: TFrmVendas;

implementation

{$R *.dfm}

uses unInserirVenda, unSQLHelpers;

procedure TFrmVendas.btnAtualizarClick(Sender: TObject);
begin
  qryVendas.Refresh;
end;

procedure TFrmVendas.btnInseriVendaClick(Sender: TObject);
begin
  FrmInserirVenda := TFrmInserirVenda.Create(Application);
  FrmInserirVenda.ShowModal;
end;

procedure TFrmVendas.FormCreate(Sender: TObject);
begin
  popularDBGridVendas(qryVendas, dsVendas, dbgrdVendas, 'vendas');
end;

end.
