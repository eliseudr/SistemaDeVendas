unit unSQLHelpers;

interface

uses
  FireDAC.Comp.Client, Data.DB, Vcl.DBGrids;

procedure popularDBGridVendas(var AFDQuery: TFDQuery; var ADataSource: TDataSource; var ADBGrid: TDBGrid; NomeTable: string);

implementation

uses unDMdados;

procedure popularDBGridVendas(var AFDQuery: TFDQuery;
  var ADataSource: TDataSource; var ADBGrid: TDBGrid; NomeTable: string);
begin
  with AFDQuery do
  begin
    Connection := dmDados.FDConnection;
    Active := False;
    SQL.Clear;

    SQL.Add('SELECT * FROM ' + NomeTable);

    Open;
  end;

  AFDQuery.FilterOptions := [foCaseInsensitive];
  ADataSource.DataSet := AFDQuery;
  ADBGrid.DataSource := ADataSource;
end;

end.
