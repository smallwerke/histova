#' Convert Text
#'
#' @description
#' do a simple swap of html based characters for special symbols needed in titles & labels
#'
#' @param label A string to be processed
#'
#' @return A string with unicode in place of html markdown
#' @export
#'
#' @examples
#' title <- "Is it finally &Pi; day?"
#' title <- convert_text(title)
convert_text <- function (label) {

    # convert
    # set conversion table
    replaceDict = list(
        "&Alpha;" = "\U0391",
        # Beta is not always reliable...
        "&Beta;" = "\U0392",
        "&Gamma;" = "\U0393",
        "&Delta;" = "\U0394",
        "&Epsilon;" = "\U0395",
        "&Pi;" = "\U03A0",
        "&Sigma;" = "\U03A3",
        "&Tau;" = "\U03A4",
        "&Phi;" = "\U03A6",
        "&Omega;" = "\U03A9",
        "&alpha;" = "\U03B1",
        "&beta;" = "\U03B2",
        "&gamma;" = "\U03B3",
        "&delta;" = "\U03B4",
        "&epsilon;" = "\U03B5",
        "&pi;" = "\U03C0",
        "&sigma;" = "\U03C3",
        "&tau;" = "\U03C4",
        "&phi;" = "\U03C6",
        "&omega;" = "\U03C9",
        "&bull;" = "\U2022",
        "&isin;" = "\U2208",
        "&notin;" = "\U2209",
        "&radic;" = "\U221A",
        "&infin;" = "\U221E",
        "&asymp;" = "\U2248",
        "&micro;" = "\U00B5"
    )
    # run through the above list and replace code on left with unicode on right
    for (html in names(replaceDict)) { label = gsub(html, replaceDict[[html]], label) }

    # search for \n in input string that gets converted to \\n by R and revert it to \n
    label = gsub("\\\\n", "\n", label)

    return(label)
}
