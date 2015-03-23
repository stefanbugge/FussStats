User = require '../models/user'
express = require 'express'
router = express.Router()

router.route('/users').get (req, res) ->
  User.find (err, users) ->
    if err
      return res.send err
    res.json users

router.route('/users/:id').get (req, res) ->
  User.findOne(_id: req.params.id).exec (err, user) ->
    if err
      return res.send err
    res.json user

module.exports = router