object Form1: TForm1
  Left = 320
  Top = 231
  Width = 814
  Height = 369
  Caption = 'Duyuru'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Linus'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object Label3: TLabel
    Left = 8
    Top = 240
    Width = 90
    Height = 16
    Caption = 'Mesaj Ba'#351'l'#305#287#305' : '
  end
  object Label4: TLabel
    Left = 8
    Top = 264
    Width = 85
    Height = 16
    Caption = 'Mesaj '#304#231'eri'#287'i : '
  end
  object Label1: TLabel
    Left = 20
    Top = 25
    Width = 236
    Height = 16
    Caption = 'Duyuru G'#246'nderilecek Bilgisayar Listesi : '
  end
  object Label2: TLabel
    Left = 580
    Top = 25
    Width = 137
    Height = 16
    Caption = 'Duyuru '#304'letilen Siciller : '
  end
  object Label5: TLabel
    Left = 16
    Top = 208
    Width = 60
    Height = 16
    Caption = 'Toplam : 0'
  end
  object Edit1: TEdit
    Left = 104
    Top = 232
    Width = 449
    Height = 24
    TabOrder = 0
  end
  object Edit2: TEdit
    Left = 104
    Top = 264
    Width = 449
    Height = 24
    TabOrder = 1
  end
  object Button3: TButton
    Left = 464
    Top = 296
    Width = 75
    Height = 25
    Caption = 'G'#246'nder'
    TabOrder = 2
    OnClick = Button3Click
  end
  object Memo1: TMemo
    Left = 16
    Top = 48
    Width = 537
    Height = 145
    Enabled = False
    TabOrder = 3
    OnChange = Memo1Change
  end
  object Memo2: TMemo
    Left = 8
    Top = 328
    Width = 377
    Height = 129
    Lines.Strings = (
      'Memo2')
    TabOrder = 4
    Visible = False
  end
  object Memo3: TMemo
    Left = 352
    Top = 328
    Width = 377
    Height = 129
    Lines.Strings = (
      'Memo3')
    TabOrder = 5
    Visible = False
  end
  object ListBox1: TListBox
    Left = 568
    Top = 48
    Width = 185
    Height = 241
    ItemHeight = 16
    PopupMenu = PopupMenu1
    TabOrder = 6
  end
  object Button1: TButton
    Left = 368
    Top = 200
    Width = 179
    Height = 25
    Caption = 'Otomatik Olarak '#199'ek'
    TabOrder = 7
    OnClick = Button1Click
  end
  object PopupMenu1: TPopupMenu
    Left = 456
    Top = 8
    object L1: TMenuItem
      Caption = 'Listeyi Kaydet'
      OnClick = L1Click
    end
  end
  object SaveDialog1: TSaveDialog
    Left = 392
    Top = 16
  end
  object dlgOpen1: TOpenDialog
    Left = 744
    Top = 296
  end
end
