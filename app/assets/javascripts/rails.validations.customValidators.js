// The validator variable is a JSON Object
// The selector variable is a jQuery Object
window.ClientSideValidations.validators.local['money'] = function(element, options) {
  if (/[^(\d|\.|,)]/.test(element.val())) {
    return options.messages.numericality.not_a_number;
  } else if (!window.ClientSideValidations.patterns.numericality.test(element.val())) {
    // return I18n.t("errors.messages.invalid_currency", thousands: I18n.t("number.format.delimiter"), decimal: I18n.t("number.format.separator") )
    return options.messages.numericality.invalid_currency;
  }

}