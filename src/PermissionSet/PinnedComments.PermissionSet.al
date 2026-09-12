namespace Mohana.PinnedComments;

using Microsoft.Foundation.Comment;

permissionset 53100 "Pinned Comments"
{
    Access = Public;
    Assignable = true;
    Caption = 'Pinned Comments';

    Permissions =
        tabledata "Comment Line" = RIMD,
        codeunit "Pinned Comment Mgt." = X,
        codeunit "Pinned Comment Session" = X,
        codeunit "Pinned Comment Subscribers" = X,
        codeunit "Pinned Comment Doc. Subs." = X;
}
