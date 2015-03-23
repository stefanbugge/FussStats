mongoose = require 'mongoose'
autoIncrement = require 'mongoose-auto-increment'

autoIncrement.initialize(mongoose)

validateUniqueEmail = (value, callback) ->
  User = mongoose.model('User')
  User.find { $and: [
    { email: value }
    { _id: $ne: @_id }
  ] }, (err, user) ->
    callback err or user.length == 0


userSchema = mongoose.Schema(
  name:
    type: String
    required: true
  email:
    type: String
    required: true
    unique: true
    match: [
      /.+\@.+\..+/
      'Please enter a valid email'
    ]
    validate: [
      validateUniqueEmail
      'E-mail address is already in-use'
    ]
  username:
    type: String
    unique: true
    required: true
  roles:
    type: Array
    default: [ 'authenticated' ]
  google: {}
)

userSchema.plugin(autoIncrement.plugin, {model:'User',startAt:1});

module.exports = mongoose.model 'User', userSchema