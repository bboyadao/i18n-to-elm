defmodule I18n2ElmTest.Printer do

  use ExUnit.Case
  alias I18n2Elm.Printer
  alias I18n2Elm.Types.Translation

  test "print language translation file" do

    {translations_file_path, translations_file} =
      %Translation{
        language_tag: "da_DK",
        translations: [
          {"TidNext", "Næste"},
          {"TidNo", "Nej"},
          {"TidPrevious", "Forrige"},
          {"TidYes", "Ja"}
        ]
      }
      |> Printer.print_translation("Translations")

    expected_translations_file = ~S"""
    module Translations.DaDk exposing (daDkTranslations)

    import Translations.Ids exposing (TranslationId(..))

    daDkTranslations : TranslationId -> String
    daDkTranslations tid =
        case tid of
            TidNext ->
                "Næste"

            TidNo ->
                "Nej"

            TidPrevious ->
                "Forrige"

            TidYes ->
                "Ja"

    """

    assert translations_file_path == "./Translations/DaDk.elm"
    assert translations_file == expected_translations_file
  end

  test "print ids file" do

    translations = [
      %Translation{
        language_tag: "da_DK",
        translations: [
          {"TidNext", "Næste"},
          {"TidNo", "Nej"},
          {"TidPrevious", "Forrige"},
          {"TidYes", "Ja"}
        ]
      },

      %Translation{
        language_tag: "en_US",
        translations: [
          {"TidNext", "Next"},
          {"TidNo", "No"},
          {"TidPrevious", "Previous"},
          {"TidYes", "Yes"}
        ]
      }
    ]

    {ids_file_path, ids_file} = Printer.print_ids(translations, "Translations")

    expected_ids_file = ~S"""
    module Translations.Ids exposing (TranslationId(..))

    type TranslationId
        = TidNext
        | TidNo
        | TidPrevious
        | TidYes
    """

    assert ids_file_path == "./Translations/Ids.elm"
    assert ids_file == expected_ids_file
  end

  test "prints util file" do

    translations = [
      %Translation{
        language_tag: "da_DK",
        translations: [
          {"TidNext", "Næste"},
          {"TidNo", "Nej"},
          {"TidPrevious", "Forrige"},
          {"TidYes", "Ja"}
        ]
      },

      %Translation{
        language_tag: "en_US",
        translations: [
          {"TidNext", "Next"},
          {"TidNo", "No"},
          {"TidPrevious", "Previous"},
          {"TidYes", "Yes"}
        ]
      }
    ]

    {util_file_path, util_file} = Printer.print_util(translations, "Translations")

    expected_util_file = ~S"""
    module Translations.Util exposing (parseLanguage, translate, LanguageTag(..))

    import Translations.Ids exposing (TranslationId)
    import Translations.DaDk exposing (daDkTranslations)
    import Translations.EnUs exposing (enUsTranslations)


    type LanguageTag
        = DA_DK
        | EN_US

    parseLanguage : String -> LanguageTag
    parseLanguage tag =
        case tag of
            "da_DK" ->
                DA_DK

            "en_US" ->
                EN_US

            _ ->
                Debug.log
                    ("Unknown language: '" ++ tag ++ "', defaulting to English")
                    EN_US


    translate : LanguageTag -> TranslationId -> String
    translate languageTag translationId =
        let
            translateFun =
                case languageTag of
                    DA_DK ->
                        daDkTranslations

                    EN_US ->
                        enUsTranslations

        in
            translateFun translationId
    """

    assert util_file_path == "./Translations/Util.elm"
    assert util_file == expected_util_file
  end

end