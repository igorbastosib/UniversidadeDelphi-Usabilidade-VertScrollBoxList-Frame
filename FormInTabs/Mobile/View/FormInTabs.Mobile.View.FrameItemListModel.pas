unit FormInTabs.Mobile.View.FrameItemListModel;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Layouts, System.UIConsts;

type
  TFrameItemListModel = class(TFrame)
    lytBackground: TLayout;
    rctBackground: TRectangle;
    rctClient: TRectangle;
    lneBottom: TLine;
  private
    FIdentify: string;
    procedure SetIdentify(const Value: string);
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property Identify: string read FIdentify write SetIdentify;

    procedure SetRctBackgroundColor(const AColor: string);
    procedure SetRctClientColor(const AColor: string);
    procedure SetDefaultClick(AEvent: TNotifyEvent);
    procedure SetDefaultTap(AEvent: TTapEvent);
    { Public declarations }
  end;

implementation

{$R *.fmx}

{ TFrameItemListModel }

constructor TFrameItemListModel.Create(AOwner: TComponent);
begin
  inherited;
  FIdentify := EmptyStr;
end;

destructor TFrameItemListModel.Destroy;
begin

  inherited;
end;

procedure TFrameItemListModel.SetDefaultClick(AEvent: TNotifyEvent);
begin
  rctBackground.OnClick := AEvent;
end;

procedure TFrameItemListModel.SetDefaultTap(AEvent: TTapEvent);
begin
  rctBackground.OnTap := AEvent;
end;

procedure TFrameItemListModel.SetIdentify(const Value: string);
begin
  FIdentify := Value;
end;

procedure TFrameItemListModel.SetRctBackgroundColor(const AColor: string);
begin
  rctBackground.Fill.Color := StringToAlphaColor(AColor);
end;

procedure TFrameItemListModel.SetRctClientColor(const AColor: string);
begin
  rctClient.Fill.Color := StringToAlphaColor(AColor);
end;

end.
