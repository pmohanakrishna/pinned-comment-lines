# Manual test script

Run these against a sandbox with the extension published and the **Pinned Comments** permission set
assigned. Every scenario is independent unless it says otherwise.

Setup used throughout: customer `10000`, vendor `10000`, item `1896-S` (substitute any records that
exist in your Cronus company).

---

## 1. Pin a comment and see it on the card

1. Open customer `10000` > **Related** > **Comments**.
2. Add a line with comment `Always confirm the PO number before shipping.` and tick **Pinned**.
3. Leave **Pin Until** blank and **Pin Severity** as `Information`. Close the page.
4. Open customer `10000`.

**Expect:** one notification at the top of the card reading `Pinned comment: Always confirm the PO
number before shipping.` with a **Show comments** action.

## 2. One banner, but it comes back every time you open the card

1. With the pin from scenario 1 in place, open customer `10000`.
2. Press F5 to refresh the page. Navigate to the **Invoicing** FastTab and back.
3. Choose **Next** to move to the following customer, then **Previous** to come back.
4. Close the card entirely and open customer `10000` again.
5. Dismiss the notification with the **X**, then close and reopen the card.

**Expect:** exactly one banner at a time — it never stacks. Steps 3, 4, and 5 each raise it again.
This is the important one: a user who missed or dismissed the notification must see it next time
they open the customer, in the same session, without signing out.

## 3. Navigating a list only fires for the pinned record

1. Open the **Customers** list and pick a customer with no pinned comments.
2. Use **Next** to step through five customers, one of which is `10000`.

**Expect:** no notification for the four unpinned customers; exactly one when you land on `10000`.

## 4. Several comment lines become one notification

1. On customer `10000`'s comment sheet, add three pinned lines with the comments `first note`,
   `second note`, and `third note`. Leave **Date** blank on some of them and filled on others.
2. Add a fourth pinned line and leave its **Comment** blank.
3. Open the customer.

**Expect:** a single notification reading
`Pinned comments (3): first note | second note | third note`. The count matches the number of
non-blank pinned lines regardless of their Date or Code, every note is separated by ` | `, and the
blank line is ignored.

## 5. Long text is truncated

1. Pin enough comment lines on one customer that the joined text exceeds 250 characters.
2. Open the customer.

**Expect:** the message is cut at roughly 250 characters and ends with `...`. The full text is still
visible on the comment sheet.

## 6. Warning severity

1. On customer `10000`, set **Pin Severity** to `Warning` on one pinned line.
2. Open the customer.

**Expect:** the message is prefixed with `Warning - `. On the comment sheet, that row renders in the
red `Attention` style; `Information` rows render in bold `Strong` style.

## 7. Expired pin is suppressed

1. On customer `10000`, set **Pin Until** to yesterday's date on every pinned line.
2. Open the customer.

**Expect:** no notification, and no error or validation message when you entered the past date. The
comment lines remain on the sheet untouched.
3. Change **Pin Until** to today's work date and reopen the card.

**Expect:** the notification is back. A pin expires the day *after* **Pin Until**.

## 8. The Show comments action

1. Trigger the notification on customer `10000`.
2. Choose **Show comments**.

**Expect:** the Comment Sheet opens filtered to customer `10000` only — no other customer's comments
are visible, and the comment you pinned is in the list.

## 9. My Notifications toggle

1. Search for **My Notifications**.
2. Find **Pinned comment lines** and clear its **Enabled** tick.
3. Open customer `10000`.

**Expect:** no notification. Re-tick **Enabled**, reopen the card, and it returns. There should be no
app-specific setup page anywhere in search.

## 10. Vendors and items

1. Pin a comment on vendor `10000` and on item `1896-S`.
2. Open each card.

**Expect:** the same single notification on the vendor card and the item card.

## 11. Sales document — customer pin

1. Create a new sales order.
2. In **Customer Name** or **Customer No.**, select customer `10000`.

**Expect:** the customer's pinned comment notification appears on the order.
3. Close the order and reopen it from the **Sales Orders** list, without signing out.

**Expect:** the notification appears again. This is the point of the document hook — the note has to
be visible when someone opens the order to release or post it, not only when the order was created.
4. Move to another order with **Next**, then come back with **Previous**.

**Expect:** the notification is raised again on return, and never stacks.

## 12. Sales document — item pin on multiple lines

1. On the same sales order, add a line with item `1896-S`.
2. Add a **second** line with the same item `1896-S`.

**Expect:** the notification fires for **both** lines, not just the first. This is the regression the
document-context cache key exists for — if line two is silent, the cache key is wrong.
3. Add a line with **Type** = `G/L Account` or a resource.

**Expect:** no item notification for that line.

## 13. Purchase documents

1. Create a purchase order and select vendor `10000`.
2. Add a line with item `1896-S`.
3. Close and reopen the purchase order.

**Expect:** the vendor notification on header validation, the item notification on the line, and the
vendor notification again on reopen.

## 13a. Every document type is covered

Repeat the open-and-reopen check from scenario 11 on a sales quote, sales invoice, sales credit memo,
sales return order, and blanket sales order, then the five purchase equivalents.

**Expect:** the customer or vendor notification on each. A document type that stays silent means its
page is missing from the subscriber list in `Pinned Comment Doc. Subs.`.

## 14. Nothing breaks outside a user session

1. Post the sales order from scenario 12.
2. Using a web service or the API, `POST` a sales order for customer `10000` with a line for item
   `1896-S`, then post it.
3. Run a job queue entry that touches a pinned customer, for example a batch posting.

**Expect:** all of it completes with no error. Notifications require a UI session, so a failure here
means a `GuiAllowed` guard is missing. Check the **Job Queue Log Entries** page is clean.

## 15. Permissions

1. Create a user with only the **Pinned Comments** permission set plus the minimum needed to open a
   customer card.
2. Open a customer with a pinned comment and edit the comment sheet.

**Expect:** the pin fields are readable and editable, and no permission error appears.

---
