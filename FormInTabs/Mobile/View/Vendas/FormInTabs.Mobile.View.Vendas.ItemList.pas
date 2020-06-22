unit FormInTabs.Mobile.View.Vendas.ItemList;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FormInTabs.Mobile.View.FrameItemListModel, FMX.Objects, FMX.Layouts,
  FMX.Controls.Presentation;

type
  TfilVenda = class(TFrameItemListModel)
    lblCliente: TLabel;
    lytInfo: TLayout;
    lblData: TLabel;
    lblVlrTotal: TLabel;
    lblDesconto: TLabel;
    procedure FramePainting(Sender: TObject; Canvas: TCanvas;
      const ARect: TRectF);
  private
    FVlrTotal: Currency;
    FDataHora: TDateTime;
    FCliente: string;
    FVlrDesconto: Currency;
    procedure SetCliente(const Value: string);
    procedure SetDataHora(const Value: TDateTime);
    procedure SetVlrDesconto(const Value: Currency);
    procedure SetVlrTotal(const Value: Currency);
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property Cliente: string read FCliente write SetCliente;
    property DataHora: TDateTime read FDataHora write SetDataHora;
    property VlrDesconto: Currency read FVlrDesconto write SetVlrDesconto;
    property VlrTotal: Currency read FVlrTotal write SetVlrTotal;
    { Public declarations }
  end;

var
  filVenda: TfilVenda;

implementation

{$R *.fmx}

{ TfilVenda }

constructor TfilVenda.Create(AOwner: TComponent);
begin
  inherited;
  lblCliente.Text := EmptyStr;
  lblData.Text := EmptyStr;
  lblVlrTotal.Text := EmptyStr;
  lblDesconto.Text := EmptyStr;
  FCliente := EmptyStr;
  FDataHora := Now;
  FVlrDesconto := 0;
  FVlrTotal := 0;
  lytBackground.Visible := False;
end;

destructor TfilVenda.Destroy;
begin

  inherited;
end;

procedure TfilVenda.FramePainting(Sender: TObject; Canvas: TCanvas;
  const ARect: TRectF);
begin
  inherited;
  if Self.Tag <> 0 then
    Exit;
  Self.Tag := 1;
  lytBackground.Visible := True;
end;

procedure TfilVenda.SetCliente(const Value: string);
begin
  FCliente := Value;
  lblCliente.Text := Value;
end;

procedure TfilVenda.SetDataHora(const Value: TDateTime);
begin
  FDataHora := Value;
  lblData.Text := FormatDateTime('dd/mm/yyyy', Value);
end;

procedure TfilVenda.SetVlrDesconto(const Value: Currency);
begin
  FVlrDesconto := Value;
  lblDesconto.Text := FormatFloat('0.,00', Value);
end;

procedure TfilVenda.SetVlrTotal(const Value: Currency);
begin
  FVlrTotal := Value;
  lblVlrTotal.Text := FormatFloat('0.,00', Value);
end;

end.
