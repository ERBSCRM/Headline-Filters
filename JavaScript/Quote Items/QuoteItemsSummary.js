/* 
Where currency is GBP, set the default VAT value to 20%, otherwise set it to 0%. 
*/
<script>
crm.ready(function () {
    Qnect200.OrderQuoteItemUtils.Prefix = "quit";
    Qnect200.OrderQuoteItemUtils.OnLoad();

    function setDefaultByCurrency() {
        var currencyField = crm.fields("quot_currency");
        var vatField = crm.fields("quit_c_vatvalue");

        if (!currencyField || !vatField) {
            return;
        }

        var currency = currencyField.val();

        if (currency == "3") {
            vatField.val("20");
        } else {
            vatField.val("0");
        }

        vatField.change();
    }

    setDefaultByCurrency();

    crm.fields("quot_currency").change(function () {
        setDefaultByCurrency();
    });
});
</script>