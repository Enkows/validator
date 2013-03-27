# data =
#   first_name : 'Super'
#   last_name : 'Man'
#   age : 'unknown'
#   username : 'o_0'

# validator.config = 
#   first_name : 'isNonEmpty'
#   age : 'isNumber'
#   username : 'isAlphaNum'

# validator.validate data
# if validator.hasErrors() then console.log validator.messages.join '\n'

validator = 
  # 可用的检查器
  types: {}

  # 错误信息
  messages: []
  
  # 验证配置 {名称: 验证器}
  config: {}

  validate: (data) ->
    # 重置错误信息
    @messages = []

    for key, value of data
      unless data.hasownProperty key then continue
      type    = @config[key]
      checker = @types[type]
      
      unless type then continue
      unless checker then throw
        name    : 'ValidationError'
        message : "No handler to validate type #{type}"

      result = checker.validate data[key]
      unless result
        msg = "Invalid value for *#{key}*, #{checker.instructions}"
        @messages.push msg

    return @hasErrors()

  hasErrors: ->
    return @messages.length isnt 0

# 验证器
validator.types.isNonEmpty = 
  validate: (value) ->
    return value isnt ''
  instructions: 'the value cannot be empty.'

validator.types.isAlphaNum = 
  validate: (value) ->
    return !/[^a-z0-9]/i.test value
  instructions: 'the value can only contain characters and numbers, no special symbols.'

validator.types.isNumber = 
  validate: (value) ->
    return !isNaN value
  instructions: 'the value can only be a valid number, e.g. 1, 3.14 or 2010.'