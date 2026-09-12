namespace Mohana.PinnedComments;

using Microsoft.Foundation.Comment;

/// <summary>
/// Remembers only the record currently in context. OnAfterGetCurrRecordEvent fires many times for one record, and this stops
/// the repeats from re-querying the comment lines. It is not an "already seen" list: moving to another record or closing the
/// page clears it, so the same record notifies again.
/// </summary>
codeunit 53101 "Pinned Comment Session"
{
    SingleInstance = true;
    Access = Internal;

    var
        CurrentContext: Text;
        KeyTok: Label '%1|%2|%3', Locked = true;

    procedure IsCurrentContext(TableName: Enum "Comment Line Table Name"; No: Code[20]; ContextKey: Text): Boolean
    begin
        exit((CurrentContext <> '') and (CurrentContext = BuildKey(TableName, No, ContextKey)));
    end;

    procedure SetCurrentContext(TableName: Enum "Comment Line Table Name"; No: Code[20]; ContextKey: Text)
    begin
        CurrentContext := BuildKey(TableName, No, ContextKey);
    end;

    procedure ClearCurrentContext()
    begin
        CurrentContext := '';
    end;

    local procedure BuildKey(TableName: Enum "Comment Line Table Name"; No: Code[20]; ContextKey: Text): Text
    begin
        exit(StrSubstNo(KeyTok, TableName.AsInteger(), No, ContextKey));
    end;
}
