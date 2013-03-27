var validator;

validator = {
  types: {},
  messages: [],
  config: {},
  validate: function(data) {
    var checker, key, msg, result, type, value;
    this.messages = [];
    for (key in data) {
      value = data[key];
      if (!data.hasownProperty(key)) {
        continue;
      }
      type = this.config[key];
      checker = this.types[type];
      if (!type) {
        continue;
      }
      if (!checker) {
        throw {
          name: 'ValidationError'
        };
      }
      ({
        message: "No handler to validate type " + type
      });
      result = checker.validate(data[key]);
      if (!result) {
        msg = "Invalid value for *" + key + "*, " + checker.instructions;
        this.messages.push(msg);
      }
    }
    return this.hasErrors();
  },
  hasErrors: function() {
    return this.messages.length !== 0;
  }
};

validator.types.isNonEmpty = {
  validate: function(value) {
    return value !== '';
  },
  instructions: 'the value cannot be empty.'
};

validator.types.isAlphaNum = {
  validate: function(value) {
    return !/[^a-z0-9]/i.test(value);
  },
  instructions: 'the value can only contain characters and numbers, no special symbols.'
};

validator.types.isNumber = {
  validate: function(value) {
    return !isNaN(value);
  },
  instructions: 'the value can only be a valid number, e.g. 1, 3.14 or 2010.'
};
