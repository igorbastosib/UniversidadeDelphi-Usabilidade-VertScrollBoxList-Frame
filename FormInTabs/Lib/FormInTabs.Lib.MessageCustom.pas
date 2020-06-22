unit FormInTabs.Lib.MessageCustom;

interface

uses
  FMX.Types, FMX.Layouts, FMX.Objects, FMX.StdCtrls, System.UIConsts,
  System.Classes;

type
  TMessageCustom = class
  private
    class var FLytBackgroud: TLayout;
    class var FRctBackground: TRectangle;
    class var FRctInterno: TRectangle;
    class var FLblMsg: TLabel;
    class var FAniLoading: TAniIndicator;
    { private declarations }
  protected
    { protected declarations }
  public
    class procedure Loading(ATarget: TFmxObject; const AMsg: string);
    class procedure LoadingHide();
    class procedure LoadingChangeMessage(const AMsg: string);
    { public declarations }
  published
    { published declarations }
  end;

implementation

{ TMessageCustom }

class procedure TMessageCustom.LoadingChangeMessage(const AMsg: string);
begin
  if (Assigned(FLblMsg)) then
    TThread.Synchronize( //
      TThread.CurrentThread, //
      procedure
      begin
        FLblMsg.Text := AMsg;
      end //
      );
end;

class procedure TMessageCustom.LoadingHide;
begin
  if (Assigned(FAniLoading)) then
    FAniLoading.DisposeOf;
  FAniLoading := nil;
  if (Assigned(FLblMsg)) then
    FLblMsg.DisposeOf;
  FLblMsg := nil;
  if (Assigned(FRctInterno)) then
    FRctInterno.DisposeOf;
  FRctInterno := nil;
  if (Assigned(FRctBackground)) then
    FRctBackground.DisposeOf;
  FRctBackground := nil;
  if (Assigned(FLytBackgroud)) then
    FLytBackgroud.DisposeOf;
  FLytBackgroud := nil;
end;

class procedure TMessageCustom.Loading(ATarget: TFmxObject; const AMsg: string);
begin
  FLytBackgroud := TLayout.Create(ATarget);
  FLytBackgroud.Visible := False;
  FLytBackgroud.TabStop := False;
  FLytBackgroud.Align := TAlignLayout.Contents;
  FLytBackgroud.Parent := ATarget;

  FRctBackground := TRectangle.Create(FLytBackgroud);
  FRctBackground.Parent := FLytBackgroud;
  FRctBackground.Align := TAlignLayout.Contents;
  FRctBackground.Fill.Color := StringToAlphaColor('Black');
  FRctBackground.Stroke.Color := StringToAlphaColor('Null');
  FRctBackground.Opacity := 0.3;

  FRctInterno := TRectangle.Create(FLytBackgroud);
  FRctInterno.Parent := FLytBackgroud;
  FRctInterno.Align := TAlignLayout.VertCenter;
  FRctInterno.Margins.Left := 10;
  FRctInterno.Margins.Right := 10;
  FRctInterno.Height := 80;
  FRctInterno.XRadius := 5;
  FRctInterno.YRadius := 5;
  FRctInterno.Stroke.Color := StringToAlphaColor('Null');
  FRctInterno.BringToFront;

  FLblMsg := TLabel.Create(FRctInterno);
  FLblMsg.Parent := FRctInterno;
  FLblMsg.Align := TAlignLayout.Client;
  FLblMsg.Text := AMsg;

  FAniLoading := TAniIndicator.Create(FRctInterno);
  FAniLoading.Parent := FRctInterno;
  FAniLoading.Align := TAlignLayout.Left;
  FAniLoading.Enabled := True;

  FLytBackgroud.Visible := True;
  FLytBackgroud.BringToFront;
end;

end.
