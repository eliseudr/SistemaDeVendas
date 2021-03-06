unit unSQLHelpers;

interface

uses
  FireDAC.Comp.Client, Data.DB, Vcl.DBGrids, System.SysUtils;

function SomarValorTemp(var AFDQuery: TFDQuery; var ADataSource: TDataSource; NomeTable: string): Double;
function BuscarID(var AFDQuery: TFDQuery; var ADataSource: TDataSource; NomeTable, Nome: string): Integer;
function BuscarIDVendas(var AFDQuery: TFDQuery; var ADataSource: TDataSource): Integer;
function FormatarValorMonetario(Valor: Double): string;

procedure PopularDBGridTempVendasProdutos(var AFDQuery: TFDQuery; var ADataSource: TDataSource; var ADBGrid: TDBGrid; NomeTable: string);
procedure popularDBGridVendas(var AFDQuery: TFDQuery; var ADataSource: TDataSource; var ADBGrid: TDBGrid; NomeTable: string);
procedure InserirCliente(NomeCliente, CidadeCliente, UFCliente: string);
procedure InserirProduto(NomeProduto: string; ValorUn: Double);
procedure InserirVendas(var AFDQuery: TFDQuery; var ADataSource: TDataSource; ValorTotal: Double; IDCliente: Integer);
procedure InserirTempVendaProdutos(NomeProduto: string; ValorUn, ValorTotal: Double;IDCliente, IDProduto: Integer);
procedure InserirVendaProdutos(var AFDQuery: TFDQuery; var ADataSource: TDataSource; IDVenda: Integer);
procedure CloseQuery(AQuery: TFDQuery);
procedure LimparTemp(var AFDQuery: TFDQuery; var ADataSource: TDataSource; NomeTable: string);
procedure PopularQry(var AFDQuery: TFDQuery; var ADataSource: TDataSource; NomeTable: string);

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


procedure PopularDBGridTempVendasProdutos(var AFDQuery: TFDQuery;
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

procedure PopularQry(var AFDQuery: TFDQuery; var ADataSource: TDataSource; NomeTable: string);
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
end;

{Insere um novo Cliente na table `clientes`.}
procedure InserirCliente(NomeCliente, CidadeCliente, UFCliente: string);
var
  qryInserir: TFDQuery;
begin
  qryInserir := TFDQuery.Create(nil);
  with qryInserir do
  begin
    Connection := dmDados.FDConnection;
    Active := False;
    SQL.Clear;

    SQL.Add('INSERT INTO clientes');
    SQL.Add('(nome,');
    SQL.Add(' cidade, ');
    SQL.Add(' uf)');
    SQL.Add('VALUES (:nome, ');
    SQL.Add(':cidade,');
    SQL.Add(':uf)');

    Params[0].AsString := NomeCliente;
    Params[1].AsString := CidadeCliente;
    Params[2].AsString := UFCliente;

    try
      ExecSQL;
    finally
      CloseQuery(qryInserir);
    end;
  end;
end;


{Insere um novo Produto na table `Produtos`.}
procedure InserirProduto(NomeProduto: string; ValorUn: Double);
var
  qryInserir: TFDQuery;
begin
  qryInserir := TFDQuery.Create(nil);
  with qryInserir do
  begin
    Connection := dmDados.FDConnection;
    Active := False;
    SQL.Clear;

    SQL.Add('INSERT INTO produtos');
    SQL.Add('(nome,');
    SQL.Add(' preco_venda) ');
    SQL.Add('VALUES (:nome, ');
    SQL.Add(':preco_venda)');

    Params[0].AsString := NomeProduto;
    Params[1].AsFloat := ValorUn;

    try
      ExecSQL;
    finally
      CloseQuery(qryInserir);
    end;
  end;
end;

procedure InserirVendas(var AFDQuery: TFDQuery; var ADataSource: TDataSource;
  ValorTotal: Double; IDCliente: Integer);
var
  qryInserir: TFDQuery;
begin
  qryInserir := TFDQuery.Create(nil);
  with qryInserir do
  begin
    Connection := dmDados.FDConnection;
    Active := False;
    SQL.Clear;

    SQL.Add('INSERT INTO vendas ');
    SQL.Add('(valor_total,');
    SQL.Add(' id_cliente)');
    SQL.Add('VALUES (:valor_total, ');
    SQL.Add(':id_cliente)');

    Params[0].AsFloat := ValorTotal;
    Params[1].AsInteger := IDCliente;

    try
      ExecSQL;
    finally
      CloseQuery(qryInserir);
    end;
  end;
end;

{Insere um novo os produtos da venda na table definitiva `venda_produtos`.}
procedure InserirVendaProdutos(var AFDQuery: TFDQuery; var ADataSource: TDataSource; IDVenda: Integer);
var
  qryInserir, qryPesquisar: TFDQuery;
begin
  qryPesquisar := TFDQuery.Create(nil);
  with qryPesquisar do
  begin
    Connection := dmDados.FDConnection;
    Active := False;
    SQL.Clear;

    Open('SELECT * FROM temp_venda_produtos');
  end;

  qryInserir := TFDQuery.Create(nil);
  with qryPesquisar do
  begin
    First;
    while not Eof do
    begin
      FieldByName('descricao').AsString;
      FieldByName('valor_unidade').AsFloat;
      FieldByName('valor_total').AsFloat;
      FieldByName('id_cliente').AsInteger;
      FieldByName('id_produto').AsInteger;

      qryInserir:= TFDQuery.Create(nil);
      with qryInserir do
      begin
        Connection := dmDados.FDConnection;
        Active := False;
        SQL.Clear;

        SQL.Add('INSERT INTO venda_produtos');
        SQL.Add('(descricao,');
        SQL.Add(' valor_unidade, ');
        SQL.Add(' valor_total, ');
        SQL.Add(' id_cliente, ');
        SQL.Add(' id_produto, ');
        SQL.Add(' id_venda) ');
        SQL.Add('VALUES (:descricao, ');
        SQL.Add(':valor_unidade,');
        SQL.Add(':valor_total,');
        SQL.Add(':id_cliente,');
        SQL.Add(':id_produto,');
        SQL.Add(':id_venda)');

        Params[0].AsString := qryPesquisar.FieldByName('descricao').AsString;
        Params[1].AsFloat := qryPesquisar.FieldByName('valor_unidade').AsFloat;
        Params[2].AsFloat := qryPesquisar.FieldByName('valor_total').AsFloat;
        Params[3].AsInteger := qryPesquisar.FieldByName('id_cliente').AsInteger;
        Params[4].AsInteger := qryPesquisar.FieldByName('id_produto').AsInteger;
        Params[5].AsInteger := IDVenda;

        try
          ExecSQL;
        finally
          CloseQuery(qryInserir);
        end;
      end;

      Next;
    end;
  end;
end;

{Insere um arquivo temporario na table `temp_venda_produtos` sem IDVendas, Quando
finalizar venda, Sera inserido primeiro na table vendas e depois na VendaProdutos junto com o IDVendas(FK)}
procedure InserirTempVendaProdutos(NomeProduto: string; ValorUn, ValorTotal: Double;
   IDCliente, IDProduto: Integer);
var
  qryInserir: TFDQuery;
begin
  qryInserir := TFDQuery.Create(nil);
  with qryInserir do
  begin
    Connection := dmDados.FDConnection;
    Active := False;
    SQL.Clear;

    SQL.Add('INSERT INTO temp_venda_produtos');
    SQL.Add('(descricao,');
    SQL.Add(' valor_unidade, ');
    SQL.Add(' valor_total, ');
    SQL.Add(' id_cliente, ');
    SQL.Add(' id_produto) ');
    SQL.Add('VALUES (:descricao, ');
    SQL.Add(':valor_unidade,');
    SQL.Add(':valor_total,');
    SQL.Add(':id_cliente,');
    SQL.Add(':id_produto)');

    Params[0].AsString := NomeProduto;
    Params[1].AsFloat := ValorUn;
    Params[2].AsFloat := ValorTotal;
    Params[3].AsInteger := IDCliente;
    Params[4].AsInteger := IDProduto;

    try
      ExecSQL;
    finally
      CloseQuery(qryInserir);
    end;
  end;
end;

procedure LimparTemp(var AFDQuery: TFDQuery; var ADataSource: TDataSource; NomeTable: string);
begin
  with AFDQuery do
  begin
    Connection := dmDados.FDConnection;
    Active := False;
    SQL.Clear;

    SQL.Add('DELETE FROM ' + NomeTable);

    try
      ExecSQL;
    finally
      CloseQuery(AFDQuery);
    end;
  end;

  AFDQuery.FilterOptions := [foCaseInsensitive];
  ADataSource.DataSet := AFDQuery;
end;

procedure CloseQuery(AQuery: TFDQuery);
begin
  AQuery.Close;
  AQuery := nil;
end;

{ Soma todos os valores do campo `valor_total` na table `temp_venda_produtos`. }
function SomarValorTemp(var AFDQuery: TFDQuery; var ADataSource: TDataSource; NomeTable: string): Double;
var
  qrySoma: TFDQuery;
begin
  qrySoma := TFDQuery.Create(nil);
  with qrySoma do
  begin
    Connection := dmDados.FDConnection;
    Active := False;
    SQL.Clear;
    SQL.Add('SELECT SUM(valor_total) AS valor_total FROM ' + NomeTable);

    try
      Open;
      Result := qrySoma.FieldByName('valor_total').AsFloat;
    finally
      CloseQuery(qrySoma);
    end;
  end;
end;

function BuscarID(var AFDQuery: TFDQuery; var ADataSource: TDataSource; NomeTable, Nome: string): Integer;
begin
 with AFDQuery do
  begin
    Connection := dmDados.FDConnection;
    Active := False;
    SQL.Clear;

    SQL.Add('SELECT id FROM ' + NomeTable + ' WHERE nome = "' + Nome + '"');

     try
      Open;
      Result := AFDQuery.FieldByName('id').AsInteger;
    finally
      CloseQuery(AFDQuery);
    end;
  end;
end;

function BuscarIDVendas(var AFDQuery: TFDQuery; var ADataSource: TDataSource): Integer;
begin
 with AFDQuery do
  begin
    Connection := dmDados.FDConnection;
    Active := False;
    SQL.Clear;

    SQL.Add('SELECT id FROM vendas');

     try
      Open;
      Result := AFDQuery.FieldByName('id').AsInteger;
    finally
      CloseQuery(AFDQuery);
    end;
  end;
end;

function FormatarValorMonetario(Valor: Double): string;
begin
  Result := FormatFloat('#,##0.00',Valor);
end;

end.
