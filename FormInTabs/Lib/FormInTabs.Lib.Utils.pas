unit FormInTabs.Lib.Utils;

interface

uses
  FMX.TabControl, System.Classes, FMX.Types, FMX.Forms, FMX.MultiView,
  FMX.Layouts, FMX.StdCtrls, System.SysUtils;

type
  TThreadCustomException = reference to procedure(const AValue: string);

  TUtils = class
  private
    class var FActChangeTab: TChangeTabAction;
    class procedure SetActChangeTab(const Value: TChangeTabAction); static;
    { private declarations }
  protected
    { protected declarations }
  public
  class var
    FFormActive: TForm;
    class property ActChangeTab: TChangeTabAction read FActChangeTab
      write SetActChangeTab;

    class procedure ChangeTab(ATbc: TTabControl; ATbi: TTabItem);
    class procedure OpenForm(const AFrmClass: TComponentClass;
      ATarget: TFMXObject; var AFrmActive: FMX.Forms.TForm;
      AMainMenu: TMultiView; const AMasterButtonName: string = '';
      AOwner: TFMXObject = nil);

    class function ThreadCustom(const AOnShow, AOnProcess, AOnComplete: TProc;
      const AOnError: TThreadCustomException;
      const ADoCompleteWithError: Boolean = False): TThread;

    class procedure LoadingShow(ATarget: TFmxObject; const AMsg: string);
    class procedure LoadignHide();
    class procedure LoadingChangeMessage(const AMsg: string);
    { public declarations }

  published
    { published declarations }
  end;

implementation

uses
  FormInTabs.Lib.MessageCustom;

{ TUtils }

class procedure TUtils.ChangeTab(ATbc: TTabControl; ATbi: TTabItem);
begin
  if (Assigned(FActChangeTab)) then
  begin
    FActChangeTab.Tab := ATbi;
    FActChangeTab.ExecuteTarget(ATbc);
  end;
end;

class procedure TUtils.LoadignHide;
begin
  FormInTabs.Lib.MessageCustom.TMessageCustom.LoadingHide;
end;

class procedure TUtils.LoadingChangeMessage(const AMsg: string);
begin
  FormInTabs.Lib.MessageCustom.TMessageCustom.LoadingChangeMessage(AMsg);
end;

class procedure TUtils.LoadingShow(ATarget: TFmxObject; const AMsg: string);
begin
  FormInTabs.Lib.MessageCustom.TMessageCustom.Loading(ATarget, AMsg);
end;

class procedure TUtils.OpenForm(const AFrmClass: TComponentClass;
  ATarget: TFMXObject; var AFrmActive: FMX.Forms.TForm; AMainMenu: TMultiView;
  const AMasterButtonName: string; AOwner: TFMXObject);
var
  LLytBase: TComponent;
  LBtnMenu: TComponent;
  AFrmActiveToRemove: FMX.Forms.TForm;
  LFrmActiveName: string;
begin
  if (Assigned(AFrmActive)) then
  begin
    if (AFrmActive.ClassType = AFrmClass) then
    begin
      Exit;
    end
    else
    begin
      LFrmActiveName := AFrmActive.Name;
      AFrmActive.DisposeOf;

      AFrmActiveToRemove :=
        FMX.Forms.TForm(ATarget.FindComponent(LFrmActiveName));
      if (AFrmActiveToRemove <> nil) then
        ATarget.RemoveObject(AFrmActiveToRemove);
    end;
  end;

  if (AOwner <> nil) then
    AFrmActive := FMX.Forms.TForm(AFrmClass.Create(AOwner))
  else
    Application.CreateForm(AFrmClass, AFrmActive);
  // AFrmActive := FMX.Forms.TForm(AFrmClass.Create(nil));

  LLytBase := AFrmActive.FindComponent('lytBackground');
  LBtnMenu := nil;
  if not(AMasterButtonName.IsEmpty) then
    LBtnMenu := AFrmActive.FindComponent(AMasterButtonName);
  if (Assigned(LLytBase)) then
  begin
    TLayout(ATarget).AddObject(TLayout(LLytBase));

    if (Assigned(AMainMenu)) then
    begin
      if Assigned(LBtnMenu) then
        AMainMenu.MasterButton := TButton(LBtnMenu);
      AMainMenu.HideMaster;
    end;
  end;
end;

class procedure TUtils.SetActChangeTab(const Value: TChangeTabAction);
begin
  FActChangeTab := Value;
end;

class function TUtils.ThreadCustom(const AOnShow, AOnProcess,
  AOnComplete: TProc; const AOnError: TThreadCustomException;
  const ADoCompleteWithError: Boolean): TThread;
var
  LDoComplete: Boolean;
begin
  LDoComplete := True;
  Result := nil;
  Result := TThread.CreateAnonymousThread( //
    procedure
    begin
      try
        try
          TThread.Synchronize( //
            TThread.CurrentThread, //
            procedure
            begin
              if (Assigned(AOnShow)) then
                AOnShow;
            end //
            );

          if (Assigned(AOnProcess)) then
            AOnProcess;
        except
          on E: Exception do
          begin
            LDoComplete := ADoCompleteWithError;
            TThread.Synchronize( //
              TThread.CurrentThread, //
              procedure
              begin
                if (Assigned(AOnError)) then
                  AOnError(E.Message);
              end //
              );
          end;
        end;
      finally
        if LDoComplete then
        begin
          TThread.Synchronize( //
            TThread.CurrentThread, //
            procedure
            begin
              if (Assigned(AOnComplete)) then
                AOnComplete;
            end //
            );
        end;
      end;
    end //
    );
  Result.FreeOnTerminate := True;
  Result.Start;
end;

end.
