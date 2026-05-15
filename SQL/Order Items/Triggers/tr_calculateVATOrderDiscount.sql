USE [CRM]
GO
/****** Object:  Trigger [dbo].[tr_calculateVATOrderDiscount]    Script Date: 15/05/2026 11:20:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Rajan

-- Description:	<Description,,>UPdate Order Total with VAT
--================================
ALTER trigger [dbo].[tr_calculateVATOrderDiscount]
on [dbo].[OrderItems]
After update,insert
as 
BEGIN


declare @currencyid int

declare @orit_LineItemID int
set @Orit_LineItemID = null
select @Orit_LineItemID=Orit_LineItemID from inserted 

declare @orit_c_discount numeric(13,2)
set @orit_c_discount = null 
select @orit_c_discount=orit_c_discount from inserted

declare @orit_quotedprice numeric(13,2)
set @orit_quotedprice = null 
select @orit_quotedprice=orit_quotedprice from inserted

declare @orit_quantity  numeric(13,2)
set @orit_quantity = null 
select @orit_quantity=orit_quantity from inserted

Declare @orit_quotedpricetotal numeric(13,2)
set @orit_quotedpricetotal = null
Select @orit_quotedpricetotal=orit_quotedpricetotal from inserted

--grab the orderid
declare @orde_orderQuoteId int
set @orde_orderQuoteId = null 
select @orde_orderQuoteId=OrIt_orderquoteid from inserted
select @currencyid=orde_currency from Orders where orde_OrderQuoteID=@orde_orderQuoteId
--
declare @orit_c_vatvalue numeric(13,2)
set @orit_c_vatvalue = null 
select @orit_c_vatvalue=orit_c_vatvalue from inserted
---
-- Run of discount vale >0
if @orit_c_discount >0
Begin
Declare @Discounttotal numeric(13,2)
set @Discounttotal=20.0
set @Discounttotal=(@orit_quotedprice*(@orit_c_discount/100))*@orit_quantity

-- calcualte the gross amount after the discount minused so can be for wokring out lineitem VAT value
Declare @totalminusdiscount numeric(13,2)
set @totalminusdiscount=null
set @totalminusdiscount=(@orit_quotedprice*@orit_quantity)-@Discounttotal

--work out the VATlineitem value using the price minus the disocunt / VAT 
	
	Declare @Vatlineitemtotal numeric(13,2)
	set @Vatlineitemtotal=null
	set @Vatlineitemtotal=((@totalminusdiscount*(@orit_c_vatvalue/100)))
	
	update OrderItems set  orit_discountsum_CID=@currencyid,orit_discountsum=@Discounttotal,orit_quotedpricetotal_cid=@currencyid,
	orit_quotedpricetotal=(@orit_quotedprice*@orit_quantity)-@Discounttotal,orit_c_vatsum_CID=@currencyid,
	OrIt_c_vatsum=@Vatlineitemtotal,orit_c_totalincvat_cid=@currencyid
	,orit_c_totalincvat=(@totalminusdiscount+@Vatlineitemtotal)
	where orit_LineItemID=@orit_LineItemID and orit_deleted is null
	
End

Else

Begin
if @orit_c_vatvalue >0
	Begin
	Declare @Vatlineitemtotal2 numeric(13,2)
	set @Vatlineitemtotal2=0.0
	set @Vatlineitemtotal2=((@orit_quotedprice*(@orit_c_vatvalue/100))*@orit_quantity)

	--
	Declare @Discounttotal2 numeric(13,2)
	set @Discounttotal2=0.0
	set @Discounttotal2=(@orit_quotedprice*(@orit_c_discount/100))*@orit_quantity

-- calcualte the gross amount after the discount minused so can be for wokring out lineitem VAT value
	Declare @totalminusdiscount2 numeric(13,2)
	set @totalminusdiscount2=0.0
	--set @totalminusdiscount2=@orit_quotedprice-@Discounttotal2
	if @Discounttotal2 >0
	set @totalminusdiscount2=(@orit_quotedprice*@orit_quantity)-@Discounttotal2
	else
	set @totalminusdiscount2=(@orit_quotedprice*@orit_quantity)

	--


	update OrderItems set  orit_discountsum_CID=@currencyid,orit_discountsum=0,OrIt_c_vatsum_CID=@currencyid,OrIt_c_vatsum=@Vatlineitemtotal2
	,orit_c_totalincvat_CID=@currencyid,orit_c_totalincvat=(@totalminusdiscount2+@Vatlineitemtotal2)
	where orit_LineItemID=@orit_LineItemID and orit_deleted is null

	End

else
update OrderItems set  orit_discountsum_CID=@currencyid,orit_discountsum=0,OrIt_c_vatsum_CID=@currencyid,OrIt_c_vatsum=0
,orit_c_totalincvat_CID=@currencyid,orit_c_totalincvat=(@orit_quotedprice*@orit_quantity)
	where orit_LineItemID=@orit_LineItemID and orit_deleted is null

END

-- Sum VAT LineItem Totals
Declare @VATtotal numeric(13,2)
set @VATtotal =0.00
set @VATtotal=(select sum(orit_c_vatsum) from OrderItems where  OrIt_Deleted is null  
and OrIt_orderquoteid=@orde_orderQuoteId )

-- Sum LineItem Inc VAT Totals
Declare @totalIncVAT numeric(13,2)
set @totalIncVAT =0.00
set @totalIncVAT=(select sum(orit_c_totalincvat) from OrderItems where  OrIt_Deleted is null  
and OrIt_orderquoteid=@orde_orderQuoteId )

-- update the order with Total VAT and Total Inc VAT Totals

update orders set orde_c_totalvat=@VATtotal, orde_c_totalincvat=@totalIncVAT
 where orde_orderQuoteId=@orde_orderQuoteId 
and Orde_Deleted is null


END

