unit FormInTabs.Mobile.View.Vendas.Lista;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FormInTabs.Mobile.View.FormModel, FMX.Layouts, FMX.Objects,
  FMX.Controls.Presentation, FMX.TabControl;

type
  TFormVendaLista = class(TFormModel)
    procedure btnHeaderRightClick(Sender: TObject);
    procedure lytBackgroundPainting(Sender: TObject; Canvas: TCanvas;
      const ARect: TRectF);
  private
    procedure FilList(const AClearList: Boolean = True);
    procedure ItemListClick(Sender: TObject);
    procedure ItemListTap(Sender: TObject; const Point: TPointF);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormVendaLista: TFormVendaLista;

implementation

uses
  FormInTabs.Mobile.View.Vendas.Crud,
  FormInTabs.Lib.Utils,
  FormInTabs.Mobile.View.Vendas.ItemList;

{$R *.fmx}

procedure TFormVendaLista.btnHeaderRightClick(Sender: TObject);
begin
  inherited;
  //OpenForm(TFormVendaCrud);
  FilList;
end;

procedure TFormVendaLista.FilList(const AClearList: Boolean);
begin
  TUtils.ThreadCustom( //
    procedure
    begin // OnShow
      TUtils.LoadingShow(lytBackground, 'Aguarde');
      vtsList.BeginUpdate;
      if AClearList then
        FObjList.Clear;
    end, //
    procedure
    var
      i: Integer;
      LFil: TfilVenda;
    begin // OnProcess
      // Processo de pegar dados (Open, GetSever)

      for i := 0 to 50 do
      begin
        LFil := TfilVenda.Create(vtsList);
        FObjList.Add(LFil);
        LFil.Name := LFil.ClassName + vtsList.Content.ChildrenCount.ToString;
        LFil.Align := TAlignLayout.Top;
        LFil.Identify := vtsList.Content.ChildrenCount.ToString;

        LFil.Cliente := 'Cliente';
        LFil.DataHora := Now;
        LFil.VlrDesconto := 0;
        LFil.VlrTotal := 0;

        vtsList.AddObject(LFil);

        LFil.Position.Y := vtsList.Content.ChildrenCount * LFil.Height;
{$IFDEF MSWINDOWS}
        LFil.SetDefaultClick(ItemListClick);
{$ELSE}
        LFil.SetDefaultTap(ItemListTap);
{$ENDIF}
      end;
    end, //
    procedure
    begin // OnComplete
      vtsList.EndUpdate;
      TUtils.LoadignHide;
    end, //
    procedure(const AValue: string)
    begin // OnError
      vtsList.EndUpdate;
      TUtils.LoadignHide;
      ShowMessage(AValue);
    end, //
    False //
    );
end;

procedure TFormVendaLista.ItemListClick(Sender: TObject);
var
  LFil: TfilVenda;
begin
  LFil := TFmxObject(Sender).Owner as TfilVenda;
  ShowMessage(LFil.Identify);
  // Open baseado no Identify e abrir o Crud
end;

procedure TFormVendaLista.ItemListTap(Sender: TObject; const Point: TPointF);
begin
  ItemListClick(Sender);
end;

procedure TFormVendaLista.lytBackgroundPainting(Sender: TObject;
  Canvas: TCanvas; const ARect: TRectF);
begin
  inherited;
  if lytBackground.Tag <> 0 then
    Exit;
  lytBackground.Tag := 1;
  FilList();
end;

end.
