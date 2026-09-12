namespace Mohana.PinnedComments;

using Microsoft.Foundation.Comment;
using Microsoft.Purchases.Document;
using Microsoft.Sales.Document;

/// <summary>
/// Document hooks. Header pins are raised when the document is opened and when the customer or vendor is validated;
/// item pins are raised when a line is validated, which is the same split the base application uses.
/// </summary>
codeunit 53103 "Pinned Comment Doc. Subs."
{
    Access = Internal;

    var
        DocumentContextTok: Label '%1 %2 %3', Locked = true;

    [EventSubscriber(ObjectType::Page, Page::"Sales Quote", 'OnAfterGetCurrRecordEvent', '', false, false)]
    local procedure OnSalesQuoteAfterGetCurrRecord(var Rec: Record "Sales Header")
    begin
        ShowSalesHeaderPin(Rec);
    end;

    [EventSubscriber(ObjectType::Page, Page::"Sales Quote", 'OnClosePageEvent', '', false, false)]
    local procedure OnSalesQuoteClosePage(var Rec: Record "Sales Header")
    begin
        ResetPin(Rec.RecordId());
    end;

    [EventSubscriber(ObjectType::Page, Page::"Sales Order", 'OnAfterGetCurrRecordEvent', '', false, false)]
    local procedure OnSalesOrderAfterGetCurrRecord(var Rec: Record "Sales Header")
    begin
        ShowSalesHeaderPin(Rec);
    end;

    [EventSubscriber(ObjectType::Page, Page::"Sales Order", 'OnClosePageEvent', '', false, false)]
    local procedure OnSalesOrderClosePage(var Rec: Record "Sales Header")
    begin
        ResetPin(Rec.RecordId());
    end;

    [EventSubscriber(ObjectType::Page, Page::"Sales Invoice", 'OnAfterGetCurrRecordEvent', '', false, false)]
    local procedure OnSalesInvoiceAfterGetCurrRecord(var Rec: Record "Sales Header")
    begin
        ShowSalesHeaderPin(Rec);
    end;

    [EventSubscriber(ObjectType::Page, Page::"Sales Invoice", 'OnClosePageEvent', '', false, false)]
    local procedure OnSalesInvoiceClosePage(var Rec: Record "Sales Header")
    begin
        ResetPin(Rec.RecordId());
    end;

    [EventSubscriber(ObjectType::Page, Page::"Sales Credit Memo", 'OnAfterGetCurrRecordEvent', '', false, false)]
    local procedure OnSalesCreditMemoAfterGetCurrRecord(var Rec: Record "Sales Header")
    begin
        ShowSalesHeaderPin(Rec);
    end;

    [EventSubscriber(ObjectType::Page, Page::"Sales Credit Memo", 'OnClosePageEvent', '', false, false)]
    local procedure OnSalesCreditMemoClosePage(var Rec: Record "Sales Header")
    begin
        ResetPin(Rec.RecordId());
    end;

    [EventSubscriber(ObjectType::Page, Page::"Sales Return Order", 'OnAfterGetCurrRecordEvent', '', false, false)]
    local procedure OnSalesReturnOrderAfterGetCurrRecord(var Rec: Record "Sales Header")
    begin
        ShowSalesHeaderPin(Rec);
    end;

    [EventSubscriber(ObjectType::Page, Page::"Sales Return Order", 'OnClosePageEvent', '', false, false)]
    local procedure OnSalesReturnOrderClosePage(var Rec: Record "Sales Header")
    begin
        ResetPin(Rec.RecordId());
    end;

    [EventSubscriber(ObjectType::Page, Page::"Blanket Sales Order", 'OnAfterGetCurrRecordEvent', '', false, false)]
    local procedure OnBlanketSalesOrderAfterGetCurrRecord(var Rec: Record "Sales Header")
    begin
        ShowSalesHeaderPin(Rec);
    end;

    [EventSubscriber(ObjectType::Page, Page::"Blanket Sales Order", 'OnClosePageEvent', '', false, false)]
    local procedure OnBlanketSalesOrderClosePage(var Rec: Record "Sales Header")
    begin
        ResetPin(Rec.RecordId());
    end;

    [EventSubscriber(ObjectType::Page, Page::"Purchase Quote", 'OnAfterGetCurrRecordEvent', '', false, false)]
    local procedure OnPurchaseQuoteAfterGetCurrRecord(var Rec: Record "Purchase Header")
    begin
        ShowPurchaseHeaderPin(Rec);
    end;

    [EventSubscriber(ObjectType::Page, Page::"Purchase Quote", 'OnClosePageEvent', '', false, false)]
    local procedure OnPurchaseQuoteClosePage(var Rec: Record "Purchase Header")
    begin
        ResetPin(Rec.RecordId());
    end;

    [EventSubscriber(ObjectType::Page, Page::"Purchase Order", 'OnAfterGetCurrRecordEvent', '', false, false)]
    local procedure OnPurchaseOrderAfterGetCurrRecord(var Rec: Record "Purchase Header")
    begin
        ShowPurchaseHeaderPin(Rec);
    end;

    [EventSubscriber(ObjectType::Page, Page::"Purchase Order", 'OnClosePageEvent', '', false, false)]
    local procedure OnPurchaseOrderClosePage(var Rec: Record "Purchase Header")
    begin
        ResetPin(Rec.RecordId());
    end;

    [EventSubscriber(ObjectType::Page, Page::"Purchase Invoice", 'OnAfterGetCurrRecordEvent', '', false, false)]
    local procedure OnPurchaseInvoiceAfterGetCurrRecord(var Rec: Record "Purchase Header")
    begin
        ShowPurchaseHeaderPin(Rec);
    end;

    [EventSubscriber(ObjectType::Page, Page::"Purchase Invoice", 'OnClosePageEvent', '', false, false)]
    local procedure OnPurchaseInvoiceClosePage(var Rec: Record "Purchase Header")
    begin
        ResetPin(Rec.RecordId());
    end;

    [EventSubscriber(ObjectType::Page, Page::"Purchase Credit Memo", 'OnAfterGetCurrRecordEvent', '', false, false)]
    local procedure OnPurchaseCreditMemoAfterGetCurrRecord(var Rec: Record "Purchase Header")
    begin
        ShowPurchaseHeaderPin(Rec);
    end;

    [EventSubscriber(ObjectType::Page, Page::"Purchase Credit Memo", 'OnClosePageEvent', '', false, false)]
    local procedure OnPurchaseCreditMemoClosePage(var Rec: Record "Purchase Header")
    begin
        ResetPin(Rec.RecordId());
    end;

    [EventSubscriber(ObjectType::Page, Page::"Purchase Return Order", 'OnAfterGetCurrRecordEvent', '', false, false)]
    local procedure OnPurchaseReturnOrderAfterGetCurrRecord(var Rec: Record "Purchase Header")
    begin
        ShowPurchaseHeaderPin(Rec);
    end;

    [EventSubscriber(ObjectType::Page, Page::"Purchase Return Order", 'OnClosePageEvent', '', false, false)]
    local procedure OnPurchaseReturnOrderClosePage(var Rec: Record "Purchase Header")
    begin
        ResetPin(Rec.RecordId());
    end;

    [EventSubscriber(ObjectType::Page, Page::"Blanket Purchase Order", 'OnAfterGetCurrRecordEvent', '', false, false)]
    local procedure OnBlanketPurchaseOrderAfterGetCurrRecord(var Rec: Record "Purchase Header")
    begin
        ShowPurchaseHeaderPin(Rec);
    end;

    [EventSubscriber(ObjectType::Page, Page::"Blanket Purchase Order", 'OnClosePageEvent', '', false, false)]
    local procedure OnBlanketPurchaseOrderClosePage(var Rec: Record "Purchase Header")
    begin
        ResetPin(Rec.RecordId());
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterValidateEvent', 'Sell-to Customer No.', false, false)]
    local procedure OnAfterValidateSellToCustomerNo(var Rec: Record "Sales Header")
    begin
        ShowSalesHeaderPin(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnAfterValidateEvent', 'Buy-from Vendor No.', false, false)]
    local procedure OnAfterValidateBuyFromVendorNo(var Rec: Record "Purchase Header")
    begin
        ShowPurchaseHeaderPin(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterValidateEvent', 'No.', false, false)]
    local procedure OnAfterValidateSalesLineNo(var Rec: Record "Sales Line")
    var
        PinnedCommentMgt: Codeunit "Pinned Comment Mgt.";
    begin
        if Rec.IsTemporary() then
            exit;
        if Rec.Type <> Rec.Type::Item then
            exit;
        PinnedCommentMgt.ShowPinNotificationForContext(Enum::"Comment Line Table Name"::Item, Rec."No.", DocumentContext(Format(Rec."Document Type"), Rec."Document No.", Rec."Line No."), Rec.RecordId());
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnAfterValidateEvent', 'No.', false, false)]
    local procedure OnAfterValidatePurchaseLineNo(var Rec: Record "Purchase Line")
    var
        PinnedCommentMgt: Codeunit "Pinned Comment Mgt.";
    begin
        if Rec.IsTemporary() then
            exit;
        if Rec.Type <> Rec.Type::Item then
            exit;
        PinnedCommentMgt.ShowPinNotificationForContext(Enum::"Comment Line Table Name"::Item, Rec."No.", DocumentContext(Format(Rec."Document Type"), Rec."Document No.", Rec."Line No."), Rec.RecordId());
    end;

    local procedure ShowSalesHeaderPin(var SalesHeader: Record "Sales Header")
    var
        PinnedCommentMgt: Codeunit "Pinned Comment Mgt.";
    begin
        if SalesHeader.IsTemporary() then
            exit;
        PinnedCommentMgt.ShowPinNotificationForContext(Enum::"Comment Line Table Name"::Customer, SalesHeader."Sell-to Customer No.", DocumentContext(Format(SalesHeader."Document Type"), SalesHeader."No.", 0), SalesHeader.RecordId());
    end;

    local procedure ShowPurchaseHeaderPin(var PurchaseHeader: Record "Purchase Header")
    var
        PinnedCommentMgt: Codeunit "Pinned Comment Mgt.";
    begin
        if PurchaseHeader.IsTemporary() then
            exit;
        PinnedCommentMgt.ShowPinNotificationForContext(Enum::"Comment Line Table Name"::Vendor, PurchaseHeader."Buy-from Vendor No.", DocumentContext(Format(PurchaseHeader."Document Type"), PurchaseHeader."No.", 0), PurchaseHeader.RecordId());
    end;

    local procedure ResetPin(RecId: RecordId)
    var
        PinnedCommentMgt: Codeunit "Pinned Comment Mgt.";
    begin
        PinnedCommentMgt.ResetPinNotification(RecId);
    end;

    local procedure DocumentContext(DocumentType: Text; DocumentNo: Code[20]; LineNo: Integer): Text
    begin
        exit(StrSubstNo(DocumentContextTok, DocumentType, DocumentNo, LineNo));
    end;
}
