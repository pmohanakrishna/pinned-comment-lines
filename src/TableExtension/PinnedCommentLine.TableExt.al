namespace Mohana.PinnedComments;

using Microsoft.Foundation.Comment;

tableextension 53100 "Pinned Comment Line" extends "Comment Line"
{
    fields
    {
        field(53100; Pinned; Boolean)
        {
            Caption = 'Pinned';
            DataClassification = CustomerContent;
        }
        field(53101; "Pin Until"; Date)
        {
            Caption = 'Pin Until';
            DataClassification = CustomerContent;
        }
        field(53102; "Pin Severity"; Enum "Pin Severity")
        {
            Caption = 'Pin Severity';
            DataClassification = CustomerContent;
        }
    }
}
