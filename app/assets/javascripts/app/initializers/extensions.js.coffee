Array.prototype.first = Array.prototype.first || ->
  _(this).first()

_.mixin(_.string.exports()) # Pull _.str methods into _
