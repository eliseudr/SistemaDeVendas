object FrmInserirVenda: TFrmInserirVenda
  Left = 0
  Top = 0
  Caption = 'FrmInserirVenda'
  ClientHeight = 670
  ClientWidth = 656
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 656
    Height = 193
    Align = alTop
    Color = clWindow
    ParentBackground = False
    TabOrder = 0
    ExplicitWidth = 649
    object lblCliente: TLabel
      Left = 24
      Top = 8
      Width = 162
      Height = 19
      Caption = 'DADOS DO CLIENTE'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblNome: TLabel
      Left = 24
      Top = 48
      Width = 38
      Height = 16
      Caption = 'Nome:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lblCidade: TLabel
      Left = 24
      Top = 96
      Width = 44
      Height = 16
      Caption = 'Cidade:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lblUf: TLabel
      Left = 264
      Top = 96
      Width = 43
      Height = 16
      Caption = 'Estado:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object edtNome: TEdit
      Left = 68
      Top = 47
      Width = 410
      Height = 21
      TabOrder = 0
    end
    object edtCidade: TEdit
      Left = 68
      Top = 95
      Width = 165
      Height = 21
      TabOrder = 1
    end
    object edtUf: TEdit
      Left = 313
      Top = 95
      Width = 165
      Height = 21
      TabOrder = 2
    end
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 193
    Width = 656
    Height = 160
    Align = alClient
    Color = clWindow
    ParentBackground = False
    TabOrder = 1
    ExplicitWidth = 580
    ExplicitHeight = 476
    object lblProdutos: TLabel
      Left = 24
      Top = 16
      Width = 174
      Height = 17
      Caption = 'DADOS DO PRODUTO'#13#10
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblProduto: TLabel
      Left = 24
      Top = 55
      Width = 119
      Height = 16
      Caption = 'Selecione o produto:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object dblkcbbProdutos: TDBLookupComboBox
      Left = 24
      Top = 77
      Width = 454
      Height = 21
      TabOrder = 0
    end
    object btnInserir: TButton
      Left = 24
      Top = 104
      Width = 87
      Height = 25
      Caption = 'Inserir Produto'
      TabOrder = 1
    end
    object btnFinalizar: TButton
      Left = 528
      Top = 105
      Width = 87
      Height = 25
      Caption = 'Finalizar Venda'
      TabOrder = 2
    end
  end
  object dbgrdVendaAtual: TDBGrid
    Left = 0
    Top = 353
    Width = 656
    Height = 317
    Align = alBottom
    TabOrder = 2
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
end