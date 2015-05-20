class BetterStruct
  EMPTY_STRING = "".freeze
  UNDERSCORE_SIGN = "_".freeze

  TRANSLITERATION_FROM = "ÀÁÂÃÄÅàáâãäåĀāĂăĄąÇçĆćĈĉĊċČčÐðĎďĐđÈÉÊËèéêëĒēĔĕĖėĘęĚěĜĝĞğĠġĢģĤĥĦħÌÍÎÏìíîïĨĩĪīĬĭĮįİıĴĵĶķĸĹĺĻļĽľĿŀŁłÑñŃńŅņŇňŉŊŋÒÓÔÕÖØòóôõöøŌōŎŏŐőŔŕŖŗŘřŚśŜŝŞşŠšſŢţŤťŦŧÙÚÛÜùúûüŨũŪūŬŭŮůŰűŲųŴŵÝýÿŶŷŸŹźŻżŽž".freeze
  TRANSLITERATION_TO   = "AAAAAAaaaaaaAaAaAaCcCcCcCcCcDdDdDdEEEEeeeeEeEeEeEeEeGgGgGgGgHhHhIIIIiiiiIiIiIiIiIiJjKkkLlLlLlLlLlNnNnNnNnnNnOOOOOOooooooOoOoOoRrRrRrSsSsSsSssTtTtTtUUUUuuuuUuUuUuUuUuUuWwYyyYyYZzZzZz".freeze

  DIGIT_REGEXP = /[0-9]/.freeze
  NOT_UNDERSCORED_REGEXP = /[^a-z0-9_]/.freeze
  NON_ENGLISH_REGEXP = /[#{ TRANSLITERATION_FROM }]/.freeze
  UNDERSCORE_DUPLICATES_REGEXP = /#{ UNDERSCORE_SIGN }{2,}/.freeze
  UNDERSCORE_END_REGEXP = /#{ UNDERSCORE_SIGN }$/.freeze
  CAMELCASE_ABBREVIATION_REGEX = /([A-Z\d]+)([A-Z][a-z])/.freeze
  CAMELCASE_REGEX = /([a-z\d])([A-Z])/.freeze

  UNDERSCORE_MASK = '\1_\2'.freeze

private

  def methodize(string)
    if string[0] =~ DIGIT_REGEXP
      duplicated_string = string.dup
      duplicated_string.prepend(UNDERSCORE_SIGN)
    end

    unless string =~ NOT_UNDERSCORED_REGEXP
      return duplicated_string || string
    end

    duplicated_string = string.dup if duplicated_string.nil?

    transliterate!(duplicated_string)
    underscore!(duplicated_string)

    duplicated_string
  end

  def transliterate!(string)
    if string =~ NON_ENGLISH_REGEXP
      string.tr!(TRANSLITERATION_FROM, TRANSLITERATION_TO)
    end
  end

  def underscore!(string)
    if string =~ NOT_UNDERSCORED_REGEXP
      string.gsub!(CAMELCASE_ABBREVIATION_REGEX, UNDERSCORE_MASK)
      string.gsub!(CAMELCASE_REGEX, UNDERSCORE_MASK)
      string.downcase!
      string.gsub!(NOT_UNDERSCORED_REGEXP, UNDERSCORE_SIGN)
      string.gsub!(UNDERSCORE_DUPLICATES_REGEXP, UNDERSCORE_SIGN)
      string.gsub!(UNDERSCORE_END_REGEXP, EMPTY_STRING)
    end
  end
end
