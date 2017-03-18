module ConfigCenter

  module GeneralValidations

    # xxxx@yyyy.zzz format
    EMAIL_FORMAT_REG_EXP = /\A(|(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6})\z/i

    # xxx-xxx-xxxx format
    MOBILE_FORMAT_REG_EXP = /\A([0-9\(\)\/\+ \-]){3}-([0-9\(\)\/\+ \-]){3}-([0-9\(\)\/\+ \-]){4}\z/i

    # xxx-xxx-xxxx format
    PHONE_FORMAT_REG_EXP = /\A\(([0-9\(\)\/\+ \-]){3}\) ([0-9\(\)\/\+ \-]){3}-([0-9\(\)\/\+ \-]){4}\z/i

    # Generic Name
    # a to z (both upper and lower case), 1 to 9, space, dot(.) and curly brackets "(" & ")" allowed.
    NAME_MIN_LEN = 2
    NAME_MAX_LEN = 256
    NAME_FORMAT_REG_EXP = /\A[a-zA-Z1-9\-\ \(\)\.+]*\z/i

    # User Name
    # Minimum length is 6 by default and maximum length is 32 by default
    # Only characters (both upper and lowercase), numbers, dot(.), underscore (_)
    # No spaces, hyphen or any other special characters are allowed
    USERNAME_MIN_LEN = 6
    USERNAME_MAX_LEN = 128
    USERNAME_FORMAT_REG_EXP = /\A[a-zA-Z0-9\_]*\z/

    # Password
    # should have atleast 1 Character (a to z (both upper and lower case))
    # and 1 Number (1 to 9)
    # and 1 Special Character from (!,@,$,&,*,_)",
    PASSWORD_MIN_LEN = 7
    PASSWORD_MAX_LEN = 256
    PASSWORD_FORMAT_REG_EXP = /\A(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9!@$#&*_\.,;:])/
    # PASSWORD_FORMAT_REG_EXP = /\A(?=.*?[a-z][A-Z])(?=.*?\d)(?=.*?[!@$&*_])/i

  end

  module Defaults

    # the default number of milli seconds for which resource listing pages gets refreshed:
    REFRESH_PAGE_IN_MILLI_SECONDS = 180000

    # It will list 10 items per page unless user request to load more (this is done by passing 'per_page' in url)
    ITEMS_PER_LIST = 40
    # It will override the per_page to 10 (default val - ITEMS_PER_LIST), in case if the user request for more items to load in a single listing page.
    # i.e if user passes per_page=251 (greater than MAX_ITEMS_PER_LIST), system will ignore it and fall back to default no of items to be listed in a page (ITEMS_PER_LIST)
    MAX_ITEMS_PER_LIST = 250

    # Default password to be assigned while mocking a user
    PASSWORD = "Password@1"

    # Other constans should follow here.
    EXCLUDED_JSON_ATTRIBUTES = [:created_at, :updated_at]

    SESSION_TIME_OUT = 30.minutes
    
  end

end
