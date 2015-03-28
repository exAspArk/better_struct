class BetterStruct
  EMPTY_STRING = "".freeze
  UNDERSCORE_SIGN = "_".freeze

  TRANSLITERATION_FROM = "ÀÁÂÃÄÅàáâãäåĀāĂăĄąÇçĆćĈĉĊċČčÐðĎďĐđÈÉÊËèéêëĒēĔĕĖėĘęĚěĜĝĞğĠġĢģĤĥĦħÌÍÎÏìíîïĨĩĪīĬĭĮįİıĴĵĶķĸĹĺĻļĽľĿŀŁłÑñŃńŅņŇňŉŊŋÒÓÔÕÖØòóôõöøŌōŎŏŐőŔŕŖŗŘřŚśŜŝŞşŠšſŢţŤťŦŧÙÚÛÜùúûüŨũŪūŬŭŮůŰűŲųŴŵÝýÿŶŷŸŹźŻżŽž".freeze
  TRANSLITERATION_TO   = "AAAAAAaaaaaaAaAaAaCcCcCcCcCcDdDdDdEEEEeeeeEeEeEeEeEeGgGgGgGgHhHhIIIIiiiiIiIiIiIiIiJjKkkLlLlLlLlLlNnNnNnNnnNnOOOOOOooooooOoOoOoRrRrRrSsSsSsSssTtTtTtUUUUuuuuUuUuUuUuUuUuWwYyyYyYZzZzZz".freeze

  UPCASE_REGEXP = /[A-Z]/.freeze
  NOT_UNDERSCORED_REGEXP = /[^a-z0-9_]/.freeze
  NON_ENGLISH_REGEXP = /[#{ TRANSLITERATION_FROM }]/.freeze
  UNDERSCORE_DUPLICATES_REGEXP = /#{ UNDERSCORE_SIGN }{2,}/.freeze
  UNDERSCORE_BEGIN_OR_END_REGEXP = /^#{ UNDERSCORE_SIGN }|#{ UNDERSCORE_SIGN }$/.freeze
  CAMELCASE_ABBREVIATION_REGEX = /([A-Z\d]+)([A-Z][a-z])/.freeze
  CAMELCASE_REGEX = /([a-z\d])([A-Z])/.freeze

  UNDERSCORE_MASK = '\1_\2'.freeze

private

  def methodize(string)
    return string unless string =~ NOT_UNDERSCORED_REGEXP

    string = string.dup

    transliterate!(string)
    underscore!(string)
    string
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
      string.gsub!(UNDERSCORE_BEGIN_OR_END_REGEXP, EMPTY_STRING)
    end
  end
end
