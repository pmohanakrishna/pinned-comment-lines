namespace Mohana.PinnedComments;

using Microsoft.Foundation.Comment;
using Microsoft.Inventory.Item;
using Microsoft.Purchases.Vendor;
using Microsoft.Sales.Customer;
using System.Environment.Configuration;

codeunit 53102 "Pinned Comment Subscribers"
{
    Access = Internal;

    [EventSubscriber(ObjectType::Page, Page::"My Notifications", 'OnInitializingNotificationWithDefaultState', '', false, false)]
    local procedure OnInitializingNotificationWithDefaultState()
    var
        MyNotifications: Record "My Notifications";
        PinnedCommentMgt: Codeunit "Pinned Comment Mgt.";
    begin
        PinnedCommentMgt.RegisterNotification(MyNotifications);
    end;

    [EventSubscriber(ObjectType::Page, Page::"Customer Card", 'OnAfterGetCurrRecordEvent', '', false, false)]
    local procedure OnCustomerCardAfterGetCurrRecord(var Rec: Record Customer)
    var
        PinnedCommentMgt: Codeunit "Pinned Comment Mgt.";
    begin
        PinnedCommentMgt.ShowPinNotification(Enum::"Comment Line Table Name"::Customer, Rec."No.", Rec.RecordId());
    end;

    [EventSubscriber(ObjectType::Page, Page::"Customer Card", 'OnClosePageEvent', '', false, false)]
    local procedure OnCustomerCardClosePage(var Rec: Record Customer)
    var
        PinnedCommentMgt: Codeunit "Pinned Comment Mgt.";
    begin
        PinnedCommentMgt.ResetPinNotification(Rec.RecordId());
    end;

    [EventSubscriber(ObjectType::Page, Page::"Vendor Card", 'OnAfterGetCurrRecordEvent', '', false, false)]
    local procedure OnVendorCardAfterGetCurrRecord(var Rec: Record Vendor)
    var
        PinnedCommentMgt: Codeunit "Pinned Comment Mgt.";
    begin
        PinnedCommentMgt.ShowPinNotification(Enum::"Comment Line Table Name"::Vendor, Rec."No.", Rec.RecordId());
    end;

    [EventSubscriber(ObjectType::Page, Page::"Vendor Card", 'OnClosePageEvent', '', false, false)]
    local procedure OnVendorCardClosePage(var Rec: Record Vendor)
    var
        PinnedCommentMgt: Codeunit "Pinned Comment Mgt.";
    begin
        PinnedCommentMgt.ResetPinNotification(Rec.RecordId());
    end;

    [EventSubscriber(ObjectType::Page, Page::"Item Card", 'OnAfterGetCurrRecordEvent', '', false, false)]
    local procedure OnItemCardAfterGetCurrRecord(var Rec: Record Item)
    var
        PinnedCommentMgt: Codeunit "Pinned Comment Mgt.";
    begin
        PinnedCommentMgt.ShowPinNotification(Enum::"Comment Line Table Name"::Item, Rec."No.", Rec.RecordId());
    end;

    [EventSubscriber(ObjectType::Page, Page::"Item Card", 'OnClosePageEvent', '', false, false)]
    local procedure OnItemCardClosePage(var Rec: Record Item)
    var
        PinnedCommentMgt: Codeunit "Pinned Comment Mgt.";
    begin
        PinnedCommentMgt.ResetPinNotification(Rec.RecordId());
    end;
}
