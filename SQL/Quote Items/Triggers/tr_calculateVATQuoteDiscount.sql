USE [CRM]
GO
/****** Object:  Trigger [dbo].[tr_calculateVATQuoteDiscount]    Script Date: 15/05/2026 11:23:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		
-- Create date: 19/112019
-- Description:	<Description,,>UPdate Order Total with VAT
--================================
ALTER trigger [dbo].[tr_calculateVATQuoteDiscount]
on [dbo].[QuoteItems]
After update,insert
as 
BEGIN


declare @currencyid int
set @currencyid = null


declare @quit_LineItemID int
set @quit_LineItemID = null
select @quit_LineItemID=quit_LineItemID from inserted 

declare @quit_c_discount numeric(13,2)
set @quit_c_discount = null 
select @quit_c_discount=quit_c_discount from inserted

declare @quit_quotedprice numeric(13,2)
set @quit_quotedprice = null 
select @quit_quotedprice=quit_quotedprice from inserted

declare @quit_quantity  numeric(13,2)
set @quit_quantity = null 
select @quit_quantity=quit_quantity from inserted

Declare @quit_quotedpricetotal numeric(13,2)
set @quit_quotedpricetotal = null
Select @quit_quotedpricetotal=quit_quotedpricetotal from inserted

--grab the Quoteid
declare @quit_orderQuoteId int
set @quit_orderQuoteId = null 
select @quit_orderQuoteId=quIt_orderquoteid from inserted

select @currencyid=Quot_currency from Quotes where Quot_OrderQuoteID=@quit_orderQuoteId
--
declare @quit_c_vatvalue numeric(13,2)
set @quit_c_vatvalue = null 
select @quit_c_vatvalue=quit_c_vatvalue from inserted
---
-- Run of discount vale >0
if @quit_c_discount >0
Begin
Declare @Discounttotal numeric(13,2)
set @Discounttotal=20.0
set @Discounttotal=(@quit_quotedprice*(@quit_c_discount/100))*@quit_quantity

-- calcualte the gross amount after the discount minused so can be for wokring out lineitem VAT value
Declare @totalminusdiscount numeric(13,2)
set @totalminusdiscount=null
set @totalminusdiscount=(@quit_quotedprice*@quit_quantity)-@Discounttotal

--work out the VATlineitem value using the price minus the disocunt / VAT 
	
	Declare @Vatlineitemtotal numeric(13,2)
	set @Vatlineitemtotal=null
	set @Vatlineitemtotal=((@totalminusdiscount*(@quit_c_vatvalue/100)))
	
	update QuoteItems set  quit_discountsum_CID=@currencyid,quit_discountsum=@Discounttotal,quIt_c_vatsum_CID=@currencyid,
	quit_quotedpricetotal=(@quit_quotedprice*@quit_quantity)-@Discounttotal
	,quIt_c_vatsum=@Vatlineitemtotal,quit_c_totalincvat_cid=@currencyid
	,quit_c_totalincvat=(@totalminusdiscount+@Vatlineitemtotal)
	where quit_LineItemID=@quit_LineItemID and quit_deleted is null
	
End

Else

Begin
if @quit_c_vatvalue >0
	Begin
	Declare @Vatlineitemtotal2 numeric(13,2)
	set @Vatlineitemtotal2=0.0
	set @Vatlineitemtotal2=((@quit_quotedprice*(@quit_c_vatvalue/100))*@quit_quantity)

	--
	Declare @Discounttotal2 numeric(13,2)
	set @Discounttotal2=0.0
	set @Discounttotal2=(@quit_quotedprice*(@quit_c_discount/100))*@quit_quantity

-- calcualte the gross amount after the discount minused so can be for wokring out lineitem VAT value
	Declare @totalminusdiscount2 numeric(13,2)
	set @totalminusdiscount2=0.0
	--set @totalminusdiscount2=@orit_quotedprice-@Discounttotal2
	if @Discounttotal2 >0
	set @totalminusdiscount2=(@quit_quotedprice*@quit_quantity)-@Discounttotal2
	else
	set @totalminusdiscount2=(@quit_quotedprice*@quit_quantity)
	--


	update QuoteItems set  quit_discountsum_CID=@currencyid,quit_discountsum=0,quIt_c_vatsum_CID=@currencyid,quIt_c_vatsum=@Vatlineitemtotal2
	,quit_c_totalincvat_CID=@currencyid,quit_c_totalincvat=(@totalminusdiscount2+@Vatlineitemtotal2)
	where quit_LineItemID=@quit_LineItemID and quit_deleted is null

	End

else
update QuoteItems set  quit_discountsum_CID=@currencyid,quit_discountsum=0,quIt_c_vatsum_CID=@currencyid,quIt_c_vatsum=0
,quit_c_totalincvat_CID=@currencyid,quit_c_totalincvat=(@quit_quotedprice*@quit_quantity)
	where quit_LineItemID=@quit_LineItemID and quit_deleted is null

END

-- Sum VAT LineItem Totals
Declare @VATtotal numeric(13,2)
set @VATtotal =0.00
set @VATtotal=(select sum(quit_c_vatsum) from QuoteItems where  quIt_Deleted is null  
and quIt_orderquoteid=@quit_orderQuoteId )

-- Sum LineItem Inc VAT Totals
Declare @totalIncVAT numeric(13,2)
set @totalIncVAT =0.00
set @totalIncVAT=(select sum(quit_c_totalincvat) from QuoteItems where  quIt_Deleted is null  
and quIt_orderquoteid=@quit_orderQuoteId )

-- update the order with Total VAT and Total Inc VAT Totals

update quotes set quot_c_totalvat=@VATtotal, quot_c_totalincvat=@totalIncVAT
 where quot_orderQuoteId=@quit_orderQuoteId 
and quot_Deleted is null


END
