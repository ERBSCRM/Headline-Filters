/* 
Where currency is GBP, set the default VAT value to 20%, otherwise set it to 0%. 
*/
<script>
crm.ready(function () {
    Qnect200.OrderQuoteItemUtils.Prefix = "quit";
    Qnect200.OrderQuoteItemUtils.OnLoad();

    var GBP_CURRENCY_VALUE = "3";

    var CURRENCY_FIELD_NAMES = [
        "quot_currency",
        "quot_Currency"
    ];

    var VAT_FIELD_NAME = "quit_c_vatvalue";
    var VAT_LABEL_TEXT_ID = "quit_c_vat_label_text";

    var settingVatValue = false;

    function getCurrencyField() {
        for (var i = 0; i < CURRENCY_FIELD_NAMES.length; i++) {
            var field = crm.fields(CURRENCY_FIELD_NAMES[i]);

            if (field) {
                return field;
            }
        }

        return null;
    }

    function getCurrencyInput() {
        for (var i = 0; i < CURRENCY_FIELD_NAMES.length; i++) {
            var input = $("#" + CURRENCY_FIELD_NAMES[i] + ", [name='" + CURRENCY_FIELD_NAMES[i] + "']");

            if (input.length) {
                return input;
            }
        }

        return $();
    }

    function getCurrencyValue() {
        var currencyField = getCurrencyField();

        if (currencyField && currencyField.val()) {
            return currencyField.val();
        }

        var currencyInput = getCurrencyInput();

        if (currencyInput.length && currencyInput.val()) {
            return currencyInput.val();
        }

        return "";
    }

    function getCurrencyText() {
        var currencyInput = getCurrencyInput();

        if (currencyInput.length && currencyInput.is("select")) {
            return currencyInput.find("option:selected").text();
        }

        return "";
    }

    function isGBPCurrency() {
        var currencyValue = String(getCurrencyValue()).toLowerCase().trim();
        var currencyText = String(getCurrencyText()).toLowerCase().trim();

        return (
            currencyValue == GBP_CURRENCY_VALUE ||
            currencyText.indexOf("gbp") !== -1 ||
            currencyText.indexOf("pound") !== -1 ||
            currencyText.indexOf("sterling") !== -1
        );
    }

    function getVatInput() {
        return $("#" + VAT_FIELD_NAME + ", [name='" + VAT_FIELD_NAME + "']");
    }

    function setVatValue(value) {
        var vatField = crm.fields(VAT_FIELD_NAME);
        var vatInput = getVatInput();

        settingVatValue = true;

        if (vatField) {
            vatField.val(value);
            vatField.change();
        }

        if (vatInput.length) {
            vatInput.val(value);
            vatInput.trigger("change");
        }

        settingVatValue = false;
    }

    function setVatLocked(isLocked) {
        var vatInput = getVatInput();

        if (!vatInput.length) {
            return;
        }

        vatInput.off(".vatLock");

        if (isLocked) {
            vatInput
                .prop("readonly", true)
                .attr("readonly", "readonly")
                .css({
                    "background-color": "#eeeeee"
                });

            vatInput.on("keydown.vatLock keypress.vatLock paste.vatLock drop.vatLock cut.vatLock input.vatLock change.vatLock", function (e) {
                if (!settingVatValue) {
                    e.preventDefault();
                    applyVatByCurrency();
                    return false;
                }
            });
        } else {
            vatInput
                .prop("readonly", false)
                .removeAttr("readonly")
                .css({
                    "background-color": ""
                });
        }
    }

    function showVatLabel(labelText) {
        $("#" + VAT_LABEL_TEXT_ID).remove();

        var vatInput = getVatInput().filter(":visible").first();

        if (!vatInput.length) {
            vatInput = getVatInput().first();
        }

        var labelHtml =
            "<tr id='" + VAT_LABEL_TEXT_ID + "'>" +
                "<td colspan='100' style='padding:6px 0 8px 0;'>" +
                    "<div style='display:block !important; visibility:visible !important; opacity:1 !important; padding:8px 10px; font-weight:bold; border:1px solid #999999; background-color:#fff8cc; color:#000000;'>" +
                        labelText +
                    "</div>" +
                "</td>" +
            "</tr>";

        if (vatInput.length) {
            var vatRow = vatInput.closest("tr");

            if (vatRow.length) {
                vatRow.after(labelHtml);
                return;
            }

            var vatCell = vatInput.closest("td");

            if (vatCell.length) {
                vatCell.append(
                    "<div id='" + VAT_LABEL_TEXT_ID + "' style='display:block !important; visibility:visible !important; opacity:1 !important; margin-top:8px; padding:8px 10px; font-weight:bold; border:1px solid #999999; background-color:#fff8cc; color:#000000;'>" +
                        labelText +
                    "</div>"
                );
                return;
            }
        }

        $("form:first").prepend(
            "<div id='" + VAT_LABEL_TEXT_ID + "' style='display:block !important; visibility:visible !important; opacity:1 !important; margin:8px 0 12px 0; padding:8px 10px; font-weight:bold; border:1px solid #999999; background-color:#fff8cc; color:#000000;'>" +
                labelText +
            "</div>"
        );
    }

    function applyVatByCurrency() {
        if (isGBPCurrency()) {
            setVatValue("20");
            showVatLabel("Standard Rate - 20%");
            setVatLocked(true);
        } else {
            setVatValue("0");
            showVatLabel("Exempt - 0%");
            setVatLocked(true);
        }
    }

    applyVatByCurrency();

    for (var i = 0; i < CURRENCY_FIELD_NAMES.length; i++) {
        var fieldName = CURRENCY_FIELD_NAMES[i];

        $("#" + fieldName + ", [name='" + fieldName + "']").change(function () {
            applyVatByCurrency();
        });

        var crmCurrencyField = crm.fields(fieldName);

        if (crmCurrencyField) {
            crmCurrencyField.change(function () {
                applyVatByCurrency();
            });
        }
    }

    setTimeout(function () {
        applyVatByCurrency();
    }, 500);

    setTimeout(function () {
        applyVatByCurrency();
    }, 1500);
});
</script>
