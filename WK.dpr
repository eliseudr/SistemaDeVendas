program WK;

uses
  Vcl.Forms,
  unDMdados in 'unDMdados.pas' {dmDados: TFrame},
  unVendas in 'unVendas.pas' {FrmVendas},
  unInserirVenda in 'unInserirVenda.pas' {FrmInserirVenda},
  unSQLHelpers in 'unSQLHelpers.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Sistema de venda';
  Application.CreateForm(TdmDados, dmDados);
  Application.CreateForm(TFrmVendas, FrmVendas);
  Application.Run;
end.
