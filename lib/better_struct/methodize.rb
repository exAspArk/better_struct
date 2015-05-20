class BetterStruct
  EMPTY_STRING = "".freeze
  UNDERSCORE_SIGN = "_".freeze

  TRANSLITERATION_FROM = "ÀÁÂÃÄÅàáâãäåĀāĂăĄąÇçĆćĈĉĊċČčÐðĎďĐđÈÉÊËèéêëĒēĔĕĖėĘęĚěĜĝĞğĠġĢģĤĥĦħÌÍÎÏìíîïĨĩĪīĬĭĮįİıĴĵĶķĸĹĺĻļĽľĿŀŁłÑñŃńŅņŇňŉŊŋÒÓÔÕÖØòóôõöøŌōŎŏŐőŔŕŖŗŘřŚśŜŝŞşŠšſŢţŤťŦŧÙÚÛÜùúûüŨũŪūŬŭŮůŰűŲųŴŵÝýÿŶŷŸŹźŻżŽž".freeze
  TRANSLITERATION_TO   = "AAAAAAaaaaaaAaAaAaCcCcCcCcCcDdDdDdEEEEeeeeEeEeEeEeEeGgGgGgGgHhHhIIIIiiiiIiIiIiIiIiJjKkkLlLlLlLlLlNnNnNnNnnNnOOOOOOooooooOoOoOoRrRrRrSsSsSsSssTtTtTtUUUUuuuuUuUuUuUuUuUuWwYyyYyYZzZzZz".freeze

  NON_UNDERSCORED_BEGIN_OR_END_REGEXP = /^[^a-z0-9_]+|[^a-z0-9_]+$/.freeze
  BEFORE_FIRST_DIGIT_OR_NON_UNDERSCORED_REGEXP = /^(.)?(?=[0-9])|[^a-z0-9_]/.freeze
  NON_ENGLISH_REGEXP = /[#{ TRANSLITERATION_FROM }]/.freeze
  UNDERSCORE_DUPLICATES_REGEXP = /#{ UNDERSCORE_SIGN }{2,}/.freeze
  CAMELCASE_ABBREVIATION_REGEX = /([A-Z\d]+)([A-Z][a-z])/.freeze
  CAMELCASE_REGEX = /([a-z\d])([A-Z])/.freeze

  UNDERSCORE_MASK = '\1_\2'.freeze

private

  def __methodize(string)
    return string if __methodized?(string)

    duplicated_string = string.dup

    __transliterate!(duplicated_string)
    __underscore!(duplicated_string)

    duplicated_string
  end

  def __methodized?(string)
    !string =~ BEFORE_FIRST_DIGIT_OR_NON_UNDERSCORED_REGEXP && !string =~ UNDERSCORE_DUPLICATES_REGEXP
  end

  def __transliterate!(string)
    if string =~ NON_ENGLISH_REGEXP
      string.tr!(TRANSLITERATION_FROM, TRANSLITERATION_TO)
    end
  end

  def __underscore!(string)
    string.gsub!(CAMELCASE_ABBREVIATION_REGEX, UNDERSCORE_MASK)
    string.gsub!(CAMELCASE_REGEX, UNDERSCORE_MASK)
    string.downcase!
    string.gsub!(NON_UNDERSCORED_BEGIN_OR_END_REGEXP, EMPTY_STRING)
    string.gsub!(BEFORE_FIRST_DIGIT_OR_NON_UNDERSCORED_REGEXP, UNDERSCORE_SIGN)
    string.gsub!(UNDERSCORE_DUPLICATES_REGEXP, UNDERSCORE_SIGN)
  end
end
