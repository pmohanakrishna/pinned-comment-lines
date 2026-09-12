namespace Mohana.PinnedComments;

using Microsoft.Foundation.Comment;
using System.Environment.Configuration;

codeunit 53100 "Pinned Comment Mgt."
{
    Access = Public;

    var
        PinnedCommentSession: Codeunit "Pinned Comment Session";
        TableNameDataTok: Label 'tableName', Locked = true;
        NoDataTok: Label 'no', Locked = true;
        NoteSeparatorTok: Label ' | ', Locked = true;
        EllipsisTok: Label '...', Locked = true;
        NotificationNameLbl: Label 'Pinned comment lines';
        NotificationDescriptionLbl: Label 'Show a notification when a record has pinned comment lines.';
        ShowCommentsLbl: Label 'Show comments';
        SinglePinMsg: Label 'Pinned comment: %1', Comment = '%1 = the pinned comment text';
        MultiplePinMsg: Label 'Pinned comments (%1): %2', Comment = '%1 = number of pinned comments, %2 = the pinned comment text';
        WarningPinMsg: Label 'Warning - %1', Comment = '%1 = the pinned comment notification message';

    /// <summary>
    /// Raises the pinned comment notification for a master data record opened on a card.
    /// </summary>
    procedure ShowPinNotification(TableName: Enum "Comment Line Table Name"; No: Code[20]; RecId: RecordId)
    begin
        ShowPinNotificationForContext(TableName, No, '', RecId);
    end;

    /// <summary>
    /// Raises the pinned comment notification. Repeats for the record currently in context are skipped to avoid a redundant query,
    /// not to hide the notification: moving to another record or closing the page makes it fire again.
    /// </summary>
    procedure ShowPinNotificationForContext(TableName: Enum "Comment Line Table Name"; No: Code[20]; ContextKey: Text; RecId: RecordId)
    var
        MyNotifications: Record "My Notifications";
        NotificationLifecycleMgt: Codeunit "Notification Lifecycle Mgt.";
        PinNotification: Notification;
        MessageText: Text;
        PinText: Text;
        NoteCount: Integer;
        IsWarning: Boolean;
    begin
        if not GuiAllowed() then
            exit;
        if No = '' then
            exit;
        if PinnedCommentSession.IsCurrentContext(TableName, No, ContextKey) then
            exit;
        if not MyNotifications.IsEnabled(GetPinNotificationId()) then
            exit;

        PinnedCommentSession.SetCurrentContext(TableName, No, ContextKey);

        PinText := CollectPins(TableName, No, NoteCount, IsWarning);
        if NoteCount = 0 then
            exit;

        if NoteCount = 1 then
            MessageText := StrSubstNo(SinglePinMsg, TruncateForNotification(PinText))
        else
            MessageText := StrSubstNo(MultiplePinMsg, NoteCount, TruncateForNotification(PinText));

        if IsWarning then
            MessageText := StrSubstNo(WarningPinMsg, MessageText);

        PinNotification.Id := GetPinNotificationId();
        PinNotification.Message := MessageText;
        PinNotification.Scope := NotificationScope::LocalScope;
        PinNotification.SetData(TableNameDataTok, Format(TableName.AsInteger()));
        PinNotification.SetData(NoDataTok, No);
        PinNotification.AddAction(ShowCommentsLbl, Codeunit::"Pinned Comment Mgt.", 'ShowComments');
        PinNotification.Recall();
        NotificationLifecycleMgt.SendNotification(PinNotification, RecId);
    end;

    /// <summary>
    /// Clears the context guard and recalls the banner, so that reopening the same record notifies again.
    /// </summary>
    procedure ResetPinNotification(RecId: RecordId)
    var
        NotificationLifecycleMgt: Codeunit "Notification Lifecycle Mgt.";
    begin
        PinnedCommentSession.ClearCurrentContext();
        if not GuiAllowed() then
            exit;
        NotificationLifecycleMgt.RecallNotificationsForRecord(RecId, false);
    end;

    procedure HasActivePins(TableName: Enum "Comment Line Table Name"; No: Code[20]): Boolean
    var
        CommentLine: Record "Comment Line";
    begin
        if No = '' then
            exit(false);
        SetActivePinFilters(CommentLine, TableName, No);
        exit(not CommentLine.IsEmpty());
    end;

    procedure GetPinText(TableName: Enum "Comment Line Table Name"; No: Code[20]): Text
    var
        NoteCount: Integer;
        IsWarning: Boolean;
    begin
        if No = '' then
            exit('');
        exit(CollectPins(TableName, No, NoteCount, IsWarning));
    end;

    procedure GetPinNotificationId(): Guid
    begin
        exit('7C3B1F4A-9D52-4E68-B1A7-2F6C5D0E84B3');
    end;

    procedure RegisterNotification(var MyNotifications: Record "My Notifications")
    begin
        MyNotifications.InsertDefault(GetPinNotificationId(), CopyStr(NotificationNameLbl, 1, MaxStrLen(MyNotifications.Name)), NotificationDescriptionLbl, true);
    end;

    /// <summary>
    /// Notification action handler. Opens the comment sheet filtered to the record the notification was raised for.
    /// </summary>
    procedure ShowComments(PinNotification: Notification)
    var
        CommentLine: Record "Comment Line";
        TableNameOrdinal: Integer;
    begin
        if not Evaluate(TableNameOrdinal, PinNotification.GetData(TableNameDataTok)) then
            exit;

        CommentLine.SetRange("Table Name", Enum::"Comment Line Table Name".FromInteger(TableNameOrdinal));
        CommentLine.SetRange("No.", CopyStr(PinNotification.GetData(NoDataTok), 1, MaxStrLen(CommentLine."No.")));
        Page.Run(Page::"Comment Sheet", CommentLine);
    end;

    local procedure CollectPins(TableName: Enum "Comment Line Table Name"; No: Code[20]; var NoteCount: Integer; var IsWarning: Boolean): Text
    var
        CommentLine: Record "Comment Line";
        CommentBuilder: TextBuilder;
        CommentText: Text;
    begin
        NoteCount := 0;
        IsWarning := false;

        CommentLine.SetLoadFields("Comment", "Pin Severity");
        SetActivePinFilters(CommentLine, TableName, No);
        if not CommentLine.FindSet() then
            exit('');

        repeat
            if CommentLine."Pin Severity" = CommentLine."Pin Severity"::Warning then
                IsWarning := true;

            CommentText := DelChr(CommentLine.Comment, '<>', ' ');
            if CommentText <> '' then begin
                if NoteCount > 0 then
                    CommentBuilder.Append(NoteSeparatorTok);
                CommentBuilder.Append(CommentText);
                NoteCount += 1;
            end;
        until CommentLine.Next() = 0;

        exit(CommentBuilder.ToText());
    end;

    local procedure SetActivePinFilters(var CommentLine: Record "Comment Line"; TableName: Enum "Comment Line Table Name"; No: Code[20])
    begin
        CommentLine.SetRange("Table Name", TableName);
        CommentLine.SetRange("No.", No);
        CommentLine.SetRange(Pinned, true);
        CommentLine.SetFilter("Pin Until", '%1|%2..', 0D, WorkDate());
    end;

    local procedure TruncateForNotification(Value: Text): Text
    begin
        if StrLen(Value) <= MaxMessageLength() then
            exit(Value);
        exit(CopyStr(Value, 1, MaxMessageLength()) + EllipsisTok);
    end;

    local procedure MaxMessageLength(): Integer
    begin
        exit(250);
    end;
}
