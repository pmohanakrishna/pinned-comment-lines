namespace Mohana.PinnedComments;

using Microsoft.Foundation.Comment;

pageextension 53100 "Pinned Comment Sheet" extends "Comment Sheet"
{
    layout
    {
        addafter(Comment)
        {
            field(Pinned; Rec.Pinned)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies that the comment line is shown as a notification when the related record is opened.';
                StyleExpr = PinStyleExpr;
            }
            field("Pin Until"; Rec."Pin Until")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the last date on which the pinned comment line is shown. Leave the field blank to keep it pinned indefinitely.';
                StyleExpr = PinStyleExpr;
            }
            field("Pin Severity"; Rec."Pin Severity")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies how prominently the pinned comment line is presented in the notification.';
                StyleExpr = PinStyleExpr;
            }
        }
    }

    var
        PinStyleExpr: Text;
        AttentionStyleTok: Label 'Attention', Locked = true;
        StrongStyleTok: Label 'Strong', Locked = true;

    trigger OnAfterGetRecord()
    begin
        PinStyleExpr := GetPinStyle();
    end;

    local procedure GetPinStyle(): Text
    begin
        if not Rec.Pinned then
            exit('');
        if Rec."Pin Severity" = Rec."Pin Severity"::Warning then
            exit(AttentionStyleTok);
        exit(StrongStyleTok);
    end;
}
